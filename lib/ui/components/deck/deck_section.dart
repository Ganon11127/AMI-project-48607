import 'package:flutter/material.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yu_gi_oh_app/data/models/card_model.dart';
import 'package:yu_gi_oh_app/viewmodel/deck_profile_viewmodel.dart';
import 'package:yu_gi_oh_app/ui/components/deck/radial_menu.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';
// Debug
import 'package:yu_gi_oh_app/debug/debug_logger.dart';

class DeckSection extends StatefulWidget {
  final String title;
  final List<int> cardIds;
  final bool isMain;
  final DeckProfileViewModel viewModel;

  const DeckSection({
    super.key,
    required this.title,
    required this.cardIds,
    required this.isMain,
    required this.viewModel,
  });

  @override
  State<DeckSection> createState() => _DeckSectionState();
}

class _DeckSectionState extends State<DeckSection> {
  bool _isExpanded = true;
  OverlayEntry? _menuOverlay;

  // ----- Helper to extract pendulum effect from description -----
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

  // ----- Card popup -----
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

  void _showRadialMenu(BuildContext context, Offset position, CardModel card, int originalIndex) {
    final viewModel = widget.viewModel;
    final l10n = AppLocalizations.of(context)!;
    final isMain = widget.isMain;

    final deckIds = isMain ? viewModel.mainDeckCardIds : viewModel.extraDeckCardIds;
    final currentCount = deckIds.where((id) => id == card.id).length;

    final items = <RadialMenuItem>[];

    if (currentCount < 3) {
      final maxAdd = 3 - currentCount;
      if (maxAdd >= 2) {
        items.add(RadialMenuItem(
          angle: -90,
          iconWidget: Icon( Icons.add_circle, color: Theme.of(context).primaryColor, size:15 ),
          label: '+2',
          onTap: () {
            DebugLogger().logTap(details: 'Deck Add +2 ${card.id}');
            for (int i = 0; i < 2; i++) {
              if (isMain) {
                viewModel.addCardToMain(card);
              } else {
                viewModel.addCardToExtra(card);
              }
            }
          },
        ));
      }
      if (maxAdd >= 3) {
        items.add(RadialMenuItem(
          angle: -45,
          iconWidget: Icon( Icons.add_circle_outline ),
          label: '+3',
          onTap: () {
            DebugLogger().logTap(details: 'Deck Add +3 ${card.id}');
            for (int i = 0; i < 3; i++) {
              if (isMain) {
                viewModel.addCardToMain(card);
              } else {
                viewModel.addCardToExtra(card);
              }
            }
          },
        ));
      }
    }

    if (currentCount >= 2) {
      items.add(RadialMenuItem(
        angle: 45,
        iconWidget: Icon( Icons.remove_circle, color: Theme.of(context).primaryColor, size:15 ),
        label: '-2',
        onTap: () {
          DebugLogger().logTap(details: 'Deck Remove -2 ${card.id}');
          int removed = 0;
          while (removed < 2 && deckIds.contains(card.id)) {
            final index = deckIds.indexOf(card.id);
            if (index != -1) {
              if (isMain) {
                viewModel.removeCardFromMain(index);
              } else {
                viewModel.removeCardFromExtra(index);
              }
              removed++;
            } else {
              break;
            }
          }
        },
      ));
    }
    if (currentCount >= 3) {
      items.add(RadialMenuItem(
        angle: 90,
        iconWidget: Icon( Icons.remove_circle_outline, color: Theme.of(context).primaryColor, size:15 ),
        label: '-3',
        onTap: () {
          DebugLogger().logTap(details: 'Deck Remove -3 ${card.id}');
          int removed = 0;
          while (removed < 3 && deckIds.contains(card.id)) {
            final index = deckIds.indexOf(card.id);
            if (index != -1) {
              if (isMain) {
                viewModel.removeCardFromMain(index);
              } else {
                viewModel.removeCardFromExtra(index);
              }
              removed++;
            } else {
              break;
            }
          }
        },
      ));
    }

    // Magnifying glass
    items.add(RadialMenuItem(
      angle: 180,
      iconWidget: Icon( Icons.search, color: Theme.of(context).primaryColor, size:15 ),
      label: l10n.viewCard,
      onTap: () {
        DebugLogger().logTap(details: 'Deck View Card ${card.id}');
        _showCardPopup(context, card);
      },
    ));

    // Wishlist
    final isWishlisted = viewModel.isCardWishlisted(card.id);
    items.add(RadialMenuItem(
      angle: -135,
      iconWidget: isWishlisted ? FaIcon( FontAwesomeIcons.solidBell, color: Colors.blue, size:15 ) : FaIcon( FontAwesomeIcons.bell, color: Colors.blue, size:15 ),
      label: l10n.wishlistShort,
      onTap: () {
        DebugLogger().logTap(details: 'Deck Toggle Wishlist ${card.id}');
        viewModel.toggleCardWishlist(card.id);
      },
    ));

    // Bookmark
    final isBookmarked = viewModel.isBookmarked(card.id);
    items.add(RadialMenuItem(
      angle: 135,
      iconWidget: isBookmarked ? Icon( Icons.bookmark, color: Colors.green, size:15 ) : Icon( Icons.bookmark_border, color: Colors.green, size:15 ),
      label: l10n.bookmarkShort,
      onTap: () {
        DebugLogger().logTap(details: 'Deck Toggle Bookmark ${card.id}');
        viewModel.toggleBookmark(card.id);
      },
    ));

    if (items.isEmpty) {
      items.add(RadialMenuItem(
        angle: 0,
        iconWidget: Icon( Icons.search, color: Theme.of(context).primaryColor, size:15 ),
        label: l10n.viewCard,
        onTap: () {
          DebugLogger().logTap(details: 'Deck View Card ${card.id}');
          _showCardPopup(context, card);
        },
      ));
    }

    _menuOverlay?.remove();
    _menuOverlay = null;

    final overlay = Overlay.of(context);
    _menuOverlay = OverlayEntry(
      builder: (context) => RadialMenu(
        center: position,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardIds = widget.cardIds;

    final List<(CardModel, int)> entries = [];
    for (int i = 0; i < cardIds.length; i++) {
      final card = widget.viewModel.getCardById(cardIds[i]);
      if (card != null) {
        entries.add((card, i));
      }
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heade, tap to expand/collapse
          InkWell(
            onTap: () {
              DebugLogger().logTap(details: 'Deck Section Toggle Expand');
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.iconTheme.color,
                  ),
                ],
              ),
            ),
          ),
          // Grid when expanded
          if (_isExpanded) ...[
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No cards added',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final (card, originalIndex) = entries[index];
                  return GestureDetector(
                    onLongPressStart: (details) {
                      _showRadialMenu(context, details.globalPosition, card, originalIndex);
                    },
                    onTap: () {
                      DebugLogger().logTap(details: 'Remove Card ${card.id}');
                      if (widget.isMain) {
                        widget.viewModel.removeCardFromMain(originalIndex);
                      } else {
                        widget.viewModel.removeCardFromExtra(originalIndex);
                      }
                    },
                    child: Card(
                      elevation: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: card.mainImageUrl,
                              fit: BoxFit.contain,
                              placeholder: (_, _) => const Center(child: CircularProgressIndicator()),
                              errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
                            ),
                          ),
                          Text(
                            card.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}