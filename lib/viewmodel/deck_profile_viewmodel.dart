import 'package:flutter/material.dart';
import '../data/models/card_model.dart';
import '../data/models/deck.dart';
import '../data/repositories/card_repository_interface.dart';
import '../data/repositories/deck_repository.dart';
import '../data/services/api/favourites_service.dart';
import '../data/services/api/user_settings.dart';

class FilterOptions {
  Set<String> monsterTypes = {};
  Set<String> attributes = {};
  Set<String> races = {};
  Set<String> spellTrapTypes = {};
  int? minLevel, maxLevel;
  int? minPendulumScale, maxPendulumScale;
  int? minAtk, maxAtk;
  bool includeUnknownAtk = false;
  int? minDef, maxDef;
  bool includeUnknownDef = false;
  Set<String> banlistStatus = {};

  void clear() {
    monsterTypes.clear();
    attributes.clear();
    races.clear();
    spellTrapTypes.clear();
    minLevel = maxLevel = null;
    minPendulumScale = maxPendulumScale = null;
    minAtk = maxAtk = null;
    includeUnknownAtk = false;
    minDef = maxDef = null;
    includeUnknownDef = false;
    banlistStatus.clear();
  }

  bool get isNotEmpty =>
      monsterTypes.isNotEmpty ||
      attributes.isNotEmpty ||
      races.isNotEmpty ||
      spellTrapTypes.isNotEmpty ||
      minLevel != null ||
      maxLevel != null ||
      minPendulumScale != null ||
      maxPendulumScale != null ||
      minAtk != null ||
      maxAtk != null ||
      includeUnknownAtk ||
      minDef != null ||
      maxDef != null ||
      includeUnknownDef ||
      banlistStatus.isNotEmpty;
}

class DeckProfileViewModel extends ChangeNotifier {
  final DeckRepository _deckRepository;
  final CardRepository _cardRepository;
  final UserSettings _userSettings;
  final FavouritesService _favouritesService;

  Deck? _originalDeck;
  late Deck _workingDeck;
  List<CardModel> _allCards = [];
  List<CardModel> _filteredCards = [];

  bool _catalogCollapsed = false;
  String _searchText = '';
  String _cardTypeFilter = 'All';
  bool _wishlistOnly = false;
  bool _bookmarkOnly = false;
  final FilterOptions _advancedFilters = FilterOptions();
  String _sortType = 'Name';
  bool _sortAscending = true;

  Set<int> _wishlistIds = {};
  Set<int> _bookmarkedIds = {};

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  late VoidCallback _languageListener;

  bool _isDeleted = false;

  DeckProfileViewModel({
    required DeckRepository deckRepository,
    required CardRepository cardRepository,
    required UserSettings userSettings,
    required FavouritesService favouritesService,
    String? deckId,
  }) : _deckRepository = deckRepository,
       _cardRepository = cardRepository,
       _userSettings = userSettings,
       _favouritesService = favouritesService,
       _workingDeck = Deck(id: 'loading', name: 'Loading...', colorHex: '#000000') {
    _languageListener = () {
      _reloadCards();
    };
    _userSettings.addListener(_languageListener);
    _initialize(deckId);
  }

  Future<void> _initialize(String? deckId) async {
    if (deckId != null) {
      _originalDeck = await _deckRepository.getDeckById(deckId);
      _workingDeck = _originalDeck?.copyWith() ?? _createNewDeck();
    } else {
      _workingDeck = _createNewDeck();
    }
    _wishlistIds = await _favouritesService.getFavouriteIds();
    await _loadCards();
    _isLoading = false;
    _applyFiltersAndSort();
  }

  Future<void> _loadCards() async {
    final lang = await _userSettings.getTargetLanguage();
    _allCards = await _cardRepository.getAllCards(lang);
  }

  Future<void> _reloadCards() async {
    await _loadCards();
    _applyFiltersAndSort();
  }

  Deck _createNewDeck() => Deck(
    id: 'new_${DateTime.now().millisecondsSinceEpoch}',
    name: '',
    colorHex: '#000000',
  );

