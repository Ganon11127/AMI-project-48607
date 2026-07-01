import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<Map<String, String>> items;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  Widget _getIcon(String iconName) {
    switch (iconName) {
      case 'test':
        return const FaIcon(FontAwesomeIcons.tableCells);
      case 'decks':
        return Transform.rotate(
          angle: -3.14159 / 2,
          child: const Icon(Icons.account_balance_wallet),
        );
      case 'home':
        return const FaIcon(FontAwesomeIcons.solidHouse);
      case 'translate':
        return const FaIcon(FontAwesomeIcons.language);
      case 'battle':
        return const FaIcon(FontAwesomeIcons.shieldHalved);
      default:
        return const Icon(Icons.help);
    }
  }

  String _localizeLabel( BuildContext context, String key ) {
    final l10n = AppLocalizations.of( context )!;
    
    switch ( key ) {
      case 'bottomNavCatalog': return l10n.bottomNavCatalog;
      case 'bottomNavDeck': return l10n.bottomNavDeck;
      case 'bottomNavHome': return l10n.bottomNavHome;
      case 'bottomNavTranslation': return l10n.bottomNavTranslation;
      case 'bottomNavBattle': return l10n.bottomNavBattle;
      default: return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items.map((item) {
        return BottomNavigationBarItem(
          icon: _getIcon(item['iconData']!),
          label: _localizeLabel(context, item['label']!)
        );
      }).toList(),
      currentIndex: currentIndex,
      elevation: 8,
      iconSize: 24,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      onTap: onTap,
    );
  }
}