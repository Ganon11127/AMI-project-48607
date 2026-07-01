// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'App Yu‑Gi‑Oh';

  @override
  String get homeTitle => 'Home';

  @override
  String get overview => 'Panoramica Prezzi Deck';

  @override
  String get favouritedDecks => 'Deck Preferiti';

  @override
  String get bookmarkedCards => 'Carte Preferite';

  @override
  String get wishlistedCards => 'Carte Desiderate';

  @override
  String get wishlistedDecks => 'Deck Desiderati';

  @override
  String get settingsTitle => 'Opzioni';

  @override
  String get bottomNavCatalog => 'Catalogo';

  @override
  String get bottomNavDeck => 'Deck';

  @override
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavTranslation => 'Traduzione';

  @override
  String get bottomNavBattle => 'Battaglia';

  @override
  String get translationTitle => 'Traduci';

  @override
  String get translationHint => 'Inquadra il testo con la fotocamera';

  @override
  String get findCardButton => 'Trova Carta';

  @override
  String get languageOptions => 'Opzioni Lingua';

  @override
  String get langEnglish => 'Inglese';

  @override
  String get langPortuguese => 'Portoghese';

  @override
  String get langFrench => 'Francese';

  @override
  String get langGerman => 'Tedesco';

  @override
  String get langItalian => 'Italiano';

  @override
  String get languagePrefix => 'Lingua: ';

  @override
  String get appLanguage => 'Lingua dell\'App';

  @override
  String get cardTranslation => 'Traduzione Carte';

  @override
  String get darkMode => 'Modalità Scura';

  @override
  String get marketOptions => 'Opzioni Mercato';

  @override
  String get markets => 'Mercati';

  @override
  String get currency => 'Valuta';

  @override
  String get eur => 'Euro';

  @override
  String get usd => 'Dollaro';

  @override
  String noCardFound(String text) {
    return 'Nessuna carta trovata per: $text';
  }

  @override
  String errorOccurred(String text) {
    return 'Si è verificato un errore: $text';
  }

  @override
  String cardArchetype(String text) {
    return 'Archetipo: $text';
  }

  @override
  String cardAttribute(String text) {
    return 'Attributo: $text';
  }

  @override
  String cardType(String text) {
    return 'Tipo: $text';
  }

  @override
  String get pendulumEffectLabel => 'Effetto Pendulum';

  @override
  String get monsterEffectLabel => 'Effetto Mostro';

  @override
  String get searching => 'Ricerca…';

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
  String get battlePlayer => 'Giocatore';

  @override
  String get battleHelpTitle => 'Controlli Battaglia';

  @override
  String get battleHelpReset => 'Ripristina LP a 8000';

  @override
  String get battleHelpRotate => 'Ruota schermo di 90°';

  @override
  String get battleHelpSettings => 'Apri Impostazioni';

  @override
  String get battleHelpToggleNav => 'Mostra/nascondi navigazione inferiore';

  @override
  String get battleHelpTranslate => 'Vai a Traduzione';

  @override
  String get battleHelpClose => 'Chiudi';

  @override
  String get battleCalculatorTitle => 'Imposta Punti Vita';

  @override
  String get battleCalculatorHint => 'Inserisci valore LP';

  @override
  String get battleCalculatorSet => 'Imposta';

  @override
  String get battleHelpSensor =>
      'Agita il telefono per lanciare i dadi. Imita un movimento di moneta per il lancio della moneta.';

  @override
  String get cancel => 'Annulla';

  @override
  String get resetConfirmTitle => 'Ripristina Punti Vita';

  @override
  String get resetConfirmContent =>
      'Sei sicuro di voler ripristinare gli LP di entrambi i giocatori a 8000?';

  @override
  String get resetConfirmReset => 'Ripristina';

  @override
  String get resultTitle => 'Risultato';

  @override
  String get dicePrefix => 'Dado';

  @override
  String get coinHeads => 'Testa';

  @override
  String get coinTails => 'Croce';

  @override
  String get deleteDeckTitle => 'Elimina Deck';

  @override
  String get deleteDeckContent =>
      'Sei sicuro di voler eliminare questo deck? Questa azione non può essere annullata.';

  @override
  String get delete => 'Elimina';

  @override
  String get deckListTitle => 'Deck';

  @override
  String get searchDecks => 'Cerca deck…';

  @override
  String get noDecksFound => 'Nessun deck trovato';

  @override
  String get mainDeck => 'Deck Principale';

  @override
  String get extraDeck => 'Deck Extra';

  @override
  String get empty => 'Vuoto';

  @override
  String get unknownCard => 'Carta Sconosciuta';

  @override
  String get deckProfileTitle => 'Profilo Deck';

  @override
  String get deckName => 'Nome Deck';

  @override
  String get colorHex => 'Colore Hex';

  @override
  String get mainDeckWarning => 'Il deck principale deve avere almeno 40 carte';

  @override
  String get addToMain => 'Deck Principale';

  @override
  String get addToExtra => 'Deck Extra';

  @override
  String get save => 'Salva';

  @override
  String get editNameTitle => 'Modifica Nome Deck';

  @override
  String get editColorTitle => 'Modifica Colore Deck';

  @override
  String get enterNewName => 'Inserisci nuovo nome';

  @override
  String get enterHexHint => 'Inserisci hex (es. #1a73e8)';

  @override
  String get favouriteShort => 'Fav';

  @override
  String get wishlistShort => 'Wish';

  @override
  String get rename => 'Rinomina';

  @override
  String get color => 'Colore';

  @override
  String get searchHintCatalog => 'Cerca...';

  @override
  String get sortName => 'Nome';

  @override
  String get sortLevel => 'Livello';

  @override
  String get sortRank => 'Grado';

  @override
  String get sortLink => 'Link';

  @override
  String get sortScale => 'Scala';

  @override
  String get sortAtk => 'ATK';

  @override
  String get sortDef => 'DEF';

  @override
  String get filterAll => 'Tutti';

  @override
  String get filterMonster => 'Mostro';

  @override
  String get filterSpell => 'Magia';

  @override
  String get filterTrap => 'Trappola';

  @override
  String get filterExtra => 'Extra';

  @override
  String get advancedFiltersTitle => 'Filtri Avanzati';

  @override
  String get close => 'Chiudi';

  @override
  String get noCardsFound => 'Nessuna carta corrisponde ai filtri';

  @override
  String get clearAll => 'Cancella tutto';

  @override
  String get apply => 'Applica';

  @override
  String get databaseUpdate => 'Aggiornamento del database';

  @override
  String get databaseVersion => 'versione_database:';

  @override
  String get lastUpdate => 'ultimo_aggiornamento:';

  @override
  String get checkForUpdates => 'Verifica aggiornamenti';

  @override
  String get checkingForUpdates => 'Ricerca aggiornamenti...';

  @override
  String get dbUpdated => 'Database aggiornato con successo!';

  @override
  String get dbAlreadyUpToDate => 'Il database è già aggiornato.';

  @override
  String get dbUpdateError => 'Aggiornamento fallito:';

  @override
  String get maxCopiesReached => 'Hai già 3 copie di questa carta';

  @override
  String get bookmarkShort => 'Seg';

  @override
  String get viewCard => 'Vedi';

  @override
  String get noItemsYet =>
      'Nessun elemento ancora. Inizia a costruire la tua collezione!';
}