  String get deckId => _workingDeck.id;
  String get deckName => _workingDeck.name;
  String get deckColor => _workingDeck.colorHex;
  bool get isFavourite => _workingDeck.isFavourite;
  bool get isWishlist => _workingDeck.isWishlist;
  List<int> get mainDeckCardIds => _workingDeck.mainDeckCardIds;
  List<int> get extraDeckCardIds => _workingDeck.extraDeckCardIds;
  bool get isMainDeckLegal => mainDeckCardIds.length >= 40 && mainDeckCardIds.length <= 60;
  bool get isExtraDeckLegal => extraDeckCardIds.length <= 15;
  List<CardModel> get filteredCards => _filteredCards;
  bool get catalogCollapsed => _catalogCollapsed;
  String get searchText => _searchText;
  String get cardTypeFilter => _cardTypeFilter;
  bool get wishlistOnly => _wishlistOnly;
  bool get bookmarkOnly => _bookmarkOnly;
  FilterOptions get advancedFilters => _advancedFilters;
  String get sortType => _sortType;
  bool get sortAscending => _sortAscending;

  void setDeckName(String name) {
    _workingDeck.name = name.trim();
    notifyListeners();
  }

  void setDeckColor(String color) {
    _workingDeck.colorHex = color.trim();
    notifyListeners();
  }

  void toggleFavourite() {
    _workingDeck.isFavourite = !_workingDeck.isFavourite;
    _favouritesService.toggleDeckFavourite(_workingDeck.id);
    notifyListeners();
  }

  void toggleWishlist() {
    _workingDeck.isWishlist = !_workingDeck.isWishlist;
    _favouritesService.toggleDeckWishlist(_workingDeck.id);
    notifyListeners();
  }

  void addCardToMain(CardModel card) {
    final currentCount = _workingDeck.mainDeckCardIds.where((id) => id == card.id).length;
    if (currentCount >= 3) return;
    if (_workingDeck.mainDeckCardIds.length < 60) {
      _workingDeck.mainDeckCardIds.add(card.id);
      notifyListeners();
    }
  }

  void removeCardFromMain(int index) {
    if (index >= 0 && index < _workingDeck.mainDeckCardIds.length) {
      _workingDeck.mainDeckCardIds.removeAt(index);
      notifyListeners();
    }
  }

  void addCardToExtra(CardModel card) {
    final currentCount = _workingDeck.extraDeckCardIds.where((id) => id == card.id).length;
    if (currentCount >= 3) return;
    if (_workingDeck.extraDeckCardIds.length < 15) {
      _workingDeck.extraDeckCardIds.add(card.id);
      notifyListeners();
    }
  }

