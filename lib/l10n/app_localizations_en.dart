// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Yu‑Gi‑Oh App';

  @override
  String get homeTitle => 'Home';

  @override
  String get overview => 'Deck Prices Overview';

  @override
  String get favouritedDecks => 'Favourited Decks';

  @override
  String get bookmarkedCards => 'Bookmarked Cards';

  @override
  String get wishlistedCards => 'Wishlisted Cards';

  @override
  String get wishlistedDecks => 'Wishlisted Decks';

  @override
  String get settingsTitle => 'Options';

  @override
  String get bottomNavCatalog => 'Catalog';

  @override
  String get bottomNavDeck => 'Deck';

  @override
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavTranslation => 'Translation';

  @override
  String get bottomNavBattle => 'Battle';

  @override
  String get translationTitle => 'Translate';

  @override
  String get translationHint => 'Point camera at text';

  @override
  String get findCardButton => 'Find Card';

  @override
  String get languageOptions => 'Language Options';

  @override
  String get langEnglish => 'English';

  @override
  String get langPortuguese => 'Portuguese';

  @override
  String get langFrench => 'French';

  @override
  String get langGerman => 'German';

  @override
  String get langItalian => 'Italian';

  @override
  String get languagePrefix => 'Language: ';

  @override
  String get appLanguage => 'App Language';

  @override
  String get cardTranslation => 'Card Translation';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get marketOptions => 'Market Options';

  @override
  String get markets => 'Markets';

  @override
  String get currency => 'Currency';

  @override
  String get eur => 'Euro';

  @override
  String get usd => 'Dollar';

  @override
  String noCardFound(String text) {
    return 'No card found for: $text';
  }

  @override
  String errorOccurred(String text) {
    return 'An error occurred: $text';
  }

  @override
  String cardArchetype(String text) {
    return 'Archetype: $text';
  }

  @override
  String cardAttribute(String text) {
    return 'Attribute: $text';
  }

  @override
  String cardType(String text) {
    return 'Type: $text';
  }

  @override
  String get pendulumEffectLabel => 'Pendulum Effect';

  @override
  String get monsterEffectLabel => 'Monster Effect';

  @override
  String get searching => 'Searching…';

  @override
  String get marketCardmarket => 'Cardmarket';

  @override
  String get marketTcgplayer => 'TCGPlayer';

  @override
  String get marketCoolstuffinc => 'CoolStuffInc';

  @override
  String get marketEbay => 'Ebay';

  @override
  String get marketAmazon => 'Amazon';

  @override
  String get battlePlayer => 'Player';

  @override
  String get battleHelpTitle => 'Battle Controls';

  @override
  String get battleHelpReset => 'Reset LP to 8000';

  @override
  String get battleHelpRotate => 'Rotate screen 90°';

  @override
  String get battleHelpSettings => 'Open Settings';

  @override
  String get battleHelpToggleNav => 'Show/hide bottom nav';

  @override
  String get battleHelpTranslate => 'Go to Translation';

  @override
  String get battleHelpClose => 'Close';

  @override
  String get battleCalculatorTitle => 'Set Life Points';

  @override
  String get battleCalculatorHint => 'Enter LP value';

  @override
  String get battleCalculatorSet => 'Set';

  @override
  String get battleHelpSensor =>
      'Shake the phone to roll dice. Mimic a coin toss motion for coin flip.';

  @override
  String get cancel => 'Cancel';

  @override
  String get resetConfirmTitle => 'Reset Life Points';

  @override
  String get resetConfirmContent =>
      'Are you sure you want to reset both player\'s LP to 8000?';

  @override
  String get resetConfirmReset => 'Reset';

  @override
  String get resultTitle => 'Result';

  @override
  String get dicePrefix => 'Dice';

  @override
  String get coinHeads => 'Heads';

  @override
  String get coinTails => 'Tails';

  @override
  String get deleteDeckTitle => 'Delete Deck';

  @override
  String get deleteDeckContent =>
      'Are you sure you want to delete this deck? This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get deckListTitle => 'Decks';

  @override
  String get searchDecks => 'Search decks…';

  @override
  String get noDecksFound => 'No decks found';

  @override
  String get mainDeck => 'Main Deck';

  @override
  String get extraDeck => 'Extra Deck';

  @override
  String get empty => 'Empty';

  @override
  String get unknownCard => 'Unknown Card';

  @override
  String get deckProfileTitle => 'Deck Profile';

  @override
  String get deckName => 'Deck Name';

  @override
  String get colorHex => 'Color Hex';

  @override
  String get mainDeckWarning => 'Main deck must have at least 40 cards';

  @override
  String get addToMain => 'Main Deck';

  @override
  String get addToExtra => 'Extra Deck';

  @override
  String get save => 'Save';

  @override
  String get editNameTitle => 'Edit Deck Name';

  @override
  String get editColorTitle => 'Edit Deck Color';

  @override
  String get enterNewName => 'Enter new name';

  @override
  String get enterHexHint => 'Enter hex (e.g. #1a73e8)';

  @override
  String get favouriteShort => 'Fav';

  @override
  String get wishlistShort => 'Wish';

  @override
  String get rename => 'Rename';

  @override
  String get color => 'Color';

  @override
  String get searchHintCatalog => 'Search...';

  @override
  String get sortName => 'Name';

  @override
  String get sortLevel => 'Level';

  @override
  String get sortRank => 'Rank';

  @override
  String get sortLink => 'Link';

  @override
  String get sortScale => 'Scale';

  @override
  String get sortAtk => 'ATK';

  @override
  String get sortDef => 'DEF';

  @override
  String get filterAll => 'All';

  @override
  String get filterMonster => 'Monster';

  @override
  String get filterSpell => 'Spell';

  @override
  String get filterTrap => 'Trap';

  @override
  String get filterExtra => 'Extra';

  @override
  String get advancedFiltersTitle => 'Advanced Filters';

  @override
  String get close => 'Close';

  @override
  String get noCardsFound => 'No cards match the filters';

  @override
  String get clearAll => 'Clear All';

  @override
  String get apply => 'Apply';

  @override
  String get databaseUpdate => 'Database Update';

  @override
  String get databaseVersion => 'database_version:';

  @override
  String get lastUpdate => 'last_update:';

  @override
  String get checkForUpdates => 'Check for Updates';

  @override
  String get checkingForUpdates => 'Checking for updates...';

  @override
  String get dbUpdated => 'Database updated successfully!';

  @override
  String get dbAlreadyUpToDate => 'Database is already up to date.';

  @override
  String get dbUpdateError => 'Update failed:';

  @override
  String get maxCopiesReached => 'You already have 3 copies of this card';

  @override
  String get bookmarkShort => 'Bkm';

  @override
  String get viewCard => 'View';

  @override
  String get noItemsYet => 'No items yet. Start building you collection!';
}
