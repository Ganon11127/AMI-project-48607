import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/deck_viewmodel.dart';
import '../../viewmodel/navigation_viewmodel.dart';
import '../components/common/bottom_nav_bar.dart';
import '../components/deck/radial_menu.dart';
import '../components/deck/color_picker_dialog.dart';
import '../components/deck/edit_name_dialog.dart';
import '../components/deck/delete_confirmation_dialog.dart';
import '../components/common/settings_button.dart';
import '../../l10n/app_localizations.dart';
// Debug
import 'package:yu_gi_oh_app/debug/debug_logger.dart';

class DeckListScreen extends StatefulWidget {
  const DeckListScreen({super.key});

  @override
  State<DeckListScreen> createState() => _DeckListScreenState();
}

class _DeckListScreenState extends State<DeckListScreen> {
  OverlayEntry? _menuOverlay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final deckVM = context.watch<DeckViewModel>();
    final navVM = context.watch<NavigationViewModel>();

    final orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    final double iconSize = isLandscape ? 60.0 : 110.0;
    final double textSize = isLandscape ? 16.0 : 18.0;
    final double titlePadding = isLandscape ? 6.0 : 2.0;
    final double searchPadding = isLandscape ? 4.0 : 5.0;
    final double gridPadding = isLandscape ? 4.0 : 8.0;
    final double cardPadding = isLandscape ? 8.0 : 12.0;
    final double spacingBetweenIconAndText = isLandscape ? 4.0 : 8.0;
    final double spacingBetweenIcon = isLandscape ? 8.0 : 12.0;
    final double iconSizeSmall = isLandscape ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: titlePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.deckListTitle,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SettingsButton(
                    onTap: () {
                      DebugLogger().logTap(details: 'Settings from Deck List');
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: searchPadding),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.searchDecks,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
                onChanged: deckVM.setSearchQuery,
              ),
            ),
            Expanded(
              child: deckVM.filteredDecks.isEmpty
                  ? Center(child: Text(l10n.noDecksFound))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth < 600 ? 2 : 6;
                        return GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: gridPadding),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: deckVM.filteredDecks.length,
                          itemBuilder: (context, index) {
                            final deck = deckVM.filteredDecks[index];
                            return GestureDetector(
                              key: ValueKey(deck.id),
                              onTap: () async {
                                DebugLogger().logTap(details: 'Open Deck ${deck.id}');
                                await Navigator.pushNamed(
                                  context,
                                  '/deckProfile',
                                  arguments: deck.id,
                                );
                                if (!mounted) return;
                                deckVM.loadDecks();
                              },
                              onLongPressStart: (details) {
                                _showRadialMenu(context, deck.id, details.globalPosition);
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(cardPadding),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Transform.rotate(
                                        angle: -3.14159 / 2,
                                        child: Icon(
                                          Icons.account_balance_wallet,
                                          color: Color(
                                            int.parse(deck.colorHex.substring(1, 7), radix: 16) + 0xFF000000,
                                          ),
                                          size: iconSize,
                                        ),
                                      ),
                                      SizedBox(height: spacingBetweenIconAndText),
                                      Text(
                                        deck.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: textSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: spacingBetweenIconAndText),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if (deck.isFavourite)
                                            Icon(Icons.star, color: Colors.amber, size: iconSizeSmall),
                                          if (deck.isFavourite && deck.isWishlist)
                                            SizedBox(width: spacingBetweenIcon),
                                          if (deck.isWishlist)
                                            FaIcon(FontAwesomeIcons.solidBell, color: Colors.blue, size: iconSizeSmall),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DebugLogger().logTap(details: 'Create Deck');
          final navigator = Navigator.of(context);
          final newDeck = await deckVM.createDeck();
          if (!mounted) return;
          await navigator.pushNamed(
            '/deckProfile',
            arguments: newDeck.id,
          );
          if (!mounted) return;
          deckVM.loadDecks();
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: navVM.getIndexOfKey('bottomNavDeck'),
        onTap: (index) {
          final label = navVM.items[index].label;
          final route = NavigationViewModel.routeFromKey(label);
          if (route != ModalRoute.of(context)?.settings.name) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        items: navVM.items
            .map((item) => {'iconData': item.iconData, 'label': item.label})
            .toList(),
      ),
    );
  }

  void _showRadialMenu(BuildContext context, String deckId, Offset center) {
    final l10n = AppLocalizations.of(context)!;
    final overlay = Overlay.of(context);
    if (_menuOverlay != null) {
      _menuOverlay?.remove();
      _menuOverlay = null;
      return;
    }

    final items = [
      RadialMenuItem(
        angle: 0,
        iconWidget: Icon(Icons.star, color: Colors.amber, size:15),
        label: l10n.favouriteShort,
        onTap: () {
          DebugLogger().logTap(details: 'Favourite Deck');
          context.read<DeckViewModel>().toggleFavourite(deckId);
        },
      ),
      RadialMenuItem(
        angle: 45,
        iconWidget: FaIcon(FontAwesomeIcons.solidBell, color: Colors.blue, size:15),
        label: l10n.wishlistShort,
        onTap: () {
          DebugLogger().logTap(details: 'Wishlist Deck');
          context.read<DeckViewModel>().toggleWishlist(deckId);
        },
      ),
      RadialMenuItem(
        angle: 90,
        iconWidget: Icon(Icons.edit, color: Theme.of(context).primaryColor, size:15),
        label: l10n.rename,
        onTap: () {
          DebugLogger().logTap(details: 'Rename Deck');
          _showEditNameDialog(context, deckId);
        },
      ),
      RadialMenuItem(
        angle: -45,
        iconWidget: Icon(Icons.color_lens, color: Theme.of(context).primaryColor, size:15),
        label: l10n.color,
        onTap: () {
          DebugLogger().logTap(details: 'Color Deck');
          _showEditColorDialog(context, deckId);
        },
      ),
      RadialMenuItem(
        angle: -90,
        iconWidget: Icon(Icons.delete, color: Colors.red, size:15),
        label: l10n.delete,
        onTap: () {
          DebugLogger().logTap(details: 'Delete Deck');
          _confirmDelete(context, deckId);
        },
      ),
    ];

    _menuOverlay = OverlayEntry(
      builder: (context) => RadialMenu(
        center: center,
        items: items,
        onDismiss: () {
          _menuOverlay?.remove();
          _menuOverlay = null;
        },
        scale: 0.6,
      ),
    );

    overlay.insert(_menuOverlay!);
  }

  void _showEditNameDialog(BuildContext context, String deckId) {
    final deck = context.read<DeckViewModel>().filteredDecks.firstWhere((d) => d.id == deckId);
    showDialog(
      context: context,
      builder: (_) => EditNameDialog(
        currentName: deck.name,
        onSave: (newName) => context.read<DeckViewModel>().updateDeckName(deckId, newName),
      ),
    );
  }

  void _showEditColorDialog(BuildContext context, String deckId) {
    final deck = context.read<DeckViewModel>().filteredDecks.firstWhere((d) => d.id == deckId);
    final initialColor = Color(
      int.parse(deck.colorHex.substring(1, 7), radix: 16) + 0xFF000000,
    );
    showDialog(
      context: context,
      builder: (_) => ColorPickerDialog(
        initialColor: initialColor,
        deckId: deckId,
        onColorSelected: (newHex) => context.read<DeckViewModel>().updateDeckColor(deckId, newHex),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String deckId) {
    showDialog(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        onDelete: () => context.read<DeckViewModel>().deleteDeck(deckId),
      ),
    );
  }
}