  void removeCardFromExtra(int index) {
    if (index >= 0 && index < _workingDeck.extraDeckCardIds.length) {
      _workingDeck.extraDeckCardIds.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> saveDeck() async {
    if (_isDeleted) return;
    if (_originalDeck == null) {
      await _deckRepository.addDeck(_workingDeck);
    } else {
      await _deckRepository.updateDeck(_workingDeck);
    }
  }

  Future<void> deleteDeck() async {
    if (_workingDeck.id == 'loading') return;
    await _deckRepository.deleteDeck(_workingDeck.id);
    // Remove from service lists
    final favIds = await _favouritesService.getDeckFavouriteIds();
    if (favIds.contains(_workingDeck.id)) {
      favIds.remove(_workingDeck.id);
      await _favouritesService.setDeckFavouriteIds(favIds);
    }
    final wishIds = await _favouritesService.getDeckWishlistIds();
    if (wishIds.contains(_workingDeck.id)) {
      wishIds.remove(_workingDeck.id);
      await _favouritesService.setDeckWishlistIds(wishIds);
    }
    _isDeleted = true;
    notifyListeners();
  }

  CardModel? getCardById(int id) {
    try {
      return _allCards.firstWhere((card) => card.id == id);
    } catch (_) {
      return null;
    }
  }

  bool isCardWishlisted(int cardId) => _wishlistIds.contains(cardId);
  bool isBookmarked(int cardId) => _bookmarkedIds.contains(cardId);

  Future<void> toggleCardWishlist(int cardId) async {
    await _favouritesService.toggleCardWishlist(cardId);
    if (_wishlistIds.contains(cardId)) {
      _wishlistIds.remove(cardId);
    } else {
      _wishlistIds.add(cardId);
    }
    if (_wishlistOnly) {
      _applyFiltersAndSort();
    } else {
      notifyListeners();
    }
  }

  Future<void> toggleBookmark(int cardId) async {
    await _favouritesService.toggleCardBookmark(cardId);
    if (_bookmarkedIds.contains(cardId)) {
      _bookmarkedIds.remove(cardId);
    } else {
      _bookmarkedIds.add(cardId);
    }
    if (_bookmarkOnly) {
      _applyFiltersAndSort();
    } else {
      notifyListeners();
    }
  }

  void toggleCatalogCollapsed() {
    _catalogCollapsed = !_catalogCollapsed;
    notifyListeners();
  }

  void setSearchText(String text) {
    _searchText = text;
    _applyFiltersAndSort();
  }

  void setCardTypeFilter(String type) {
    _cardTypeFilter = type;
    _applyFiltersAndSort();
  }

  void toggleWishlistOnly() {
    _wishlistOnly = !_wishlistOnly;
    _applyFiltersAndSort();
  }

  void toggleBookmarkOnly() {
    _bookmarkOnly = !_bookmarkOnly;
    _applyFiltersAndSort();
  }

  void setAdvancedFilters(FilterOptions newFilters) {
    _advancedFilters.monsterTypes = newFilters.monsterTypes;
    _advancedFilters.attributes = newFilters.attributes;
    _advancedFilters.races = newFilters.races;
    _advancedFilters.spellTrapTypes = newFilters.spellTrapTypes;
    _advancedFilters.minLevel = newFilters.minLevel;
    _advancedFilters.maxLevel = newFilters.maxLevel;
    _advancedFilters.minPendulumScale = newFilters.minPendulumScale;
    _advancedFilters.maxPendulumScale = newFilters.maxPendulumScale;
    _advancedFilters.minAtk = newFilters.minAtk;
    _advancedFilters.maxAtk = newFilters.maxAtk;
    _advancedFilters.includeUnknownAtk = newFilters.includeUnknownAtk;
    _advancedFilters.minDef = newFilters.minDef;
    _advancedFilters.maxDef = newFilters.maxDef;
    _advancedFilters.includeUnknownDef = newFilters.includeUnknownDef;
    _advancedFilters.banlistStatus = newFilters.banlistStatus;
    _applyFiltersAndSort();
  }

  void clearAdvancedFilters() {
    _advancedFilters.clear();
    _applyFiltersAndSort();
  }

  void setSortType(String type) {
    _sortType = type;
    _applyFiltersAndSort();
  }

  void toggleSortOrder() {
    _sortAscending = !_sortAscending;
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    var list = _allCards;

    if (_searchText.isNotEmpty) {
      final query = _searchText.toLowerCase();
      list = list.where((c) => c.name.toLowerCase().contains(query)).toList();
    }

    if (_cardTypeFilter != 'All') {
      list = list.where((c) {
        switch (_cardTypeFilter) {
          case 'Monster':
            return c.type.contains('Monster');
          case 'Spell':
            return c.type == 'Spell Card';
          case 'Trap':
            return c.type == 'Trap Card';
          case 'ExtraDeckMonster':
            const extraTypes = ['Fusion', 'Synchro', 'Xyz', 'Link'];
            return c.type.contains('Monster') &&
                extraTypes.any((t) => c.humanReadableType?.contains(t) ?? false);
          default:
            return true;
        }
      }).toList();
    }

    if (_wishlistOnly) {
      list = list.where((c) => _wishlistIds.contains(c.id)).toList();
    }
    if (_bookmarkOnly) {
      list = list.where((c) => _bookmarkedIds.contains(c.id)).toList();
    }

    list = _applyAdvancedFilters(list);
    _sortCards(list);

    _filteredCards = list;
    notifyListeners();
  }

  List<CardModel> _applyAdvancedFilters(List<CardModel> list) {
    final f = _advancedFilters;
    return list.where((card) {
      final isMonster = card.type.contains('Monster');

      if (f.monsterTypes.isNotEmpty && isMonster) {
        if (!f.monsterTypes.contains(card.humanReadableType)) return false;
      }
      if (f.spellTrapTypes.isNotEmpty && !isMonster) {
        if (!f.spellTrapTypes.contains(card.humanReadableType)) return false;
      }
      if (f.attributes.isNotEmpty && isMonster) {
        if (card.attribute == null || !f.attributes.contains(card.attribute)) return false;
      }
      if (f.races.isNotEmpty) {
        if (card.race == null || !f.races.contains(card.race)) return false;
      }
      if (isMonster) {
        final level = card.level ?? 0;
        if (f.minLevel != null && level < f.minLevel!) return false;
        if (f.maxLevel != null && level > f.maxLevel!) return false;
      }
      if (f.minPendulumScale != null || f.maxPendulumScale != null) {
        if (card.scale == null) return false;
        final scale = card.scale!;
        if (f.minPendulumScale != null && scale < f.minPendulumScale!) return false;
        if (f.maxPendulumScale != null && scale > f.maxPendulumScale!) return false;
      }
      if (f.minAtk != null || f.maxAtk != null || f.includeUnknownAtk) {
        if (card.atk == null) {
          if (!f.includeUnknownAtk) return false;
        } else {
          final atk = card.atk!;
          if (f.minAtk != null && atk < f.minAtk!) return false;
          if (f.maxAtk != null && atk > f.maxAtk!) return false;
        }
      }
      if (f.minDef != null || f.maxDef != null || f.includeUnknownDef) {
        if (card.def == null) {
          if (!f.includeUnknownDef) return false;
        } else {
          final def = card.def!;
          if (f.minDef != null && def < f.minDef!) return false;
          if (f.maxDef != null && def > f.maxDef!) return false;
        }
      }
      if (f.banlistStatus.isNotEmpty) {
        final info = card.banlistInfo;
        if (info == null) {
          if (!f.banlistStatus.contains('Unrestricted')) return false;
        } else {
          final status = info['ban_tcg'] ?? 'Unrestricted';
          if (!f.banlistStatus.contains(status)) return false;
        }
      }
      return true;
    }).toList();
  }

  void _sortCards(List<CardModel> list) {
    list.sort((a, b) {
      int result = 0;
      switch (_sortType) {
        case 'Name':
          result = a.name.compareTo(b.name);
          break;
        case 'Level':
          final aVal = a.level ?? a.link ?? 0;
          final bVal = b.level ?? b.link ?? 0;
          result = aVal.compareTo(bVal);
          break;
        case 'Rank':
          final aVal = a.level ?? 0;
          final bVal = b.level ?? 0;
          result = aVal.compareTo(bVal);
          break;
        case 'LinkRating':
          final aVal = a.link ?? 0;
          final bVal = b.link ?? 0;
          result = aVal.compareTo(bVal);
          break;
        case 'PendulumScale':
          final aVal = a.scale ?? 0;
          final bVal = b.scale ?? 0;
          result = aVal.compareTo(bVal);
          break;
        case 'Atk':
          final aVal = a.atk ?? -1;
          final bVal = b.atk ?? -1;
          result = aVal.compareTo(bVal);
          break;
        case 'Def':
          final aVal = a.def ?? -1;
          final bVal = b.def ?? -1;
          result = aVal.compareTo(bVal);
          break;
        default:
          result = a.name.compareTo(b.name);
      }
      return _sortAscending ? result : -result;
    });
  }

  @override
  void dispose() {
    _userSettings.removeListener(_languageListener);
    super.dispose();
  }
}