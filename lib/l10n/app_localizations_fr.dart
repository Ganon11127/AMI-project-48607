// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Appli Yu‑Gi‑Oh';

  @override
  String get homeTitle => 'Accueil';

  @override
  String get overview => 'Aperçu des Prix des Decks';

  @override
  String get favouritedDecks => 'Decks Favoris';

  @override
  String get bookmarkedCards => 'Cartes Favorites';

  @override
  String get wishlistedCards => 'Cartes Souhaitées';

  @override
  String get wishlistedDecks => 'Decks Souhaités';

  @override
  String get settingsTitle => 'Options';

  @override
  String get bottomNavCatalog => 'Catalogue';

  @override
  String get bottomNavDeck => 'Deck';

  @override
  String get bottomNavHome => 'Accueil';

  @override
  String get bottomNavTranslation => 'Traduction';

  @override
  String get bottomNavBattle => 'Bataille';

  @override
  String get translationTitle => 'Traduire';

  @override
  String get translationHint => 'Pointer la caméra vers le texte';

  @override
  String get findCardButton => 'Trouver la Carte';

  @override
  String get languageOptions => 'Options de Langue';

  @override
  String get langEnglish => 'Anglais';

  @override
  String get langPortuguese => 'Portugais';

  @override
  String get langFrench => 'Français';

  @override
  String get langGerman => 'Allemand';

  @override
  String get langItalian => 'Italien';

  @override
  String get languagePrefix => 'Langue : ';

  @override
  String get appLanguage => 'Langue de l\'Appli';

  @override
  String get cardTranslation => 'Traduction des Cartes';

  @override
  String get darkMode => 'Mode Sombre';

  @override
  String get marketOptions => 'Options de Marché';

  @override
  String get markets => 'Marchés';

  @override
  String get currency => 'Devise';

  @override
  String get eur => 'Euro';

  @override
  String get usd => 'Dollar';

  @override
  String noCardFound(String text) {
    return 'Aucune carte trouvée pour : $text';
  }

  @override
  String errorOccurred(String text) {
    return 'Une erreur est survenue : $text';
  }

  @override
  String cardArchetype(String text) {
    return 'Archétype : $text';
  }

  @override
  String cardAttribute(String text) {
    return 'Attribut : $text';
  }

  @override
  String cardType(String text) {
    return 'Type : $text';
  }

  @override
  String get pendulumEffectLabel => 'Effet Pendule';

  @override
  String get monsterEffectLabel => 'Effet Monstre';

  @override
  String get searching => 'Recherche…';

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
  String get battlePlayer => 'Joueur';

  @override
  String get battleHelpTitle => 'Commandes de Bataille';

  @override
  String get battleHelpReset => 'Réinitialiser les PV à 8000';

  @override
  String get battleHelpRotate => 'Faire pivoter l\'écran de 90°';

  @override
  String get battleHelpSettings => 'Ouvrir les Paramètres';

  @override
  String get battleHelpToggleNav => 'Afficher/masquer la barre de navigation';

  @override
  String get battleHelpTranslate => 'Aller à la Traduction';

  @override
  String get battleHelpClose => 'Fermer';

  @override
  String get battleCalculatorTitle => 'Définir les Points de Vie';

  @override
  String get battleCalculatorHint => 'Entrez la valeur des PV';

  @override
  String get battleCalculatorSet => 'Définir';

  @override
  String get battleHelpSensor =>
      'Secouez le téléphone pour lancer les dés. Imitez un mouvement de pièce pour le pile ou face.';

  @override
  String get cancel => 'Annuler';

  @override
  String get resetConfirmTitle => 'Réinitialiser les Points de Vie';

  @override
  String get resetConfirmContent =>
      'Voulez‑vous vraiment réinitialiser les PV des deux joueurs à 8000 ?';

  @override
  String get resetConfirmReset => 'Réinitialiser';

  @override
  String get resultTitle => 'Résultat';

  @override
  String get dicePrefix => 'Dé';

  @override
  String get coinHeads => 'Pile';

  @override
  String get coinTails => 'Face';

  @override
  String get deleteDeckTitle => 'Supprimer le Deck';

  @override
  String get deleteDeckContent =>
      'Voulez‑vous vraiment supprimer ce deck ? Cette action est irréversible.';

  @override
  String get delete => 'Supprimer';

  @override
  String get deckListTitle => 'Decks';

  @override
  String get searchDecks => 'Rechercher des decks…';

  @override
  String get noDecksFound => 'Aucun deck trouvé';

  @override
  String get mainDeck => 'Deck Principal';

  @override
  String get extraDeck => 'Deck Extra';

  @override
  String get empty => 'Vide';

  @override
  String get unknownCard => 'Carte Inconnue';

  @override
  String get deckProfileTitle => 'Profil du Deck';

  @override
  String get deckName => 'Nom du Deck';

  @override
  String get colorHex => 'Couleur Hex';

  @override
  String get mainDeckWarning =>
      'Le deck principal doit contenir au moins 40 cartes';

  @override
  String get addToMain => 'Deck Principal';

  @override
  String get addToExtra => 'Deck Extra';

  @override
  String get save => 'Enregistrer';

  @override
  String get editNameTitle => 'Modifier le nom du Deck';

  @override
  String get editColorTitle => 'Modifier la couleur du Deck';

  @override
  String get enterNewName => 'Entrez un nouveau nom';

  @override
  String get enterHexHint => 'Entrez hex (ex: #1a73e8)';

  @override
  String get favouriteShort => 'Fav';

  @override
  String get wishlistShort => 'Wish';

  @override
  String get rename => 'Renommer';

  @override
  String get color => 'Couleur';

  @override
  String get searchHintCatalog => 'Rechercher...';

  @override
  String get sortName => 'Nom';

  @override
  String get sortLevel => 'Niveau';

  @override
  String get sortRank => 'Rang';

  @override
  String get sortLink => 'Lien';

  @override
  String get sortScale => 'Échelle';

  @override
  String get sortAtk => 'ATK';

  @override
  String get sortDef => 'DEF';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterMonster => 'Monstre';

  @override
  String get filterSpell => 'Magie';

  @override
  String get filterTrap => 'Piège';

  @override
  String get filterExtra => 'Extra';

  @override
  String get advancedFiltersTitle => 'Filtres Avancés';

  @override
  String get close => 'Fermer';

  @override
  String get noCardsFound => 'Aucune carte ne correspond aux filtres';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get apply => 'Appliquer';

  @override
  String get databaseUpdate => 'Mise à jour de la base de données';

  @override
  String get databaseVersion => 'version_base_données:';

  @override
  String get lastUpdate => 'dernière_mise_à_jour:';

  @override
  String get checkForUpdates => 'Vérifier les mises à jour';

  @override
  String get checkingForUpdates => 'Vérification des mises à jour...';

  @override
  String get dbUpdated => 'Base de données mise à jour avec succès !';

  @override
  String get dbAlreadyUpToDate => 'La base de données est déjà à jour.';

  @override
  String get dbUpdateError => 'Échec de la mise à jour:';

  @override
  String get maxCopiesReached => 'Vous avez déjà 3 exemplaires de cette carte';

  @override
  String get bookmarkShort => 'Marq';

  @override
  String get viewCard => 'Voir';

  @override
  String get noItemsYet =>
      'Pas encore d\'éléments. Commencez à construire votre collection!';
}
