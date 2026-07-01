import 'package:flutter/foundation.dart';
import '../data/models/deck.dart';
import '../data/models/card_model.dart';
import '../data/repositories/deck_repository.dart';
import '../data/repositories/card_repository_interface.dart';
import '../data/services/api/favourites_service.dart';
import '../data/services/api/user_settings.dart';

class HomeViewModel extends ChangeNotifier {
  final DeckRepository _deckRepository;
  final CardRepository _cardRepository;
  final FavouritesService _favouritesService;
  final UserSettings _userSettings;

  List<Deck> _favouriteDecks = [];
  List<Deck> _wishlistDecks = [];
  List<CardModel> _wishlistCards = [];
  List<CardModel> _bookmarkedCards = [];

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Deck> get favouriteDecks => _favouriteDecks;
  List<Deck> get wishlistDecks => _wishlistDecks;
  List<CardModel> get wishlistCards => _wishlistCards;
  List<CardModel> get bookmarkedCards => _bookmarkedCards;

  HomeViewModel({
    required DeckRepository deckRepository,
    required CardRepository cardRepository,
    required FavouritesService favouritesService,
    required UserSettings userSettings,
  }) : _deckRepository = deckRepository,
       _cardRepository = cardRepository,
       _favouritesService = favouritesService,
       _userSettings = userSettings {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    debugPrint('HomeViewModel: Loading data...');

    final allDecks = await _deckRepository.loadDecks();
    debugPrint('HomeViewModel: Loaded ${allDecks.length} decks');

    // Load deck favourite and wishlist IDs from FavouritesService
    final deckFavouriteIds = await _favouritesService.getDeckFavouriteIds();
    final deckWishlistIds = await _favouritesService.getDeckWishlistIds();
    debugPrint('HomeViewModel: Deck favourite IDs: ${deckFavouriteIds.length}');
    debugPrint('HomeViewModel: Deck wishlist IDs: ${deckWishlistIds.length}');

    _favouriteDecks = allDecks.where((d) => deckFavouriteIds.contains(d.id)).toList();
    _wishlistDecks = allDecks.where((d) => deckWishlistIds.contains(d.id)).toList();

    debugPrint('HomeViewModel: Favourite decks: ${_favouriteDecks.length}');
    debugPrint('HomeViewModel: Wishlist decks: ${_wishlistDecks.length}');

    final lang = await _userSettings.getTargetLanguage();
    final allCards = await _cardRepository.getAllCards(lang);
    debugPrint('HomeViewModel: Loaded ${allCards.length} cards');

    // Wishlisted cards (using FavouritesService)
    final wishlistIds = await _favouritesService.getFavouriteIds();
    debugPrint('HomeViewModel: Wishlist card IDs: ${wishlistIds.length}');
    _wishlistCards = allCards.where((c) => wishlistIds.contains(c.id)).toList();

    // Bookmarked cards (using FavouritesService)
    final bookmarkedIds = await _favouritesService.getCardBookmarkIds();
    debugPrint('HomeViewModel: Bookmarked card IDs: ${bookmarkedIds.length}');
    _bookmarkedCards = allCards.where((c) => bookmarkedIds.contains(c.id)).toList();

    debugPrint('HomeViewModel: Wishlist cards: ${_wishlistCards.length}');
    debugPrint('HomeViewModel: Bookmarked cards: ${_bookmarkedCards.length}');

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    debugPrint('HomeViewModel: Refresh called');
    await _loadData();
  }
}