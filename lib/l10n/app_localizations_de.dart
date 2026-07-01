// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Yu‑Gi‑Oh App';

  @override
  String get homeTitle => 'Startseite';

  @override
  String get overview => 'Übersicht der Deckpreise';

  @override
  String get favouritedDecks => 'Favorisierte Decks';

  @override
  String get bookmarkedCards => 'Lesezeichen‑Karten';

  @override
  String get wishlistedCards => 'Wunschlisten‑Karten';

  @override
  String get wishlistedDecks => 'Wunschlisten‑Decks';

  @override
  String get settingsTitle => 'Optionen';

  @override
  String get bottomNavCatalog => 'Katalog';

  @override
  String get bottomNavDeck => 'Deck';

  @override
  String get bottomNavHome => 'Startseite';

  @override
  String get bottomNavTranslation => 'Übersetzung';

  @override
  String get bottomNavBattle => 'Kampf';

  @override
  String get translationTitle => 'Übersetzen';

  @override
  String get translationHint => 'Kamera auf Text richten';

  @override
  String get findCardButton => 'Karte finden';

  @override
  String get languageOptions => 'Sprachoptionen';

  @override
  String get langEnglish => 'Englisch';

  @override
  String get langPortuguese => 'Portugiesisch';

  @override
  String get langFrench => 'Französisch';

  @override
  String get langGerman => 'Deutsch';

  @override
  String get langItalian => 'Italienisch';

  @override
  String get languagePrefix => 'Sprache: ';

  @override
  String get appLanguage => 'App‑Sprache';

  @override
  String get cardTranslation => 'Kartenübersetzung';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get marketOptions => 'Marktoptionen';

  @override
  String get markets => 'Märkte';

  @override
  String get currency => 'Währung';

  @override
  String get eur => 'Euro';

  @override
  String get usd => 'Dollar';

  @override
  String noCardFound(String text) {
    return 'Keine Karte gefunden für: $text';
  }

  @override
  String errorOccurred(String text) {
    return 'Ein Fehler ist aufgetreten: $text';
  }

  @override
  String cardArchetype(String text) {
    return 'Archetyp: $text';
  }

  @override
  String cardAttribute(String text) {
    return 'Attribut: $text';
  }

  @override
  String cardType(String text) {
    return 'Typ: $text';
  }

  @override
  String get pendulumEffectLabel => 'Penduleffekt';

  @override
  String get monsterEffectLabel => 'Monstereffekt';

  @override
  String get searching => 'Suche…';

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
  String get battlePlayer => 'Spieler';

  @override
  String get battleHelpTitle => 'Kampfsteuerung';

  @override
  String get battleHelpReset => 'LP auf 8000 zurücksetzen';

  @override
  String get battleHelpRotate => 'Bildschirm um 90° drehen';

  @override
  String get battleHelpSettings => 'Einstellungen öffnen';

  @override
  String get battleHelpToggleNav => 'Untere Navigation ein‑/ausblenden';

  @override
  String get battleHelpTranslate => 'Zur Übersetzung';

  @override
  String get battleHelpClose => 'Schließen';

  @override
  String get battleCalculatorTitle => 'Lebenspunkte festlegen';

  @override
  String get battleCalculatorHint => 'LP‑Wert eingeben';

  @override
  String get battleCalculatorSet => 'Festlegen';

  @override
  String get battleHelpSensor =>
      'Schütteln Sie das Telefon, um zu würfeln. Imitieren Sie eine Münzbewegung für den Münzwurf.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get resetConfirmTitle => 'Lebenspunkte zurücksetzen';

  @override
  String get resetConfirmContent =>
      'Möchten Sie die LP beider Spieler wirklich auf 8000 zurücksetzen?';

  @override
  String get resetConfirmReset => 'Zurücksetzen';

  @override
  String get resultTitle => 'Ergebnis';

  @override
  String get dicePrefix => 'Würfel';

  @override
  String get coinHeads => 'Kopf';

  @override
  String get coinTails => 'Zahl';

  @override
  String get deleteDeckTitle => 'Deck löschen';

  @override
  String get deleteDeckContent =>
      'Möchten Sie dieses Deck wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get delete => 'Löschen';

  @override
  String get deckListTitle => 'Decks';

  @override
  String get searchDecks => 'Decks durchsuchen…';

  @override
  String get noDecksFound => 'Keine Decks gefunden';

  @override
  String get mainDeck => 'Hauptdeck';

  @override
  String get extraDeck => 'Extra‑Deck';

  @override
  String get empty => 'Leer';

  @override
  String get unknownCard => 'Unbekannte Karte';

  @override
  String get deckProfileTitle => 'Deckprofil';

  @override
  String get deckName => 'Deckname';

  @override
  String get colorHex => 'Hex‑Farbe';

  @override
  String get mainDeckWarning =>
      'Das Hauptdeck muss mindestens 40 Karten enthalten';

  @override
  String get addToMain => 'Hauptdeck';

  @override
  String get addToExtra => 'Extra‑Deck';

  @override
  String get save => 'Speichern';

  @override
  String get editNameTitle => 'Decknamen bearbeiten';

  @override
  String get editColorTitle => 'Deckfarbe bearbeiten';

  @override
  String get enterNewName => 'Neuen Namen eingeben';

  @override
  String get enterHexHint => 'Hex eingeben (z.B. #1a73e8)';

  @override
  String get favouriteShort => 'Fav';

  @override
  String get wishlistShort => 'Wish';

  @override
  String get rename => 'Umbenennen';

  @override
  String get color => 'Farbe';

  @override
  String get searchHintCatalog => 'Suchen...';

  @override
  String get sortName => 'Name';

  @override
  String get sortLevel => 'Stufe';

  @override
  String get sortRank => 'Rang';

  @override
  String get sortLink => 'Link';

  @override
  String get sortScale => 'Skala';

  @override
  String get sortAtk => 'ATK';

  @override
  String get sortDef => 'DEF';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterMonster => 'Monster';

  @override
  String get filterSpell => 'Zauber';

  @override
  String get filterTrap => 'Falle';

  @override
  String get filterExtra => 'Extra';

  @override
  String get advancedFiltersTitle => 'Erweiterte Filter';

  @override
  String get close => 'Schließen';

  @override
  String get noCardsFound => 'Keine Karten entsprechen den Filtern';

  @override
  String get clearAll => 'Alles löschen';

  @override
  String get apply => 'Anwenden';

  @override
  String get databaseUpdate => 'Datenbank-Update';

  @override
  String get databaseVersion => 'Datenbankversion:';

  @override
  String get lastUpdate => 'letzte_Aktualisierung:';

  @override
  String get checkForUpdates => 'Auf Updates prüfen';

  @override
  String get checkingForUpdates => 'Suche nach Updates...';

  @override
  String get dbUpdated => 'Datenbank erfolgreich aktualisiert!';

  @override
  String get dbAlreadyUpToDate =>
      'Datenbank ist bereits auf dem neuesten Stand.';

  @override
  String get dbUpdateError => 'Update fehlgeschlagen:';

  @override
  String get maxCopiesReached => 'Sie haben bereits 3 Kopien dieser Karte';

  @override
  String get bookmarkShort => 'Lese';

  @override
  String get viewCard => 'Anzeigen';

  @override
  String get noItemsYet =>
      'Noch keine Elemente. Beginne mit dem Aufbau deiner Sammlung!';
}
