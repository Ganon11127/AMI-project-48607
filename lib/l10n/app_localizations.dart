import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Yu‑Gi‑Oh App'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Deck Prices Overview'**
  String get overview;

  /// No description provided for @favouritedDecks.
  ///
  /// In en, this message translates to:
  /// **'Favourited Decks'**
  String get favouritedDecks;

  /// No description provided for @bookmarkedCards.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked Cards'**
  String get bookmarkedCards;

  /// No description provided for @wishlistedCards.
  ///
  /// In en, this message translates to:
  /// **'Wishlisted Cards'**
  String get wishlistedCards;

  /// No description provided for @wishlistedDecks.
  ///
  /// In en, this message translates to:
  /// **'Wishlisted Decks'**
  String get wishlistedDecks;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get settingsTitle;

  /// No description provided for @bottomNavCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get bottomNavCatalog;

  /// No description provided for @bottomNavDeck.
  ///
  /// In en, this message translates to:
  /// **'Deck'**
  String get bottomNavDeck;

  /// No description provided for @bottomNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottomNavHome;

  /// No description provided for @bottomNavTranslation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get bottomNavTranslation;

  /// No description provided for @bottomNavBattle.
  ///
  /// In en, this message translates to:
  /// **'Battle'**
  String get bottomNavBattle;

  /// No description provided for @translationTitle.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translationTitle;

  /// No description provided for @translationHint.
  ///
  /// In en, this message translates to:
  /// **'Point camera at text'**
  String get translationHint;

  /// No description provided for @findCardButton.
  ///
  /// In en, this message translates to:
  /// **'Find Card'**
  String get findCardButton;

  /// No description provided for @languageOptions.
  ///
  /// In en, this message translates to:
  /// **'Language Options'**
  String get languageOptions;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langPortuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get langPortuguese;

  /// No description provided for @langFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get langFrench;

  /// No description provided for @langGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get langGerman;

  /// No description provided for @langItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get langItalian;

  /// No description provided for @languagePrefix.
  ///
  /// In en, this message translates to:
  /// **'Language: '**
  String get languagePrefix;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @cardTranslation.
  ///
  /// In en, this message translates to:
  /// **'Card Translation'**
  String get cardTranslation;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @marketOptions.
  ///
  /// In en, this message translates to:
  /// **'Market Options'**
  String get marketOptions;

  /// No description provided for @markets.
  ///
  /// In en, this message translates to:
  /// **'Markets'**
  String get markets;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @eur.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get eur;

  /// No description provided for @usd.
  ///
  /// In en, this message translates to:
  /// **'Dollar'**
  String get usd;

  /// No description provided for @noCardFound.
  ///
  /// In en, this message translates to:
  /// **'No card found for: {text}'**
  String noCardFound(String text);

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {text}'**
  String errorOccurred(String text);

  /// No description provided for @cardArchetype.
  ///
  /// In en, this message translates to:
  /// **'Archetype: {text}'**
  String cardArchetype(String text);

  /// No description provided for @cardAttribute.
  ///
  /// In en, this message translates to:
  /// **'Attribute: {text}'**
  String cardAttribute(String text);

  /// No description provided for @cardType.
  ///
  /// In en, this message translates to:
  /// **'Type: {text}'**
  String cardType(String text);

  /// No description provided for @pendulumEffectLabel.
  ///
  /// In en, this message translates to:
  /// **'Pendulum Effect'**
  String get pendulumEffectLabel;

  /// No description provided for @monsterEffectLabel.
  ///
  /// In en, this message translates to:
  /// **'Monster Effect'**
  String get monsterEffectLabel;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching…'**
  String get searching;

  /// No description provided for @marketCardmarket.
  ///
  /// In en, this message translates to:
  /// **'Cardmarket'**
  String get marketCardmarket;

  /// No description provided for @marketTcgplayer.
  ///
  /// In en, this message translates to:
  /// **'TCGPlayer'**
  String get marketTcgplayer;

  /// No description provided for @marketCoolstuffinc.
  ///
  /// In en, this message translates to:
  /// **'CoolStuffInc'**
  String get marketCoolstuffinc;

  /// No description provided for @marketEbay.
  ///
  /// In en, this message translates to:
  /// **'Ebay'**
  String get marketEbay;

  /// No description provided for @marketAmazon.
  ///
  /// In en, this message translates to:
  /// **'Amazon'**
  String get marketAmazon;

  /// No description provided for @battlePlayer.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get battlePlayer;

  /// No description provided for @battleHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Battle Controls'**
  String get battleHelpTitle;

  /// No description provided for @battleHelpReset.
  ///
  /// In en, this message translates to:
  /// **'Reset LP to 8000'**
  String get battleHelpReset;

  /// No description provided for @battleHelpRotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate screen 90°'**
  String get battleHelpRotate;

  /// No description provided for @battleHelpSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get battleHelpSettings;

  /// No description provided for @battleHelpToggleNav.
  ///
  /// In en, this message translates to:
  /// **'Show/hide bottom nav'**
  String get battleHelpToggleNav;

  /// No description provided for @battleHelpTranslate.
  ///
  /// In en, this message translates to:
  /// **'Go to Translation'**
  String get battleHelpTranslate;

  /// No description provided for @battleHelpClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get battleHelpClose;

  /// No description provided for @battleCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Life Points'**
  String get battleCalculatorTitle;

  /// No description provided for @battleCalculatorHint.
  ///
  /// In en, this message translates to:
  /// **'Enter LP value'**
  String get battleCalculatorHint;

  /// No description provided for @battleCalculatorSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get battleCalculatorSet;

  /// No description provided for @battleHelpSensor.
  ///
  /// In en, this message translates to:
  /// **'Shake the phone to roll dice. Mimic a coin toss motion for coin flip.'**
  String get battleHelpSensor;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @resetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Life Points'**
  String get resetConfirmTitle;

  /// No description provided for @resetConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset both player\'s LP to 8000?'**
  String get resetConfirmContent;

  /// No description provided for @resetConfirmReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetConfirmReset;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultTitle;

  /// No description provided for @dicePrefix.
  ///
  /// In en, this message translates to:
  /// **'Dice'**
  String get dicePrefix;

  /// No description provided for @coinHeads.
  ///
  /// In en, this message translates to:
  /// **'Heads'**
  String get coinHeads;

  /// No description provided for @coinTails.
  ///
  /// In en, this message translates to:
  /// **'Tails'**
  String get coinTails;

  /// No description provided for @deleteDeckTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Deck'**
  String get deleteDeckTitle;

  /// No description provided for @deleteDeckContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this deck? This action cannot be undone.'**
  String get deleteDeckContent;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deckListTitle.
  ///
  /// In en, this message translates to:
  /// **'Decks'**
  String get deckListTitle;

  /// No description provided for @searchDecks.
  ///
  /// In en, this message translates to:
  /// **'Search decks…'**
  String get searchDecks;

  /// No description provided for @noDecksFound.
  ///
  /// In en, this message translates to:
  /// **'No decks found'**
  String get noDecksFound;

  /// No description provided for @mainDeck.
  ///
  /// In en, this message translates to:
  /// **'Main Deck'**
  String get mainDeck;

  /// No description provided for @extraDeck.
  ///
  /// In en, this message translates to:
  /// **'Extra Deck'**
  String get extraDeck;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @unknownCard.
  ///
  /// In en, this message translates to:
  /// **'Unknown Card'**
  String get unknownCard;

  /// No description provided for @deckProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Deck Profile'**
  String get deckProfileTitle;

  /// No description provided for @deckName.
  ///
  /// In en, this message translates to:
  /// **'Deck Name'**
  String get deckName;

  /// No description provided for @colorHex.
  ///
  /// In en, this message translates to:
  /// **'Color Hex'**
  String get colorHex;

  /// No description provided for @mainDeckWarning.
  ///
  /// In en, this message translates to:
  /// **'Main deck must have at least 40 cards'**
  String get mainDeckWarning;

  /// No description provided for @addToMain.
  ///
  /// In en, this message translates to:
  /// **'Main Deck'**
  String get addToMain;

  /// No description provided for @addToExtra.
  ///
  /// In en, this message translates to:
  /// **'Extra Deck'**
  String get addToExtra;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @editNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Deck Name'**
  String get editNameTitle;

  /// No description provided for @editColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Deck Color'**
  String get editColorTitle;

  /// No description provided for @enterNewName.
  ///
  /// In en, this message translates to:
  /// **'Enter new name'**
  String get enterNewName;

  /// No description provided for @enterHexHint.
  ///
  /// In en, this message translates to:
  /// **'Enter hex (e.g. #1a73e8)'**
  String get enterHexHint;

  /// No description provided for @favouriteShort.
  ///
  /// In en, this message translates to:
  /// **'Fav'**
  String get favouriteShort;

  /// No description provided for @wishlistShort.
  ///
  /// In en, this message translates to:
  /// **'Wish'**
  String get wishlistShort;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @searchHintCatalog.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHintCatalog;

  /// No description provided for @sortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortName;

  /// No description provided for @sortLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get sortLevel;

  /// No description provided for @sortRank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get sortRank;

  /// No description provided for @sortLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get sortLink;

  /// No description provided for @sortScale.
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get sortScale;

  /// No description provided for @sortAtk.
  ///
  /// In en, this message translates to:
  /// **'ATK'**
  String get sortAtk;

  /// No description provided for @sortDef.
  ///
  /// In en, this message translates to:
  /// **'DEF'**
  String get sortDef;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterMonster.
  ///
  /// In en, this message translates to:
  /// **'Monster'**
  String get filterMonster;

  /// No description provided for @filterSpell.
  ///
  /// In en, this message translates to:
  /// **'Spell'**
  String get filterSpell;

  /// No description provided for @filterTrap.
  ///
  /// In en, this message translates to:
  /// **'Trap'**
  String get filterTrap;

  /// No description provided for @filterExtra.
  ///
  /// In en, this message translates to:
  /// **'Extra'**
  String get filterExtra;

  /// No description provided for @advancedFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced Filters'**
  String get advancedFiltersTitle;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @noCardsFound.
  ///
  /// In en, this message translates to:
  /// **'No cards match the filters'**
  String get noCardsFound;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @databaseUpdate.
  ///
  /// In en, this message translates to:
  /// **'Database Update'**
  String get databaseUpdate;

  /// No description provided for @databaseVersion.
  ///
  /// In en, this message translates to:
  /// **'database_version:'**
  String get databaseVersion;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'last_update:'**
  String get lastUpdate;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// No description provided for @checkingForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get checkingForUpdates;

  /// No description provided for @dbUpdated.
  ///
  /// In en, this message translates to:
  /// **'Database updated successfully!'**
  String get dbUpdated;

  /// No description provided for @dbAlreadyUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Database is already up to date.'**
  String get dbAlreadyUpToDate;

  /// No description provided for @dbUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Update failed:'**
  String get dbUpdateError;

  /// No description provided for @maxCopiesReached.
  ///
  /// In en, this message translates to:
  /// **'You already have 3 copies of this card'**
  String get maxCopiesReached;

  /// No description provided for @bookmarkShort.
  ///
  /// In en, this message translates to:
  /// **'Bkm'**
  String get bookmarkShort;

  /// No description provided for @viewCard.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewCard;

  /// No description provided for @noItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No items yet. Start building you collection!'**
  String get noItemsYet;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr', 'it', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
