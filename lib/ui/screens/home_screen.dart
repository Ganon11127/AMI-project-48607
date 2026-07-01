import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';
import '../../viewmodel/navigation_viewmodel.dart';
import '../../viewmodel/home_viewmodel.dart';
import '../components/common/bottom_nav_bar.dart';
import '../components/common/collapsible_card.dart';
import '../components/common/horizontally_scrollable_card.dart';
import '../components/common/settings_button.dart';
import '../../data/models/deck.dart';
import '../../data/models/card_model.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
// Debug
import 'package:yu_gi_oh_app/debug/debug_logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeVM = Provider.of<HomeViewModel>(context, listen: false);
      homeVM.refresh();
    });
  }

  // ----- Helper fucntions for Pendulum monsters -----
  String? _extractPendulumEffect(String? desc) {
    if (desc == null) return null;
    if (desc.contains('[ Pendulum Effect ]')) {
      final start = desc.indexOf('[ Pendulum Effect ]');
      final end = desc.indexOf('[ Monster Effect ]');
      if (end == -1) return desc.substring(start).trim();
      return desc.substring(start, end).trim();
    }
    return null;
  }

  String? _extractMonsterEffect(String? desc) {
    if (desc == null) return null;
    if (desc.contains('[ Monster Effect ]')) {
      final start = desc.indexOf('[ Monster Effect ]');
      return desc.substring(start).trim();
    }
    return desc;
  }

  // ----- Build card info like TranslationCardInfo -----
  Widget _buildCardInfo(CardModel card, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final lines = <Widget>[];

    if (card.archetype != null) {
      lines.add(Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(l10n.cardArchetype(card.archetype!),
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface)),
      ));
    }

    if (card.type.contains('Monster')) {
      if (card.attribute != null) {
        lines.add(Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(l10n.cardAttribute(card.attribute!),
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface)),
        ));
      }
      if (card.race != null) {
        lines.add(Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(l10n.cardType(card.race!),
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface)),
        ));
      }
      final pendEffect = _extractPendulumEffect(card.desc);
      if (pendEffect != null && pendEffect.isNotEmpty) {
        lines.add(Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text('${l10n.pendulumEffectLabel}\n$pendEffect',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface)),
        ));
      }
    }

    final effect = _extractMonsterEffect(card.desc);
    if (effect != null && effect.isNotEmpty) {
      lines.add(Padding(
        padding: const EdgeInsets.only(bottom: 2, top: 4),
        child: Text(effect,
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface)),
      ));
    }

    return Column(children: lines);
  }

  // ----- Card popup (magnifying glass) - exact translation screen format -----
  void _showCardPopup(BuildContext context, CardModel card) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                card.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: card.mainImageUrl,
                    width: 80,
                    height: 112,
                    memCacheWidth: 80,
                    memCacheHeight: 112,
                    placeholder: (_, _) => Container(
                      width: 80,
                      height: 112,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.type,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildCardInfo(card, ctx),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (card.atk != null || card.def != null)
                Text(
                  'ATK: ${card.atk ?? '?'} / DEF: ${card.def ?? '?'}',
                  style: const TextStyle(fontSize: 12),
                ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navVM = Provider.of<NavigationViewModel>(context);
    final homeVM = Provider.of<HomeViewModel>(context);
    final l10n = AppLocalizations.of(context)!;

    final orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    final double titlePadding = isLandscape ? 6.0 : 2.0;

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
                    l10n.homeTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 35,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SettingsButton(
                    onTap: () {
                      DebugLogger().logTap(details: 'Settings from Home');
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: homeVM.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          if (homeVM.favouriteDecks.isNotEmpty)
                            CollapsibleCard(
                              title: l10n.favouritedDecks,
                              isInitiallyExpanded: true,
                              children: [
                                HorizontallyScrollableCard<Deck>(
                                  items: homeVM.favouriteDecks,
                                  height: 120,
                                  itemBuilder: (context, deck, index) =>
                                      _buildDeckCard(deck, context),
                                  onItemTap: (deck, index) {
                                    DebugLogger().logTap(details: 'Open Deck ${deck.id}');
                                    Navigator.pushNamed(
                                      context,
                                      '/deckProfile',
                                      arguments: deck.id,
                                    );
                                  },
                                ),
                              ],
                            ),
                          if (homeVM.wishlistDecks.isNotEmpty)
                            CollapsibleCard(
                              title: l10n.wishlistedDecks,
                              isInitiallyExpanded: true,
                              children: [
                                HorizontallyScrollableCard<Deck>(
                                  items: homeVM.wishlistDecks,
                                  height: 120,
                                  itemBuilder: (context, deck, index) =>
                                      _buildDeckCard(deck, context),
                                  onItemTap: (deck, index) {
                                    DebugLogger().logTap(details: 'Open Deck ${deck.id}');
                                    Navigator.pushNamed(
                                      context,
                                      '/deckProfile',
                                      arguments: deck.id,
                                    );
                                  },
                                ),
                              ],
                            ),
                          if (homeVM.wishlistCards.isNotEmpty)
                            CollapsibleCard(
                              title: l10n.wishlistedCards,
                              isInitiallyExpanded: true,
                              children: [
                                HorizontallyScrollableCard<CardModel>(
                                  items: homeVM.wishlistCards,
                                  height: 120,
                                  itemBuilder: (context, card, index) =>
                                      _buildCardItem(card, context),
                                  onItemTap: (card, index) {
                                    DebugLogger().logTap(details: 'View Card ${card.id}');
                                    _showCardPopup(context, card);
                                  },
                                ),
                              ],
                            ),
                          if (homeVM.bookmarkedCards.isNotEmpty)
                            CollapsibleCard(
                              title: l10n.bookmarkedCards,
                              isInitiallyExpanded: true,
                              children: [
                                HorizontallyScrollableCard<CardModel>(
                                  items: homeVM.bookmarkedCards,
                                  height: 120,
                                  itemBuilder: (context, card, index) =>
                                      _buildCardItem(card, context),
                                  onItemTap: (card, index) {
                                    DebugLogger().logTap(details: 'View Card ${card.id}');
                                    _showCardPopup(context, card);
                                  },
                                ),
                              ],
                            ),
                          if (homeVM.favouriteDecks.isEmpty &&
                              homeVM.wishlistDecks.isEmpty &&
                              homeVM.wishlistCards.isEmpty &&
                              homeVM.bookmarkedCards.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(40),
                              child: Text(
                                l10n.noItemsYet,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: navVM.getIndexOfKey('bottomNavHome'),
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

  Widget _buildDeckCard(Deck deck, BuildContext context) {
    final color = Color(
      int.parse(deck.colorHex.substring(1, 7), radix: 16) + 0xFF000000,
    );
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.rotate(
            angle: -3.14159 / 2,
            child: Icon(
              Icons.account_balance_wallet,
              color: color,
              size: 60,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            deck.name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem(CardModel card, BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: card.mainImageUrl,
            height: 60,
            width: 60,
            fit: BoxFit.contain,
            placeholder: (_, _) => const SizedBox(
              height: 60,
              width: 60,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorBuilder: (_, _, _) => const Icon(Icons.broken_image, size: 40),
          ),
          const SizedBox(height: 4),
          Text(
            card.name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}