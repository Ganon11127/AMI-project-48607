import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesService {
  static const String _cardWishlistKey = 'favourite_card_ids';
  static const String _deckFavouritesKey = 'deck_favourite_ids';
  static const String _deckWishlistKey = 'deck_wishlist_ids';
  static const String _cardBookmarkKey = 'card_bookmark_ids';
  final SharedPreferences _prefs;

  FavouritesService(this._prefs);

  // ----- Card Wishlist -----
  Future<Set<int>> getFavouriteIds() async {
    final jsonString = _prefs.getString(_cardWishlistKey);
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      final List<dynamic> list = jsonDecode(jsonString);
      return list.map((e) => e as int).toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> setFavouriteIds(Set<int> ids) async {
    final list = ids.toList();
    await _prefs.setString(_cardWishlistKey, jsonEncode(list));
  }

  Future<void> toggleCardWishlist(int cardId) async {
    final ids = await getFavouriteIds();
    if (ids.contains(cardId)) {
      ids.remove(cardId);
    } else {
      ids.add(cardId);
    }
    await setFavouriteIds(ids);
  }

  Future<bool> isCardWishlisted(int cardId) async {
    final ids = await getFavouriteIds();
    return ids.contains(cardId);
  }

  // ----- Deck Favourites -----
  Future<Set<String>> getDeckFavouriteIds() async {
    final jsonString = _prefs.getString(_deckFavouritesKey);
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      final List<dynamic> list = jsonDecode(jsonString);
      return list.map((e) => e as String).toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> setDeckFavouriteIds(Set<String> ids) async {
    final list = ids.toList();
    await _prefs.setString(_deckFavouritesKey, jsonEncode(list));
  }

  Future<void> toggleDeckFavourite(String deckId) async {
    final ids = await getDeckFavouriteIds();
    if (ids.contains(deckId)) {
      ids.remove(deckId);
    } else {
      ids.add(deckId);
    }
    await setDeckFavouriteIds(ids);
  }

  Future<bool> isDeckFavourite(String deckId) async {
    final ids = await getDeckFavouriteIds();
    return ids.contains(deckId);
  }

  // ----- Deck Wishlist -----
  Future<Set<String>> getDeckWishlistIds() async {
    final jsonString = _prefs.getString(_deckWishlistKey);
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      final List<dynamic> list = jsonDecode(jsonString);
      return list.map((e) => e as String).toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> setDeckWishlistIds(Set<String> ids) async {
    final list = ids.toList();
    await _prefs.setString(_deckWishlistKey, jsonEncode(list));
  }

  Future<void> toggleDeckWishlist(String deckId) async {
    final ids = await getDeckWishlistIds();
    if (ids.contains(deckId)) {
      ids.remove(deckId);
    } else {
      ids.add(deckId);
    }
    await setDeckWishlistIds(ids);
  }

  Future<bool> isDeckWishlisted(String deckId) async {
    final ids = await getDeckWishlistIds();
    return ids.contains(deckId);
  }

  // ----- Card Bookmark -----
  Future<Set<int>> getCardBookmarkIds() async {
    final jsonString = _prefs.getString(_cardBookmarkKey);
    if (jsonString == null || jsonString.isEmpty) return {};
    try {
      final List<dynamic> list = jsonDecode(jsonString);
      return list.map((e) => e as int).toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> setCardBookmarkIds(Set<int> ids) async {
    final list = ids.toList();
    await _prefs.setString(_cardBookmarkKey, jsonEncode(list));
  }

  Future<void> toggleCardBookmark(int cardId) async {
    final ids = await getCardBookmarkIds();
    if (ids.contains(cardId)) {
      ids.remove(cardId);
    } else {
      ids.add(cardId);
    }
    await setCardBookmarkIds(ids);
  }

  Future<bool> isCardBookmarked(int cardId) async {
    final ids = await getCardBookmarkIds();
    return ids.contains(cardId);
  }
}