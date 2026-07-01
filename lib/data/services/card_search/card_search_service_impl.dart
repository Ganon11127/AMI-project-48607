import 'package:flutter/foundation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

import '../../models/card_model.dart';
import '../../repositories/card_repository_interface.dart';
import '../api/user_settings.dart';
import 'card_search_service.dart';

class CardSearchServiceImpl implements CardSearchService {
  final CardRepository _cardRepository;
  final UserSettings _userSettings;

  CardSearchServiceImpl(this._cardRepository, this._userSettings);

  @override
  Future<CardModel?> searchCard(String query) async {
    if (query.isEmpty) return null;
    final cleanedQuery = _cleanOcrText(query);

    // Load all card data for each language+
    final languages = ['', 'fr', 'de', 'it', 'pt'];
    final Map<String, List<Map<String, dynamic>>> languageData = {};
    for (final lang in languages) {
      final cards = await _cardRepository.getAllCards(lang);
      final nameIdPairs = cards.map((c) => {
        'id': c.id,
        'name': c.name,
      }).toList();
      languageData[lang] = nameIdPairs;
    }

    // Run the heavy search in a separate isolate
    final result = await compute(_searchInIsolate, {
      'query': cleanedQuery,
      'languageData': languageData,
    });

    if (result == null) return null;

    final int id = result['id'];
    final targetLang = await _userSettings.getTargetLanguage();
    // Try to get the card in the user's target language, fallback to English
    CardModel? card = await _cardRepository.searchCardById(id, targetLang);
    return card ?? await _cardRepository.searchCardById(id, '');
  }

  String _cleanOcrText(String raw) {
    return raw.replaceAll('\n', ' ').trim();
  }

  static Future<Map<String, dynamic>?> _searchInIsolate(Map<String, dynamic> args) async {
    final String query = args['query'] as String;
    final Map<String, List<Map<String, dynamic>>> languageData =
        args['languageData'] as Map<String, List<Map<String, dynamic>>>;

    final String cleanedQuery = query.trim().toLowerCase();

    // Exact match first
    for (final entry in languageData.entries) {
      final List<Map<String, dynamic>> cards = entry.value;
      for (final card in cards) {
        if ((card['name'] as String).toLowerCase() == cleanedQuery) {
          return {'id': card['id'] as int};
        }
      }
    }

    // Fuzzy search across all languages
    List<Map<String, dynamic>> allMatches = [];
    for (final entry in languageData.entries) {
      final List<Map<String, dynamic>> cards = entry.value;
      final List<String> names = cards.map((c) => c['name'] as String).toList();
      final List<int> ids = cards.map((c) => c['id'] as int).toList();

      final matches = extractAll(
        query: cleanedQuery,
        choices: names,
        cutoff: 80,
      );

      for (final match in matches) {
        allMatches.add({
          'id': ids[match.index],
          'score': match.score,
          'lengthDiff': (match.choice.length - cleanedQuery.length).abs(),
        });
      }
    }

    if (allMatches.isEmpty) return null;

    allMatches.sort((a, b) {
      if (a['score'] != b['score']) return b['score'].compareTo(a['score']);
      return a['lengthDiff'].compareTo(b['lengthDiff']);
    });

    return {'id': allMatches.first['id']};
  }
}