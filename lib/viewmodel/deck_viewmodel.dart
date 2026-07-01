import 'package:flutter/material.dart';
import '../data/models/deck.dart';
import '../data/repositories/deck_repository.dart';
import '../data/services/api/favourites_service.dart'; 

class DeckViewModel extends ChangeNotifier {
  final DeckRepository _repository;
  final FavouritesService _favouritesService;
  List<Deck> _allDecks = [];
  String _searchQuery = '';

  DeckViewModel(this._repository, this._favouritesService) {
    loadDecks();
  }

  // Getters
  List<Deck> get filteredDecks => _searchQuery.isEmpty
      ? _allDecks
      : _allDecks.where((d) => d.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

  String get searchQuery => _searchQuery;

  // Load from repository
  Future<void> loadDecks() async {
    _allDecks = await _repository.loadDecks();
    notifyListeners();
  }

  // Search
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Actions that modify a deck
  Future<void> toggleFavourite(String id) async {
    final deck = _findDeck(id);
    if (deck != null) {
      deck.isFavourite = !deck.isFavourite;
      await _repository.updateDeck(deck);
      await _favouritesService.toggleDeckFavourite(id);
      await loadDecks();
    }
  }

  Future<void> toggleWishlist(String id) async {
    final deck = _findDeck(id);
    if (deck != null) {
      deck.isWishlist = !deck.isWishlist;
      await _repository.updateDeck(deck);
      await _favouritesService.toggleDeckWishlist(id);
      await loadDecks();
    }
  }

  Future<void> updateDeckName(String id, String newName) async {
    final deck = _findDeck(id);
    if (deck != null && newName.trim().isNotEmpty) {
      deck.name = newName.trim();
      await _repository.updateDeck(deck);
      await loadDecks();
    }
  }

  Future<void> updateDeckColor(String id, String newColor) async {
    final deck = _findDeck(id);
    if (deck != null && newColor.trim().isNotEmpty) {
      deck.colorHex = newColor.trim();
      await _repository.updateDeck(deck);
      await loadDecks();
    }
  }

  Future<void> deleteDeck(String id) async {
    await _repository.deleteDeck(id);
    final favIds = await _favouritesService.getDeckFavouriteIds();
    if (favIds.contains(id)) {
      favIds.remove(id);
      await _favouritesService.setDeckFavouriteIds(favIds);
    }
    final wishIds = await _favouritesService.getDeckWishlistIds();
    if (wishIds.contains(id)) {
      wishIds.remove(id);
      await _favouritesService.setDeckWishlistIds(wishIds);
    }
    await loadDecks();
  }

  // Create a new deck with default values
  Future<Deck> createDeck() async {
    final newDeck = Deck(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Deck',
      colorHex: '#1a73e8',
    );
    await _repository.addDeck(newDeck);
    await loadDecks();
    return newDeck;
  }

  Deck? _findDeck(String id) {
    try {
      return _allDecks.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }
}