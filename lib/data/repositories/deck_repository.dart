import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/deck.dart';

class DeckRepository {
  static const String _decksKey = 'saved_decks';
  final SharedPreferences _prefs;

  DeckRepository(this._prefs);

  /// Load all decks from SharedPreferences
  Future<List<Deck>> loadDecks() async {
    final jsonString = _prefs.getString(_decksKey);
    if (jsonString == null || jsonString.isEmpty) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) => Deck.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      // If corrupted, return empty list
      return [];
    }
  }

  /// Save the entire list of decks
  Future<void> saveDecks(List<Deck> decks) async {
    final jsonList = decks.map((d) => d.toJson()).toList();
    await _prefs.setString(_decksKey, jsonEncode(jsonList));
  }

  /// Add a new deck (convenience)
  Future<void> addDeck(Deck deck) async {
    final decks = await loadDecks();
    decks.add(deck);
    await saveDecks(decks);
  }

  /// Update an existing deck (by id)
  Future<void> updateDeck(Deck updatedDeck) async {
    final decks = await loadDecks();
    final index = decks.indexWhere((d) => d.id == updatedDeck.id);
    if (index != -1) {
      decks[index] = updatedDeck;
      await saveDecks(decks);
    }
  }

  /// Delete a deck by id
  Future<void> deleteDeck(String id) async {
    final decks = await loadDecks();
    decks.removeWhere((d) => d.id == id);
    await saveDecks(decks);
  }

  /// Get a single deck by id (returns null if not found)
  Future<Deck?> getDeckById(String id) async {
    final decks = await loadDecks();
    try {
      return decks.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }
}