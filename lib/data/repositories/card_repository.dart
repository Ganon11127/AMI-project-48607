// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import '../services/api/local_data_service.dart';
import '../models/card_model.dart';
import 'card_repository_interface.dart';

class CardRepositoryImp implements CardRepository {
  final LocalDataService _localDataService;

  /// to avoid repeatedly parsing the same JSON.
  final Map< String, List< CardModel > > _cache = {};

  CardRepositoryImp( this._localDataService );

  // loads and caches cards for a given language
  Future<List<CardModel>> _loadCardsForLanguage(String languageCode) async {
    if (_cache.containsKey(languageCode)) {
      return _cache[languageCode]!;
    }
    final rawCardsJson = await _localDataService.loadCards(languageCode: languageCode);
    final cards = rawCardsJson.map((json) => CardModel.fromJson(json)).toList();
    _cache[languageCode] = cards;
    return cards;
  }

  @override
  Future<CardModel?> searchCardById(int id, String languageCode) async {
    final cards = await _loadCardsForLanguage(languageCode);
    try {
      return cards.firstWhere((card) => card.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future< CardModel? > searchCard( String searchQuery, String languageCode ) async {
    debugPrint( 'searchCard called with query: "$searchQuery", language: "$languageCode"' );

    // check if language data is loaded and cached
    List< CardModel > cards;

    if ( _cache.containsKey( languageCode ) ) {
      cards = _cache[ languageCode ]!;
    } else {
      try {
        final rawCardsJson = await _localDataService.loadCards( languageCode: languageCode );
        cards = rawCardsJson.map( ( json ) => CardModel.fromJson( json ) ).toList();
        _cache[ languageCode ] = cards;
      } catch ( e ) {
        debugPrint( 'Error loading cards for $languageCode: $e' );
        return null;
      }
    }

    // fuzzy search on the list of card names
    if ( cards.isEmpty ) return null;

    final choices = cards.map( ( card ) => card.name ).toList();

    // use extractAll to find the all matches that meet the threshold of 80.
    final bestMatches = extractAll(
      query: searchQuery,
      choices: choices,
      cutoff: 80,
    );

    if ( bestMatches.isEmpty ) return null;

    // sort by score descending, then by name length difference ascending
    bestMatches.sort( ( a, b ) {
      if ( a.score != b.score ) return b.score.compareTo( a.score );

      final lenDiffA = ( a.choice.length - searchQuery.length ).abs();
      final lenDiffB = ( b.choice.length - searchQuery.length ).abs();

      return lenDiffA.compareTo( lenDiffB );
    });

    // return the matched card or empty if no match found
    final bestMatch = bestMatches.first;
    return cards[ bestMatch.index ];
  }

  /// Returns all cards for the given language, using the cache.
  @override
  Future<List<CardModel>> getAllCards(String languageCode) async {
    return await _loadCardsForLanguage(languageCode);
  }
}