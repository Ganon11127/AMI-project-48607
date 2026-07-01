import 'package:flutter/material.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yu_gi_oh_app/data/models/card_model.dart';
import 'package:yu_gi_oh_app/viewmodel/deck_profile_viewmodel.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';
import 'package:yu_gi_oh_app/ui/components/deck/advanced_filter_sheet.dart';
import 'package:yu_gi_oh_app/ui/components/deck/radial_menu.dart';
// Debug
import 'package:yu_gi_oh_app/debug/debug_logger.dart';

class CatalogSheet extends StatefulWidget {
  final DeckProfileViewModel viewModel;
  final DraggableScrollableController controller;

  const CatalogSheet({
    super.key,
    required this.viewModel,
    required this.controller,
  });

  @override
  State<CatalogSheet> createState() => _CatalogSheetState();
}

class _CatalogSheetState extends State<CatalogSheet> {
  double _dragStartY = 0.0;
  double _dragStartFraction = 0.0;
  OverlayEntry? _menuOverlay;

  bool _isExtraDeckCard(CardModel card) {
    if (!card.type.contains('Monster')) return false;
    const extraTypes = ['Fusion', 'Synchro', 'Xyz', 'Link'];
    return extraTypes.any((t) => card.humanReadableType?.contains(t) ?? false);
  }

  void _toggleCollapse() {
    DebugLogger().logTap(details: 'Toggle Catalog Collapse');
    final bool willBeCollapsed = !widget.viewModel.catalogCollapsed;
    widget.viewModel.toggleCatalogCollapsed();
    final double targetFraction = willBeCollapsed ? 0.10 : 0.35;
    widget.controller.animateTo(
      targetFraction,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _toggleCardTypeFilter(String type) {
    DebugLogger().logTap(details: 'Filter Chip $type');
    final current = widget.viewModel.cardTypeFilter;
    if (current == type) {
      widget.viewModel.setCardTypeFilter('All');
    } else {
      widget.viewModel.setCardTypeFilter(type);
    }
  }

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

  void _showRadialMenu(BuildContext context, Offset position, CardModel card) {
    final viewModel = widget.viewModel;
    final l10n = AppLocalizations.of(context)!;
    final isExtra = _isExtraDeckCard(card);

    final deckIds = isExtra ? viewModel.extraDeckCardIds : viewModel.mainDeckCardIds;
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
            DebugLogger().logTap(details: 'Add +2 ${card.id}');
            for (int i = 0; i < 2; i++) {
              if (isExtra) {
                viewModel.addCardToExtra(card);
              } else {
                viewModel.addCardToMain(card);
              }
            }
          },
        ));
      }
      if (maxAdd >= 3) {
        items.add(RadialMenuItem(
          angle: -45,
          iconWidget: Icon( Icons.add_circle_outline, color: Theme.of(context).primaryColor, size:15 ),
          label: '+3',
          onTap: () {
            DebugLogger().logTap(details: 'Add +3 ${card.id}');
            for (int i = 0; i < 3; i++) {
              if (isExtra) {
                viewModel.addCardToExtra(card);
              } else {
                viewModel.addCardToMain(card);
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
          DebugLogger().logTap(details: 'Remove -2 ${card.id}');
          int removed = 0;
          while (removed < 2 && deckIds.contains(card.id)) {
            final index = deckIds.indexOf(card.id);
            if (index != -1) {
              if (isExtra) {
                viewModel.removeCardFromExtra(index);
              } else {
                viewModel.removeCardFromMain(index);
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
          DebugLogger().logTap(details: 'Remove -3 ${card.id}');
          int removed = 0;
          while (removed < 3 && deckIds.contains(card.id)) {
            final index = deckIds.indexOf(card.id);
            if (index != -1) {
              if (isExtra) {
                viewModel.removeCardFromExtra(index);
              } else {
                viewModel.removeCardFromMain(index);
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
        DebugLogger().logTap(details: 'View Card ${card.id}');
        _showCardPopup(context, card);
      },
    ));

    // Wishlist
    final isWishlisted = viewModel.isCardWishlisted(card.id);
    items.add(RadialMenuItem(
      angle: -135,
      iconWidget: isWishlisted ? FaIcon( FontAwesomeIcons.solidBell, color: Colors.blue, size:15 ): FaIcon( FontAwesomeIcons.bell, color: Colors.blue, size:15 ),
      label: l10n.wishlistShort,
      onTap: () {
        DebugLogger().logTap(details: 'Toggle Wishlist ${card.id}');
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
        DebugLogger().logTap(details: 'Toggle Bookmark ${card.id}');
        viewModel.toggleBookmark(card.id);
      },
    ));

    if (items.isEmpty) {
      items.add(RadialMenuItem(
        angle: 0,
        iconWidget: Icon( Icons.search, color: Theme.of(context).primaryColor, size:15 ),
        label: l10n.viewCard,
        onTap: () {
          DebugLogger().logTap(details: 'View Card ${card.id}');
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
    final l10n = AppLocalizations.of(context)!;
    final viewModel = widget.viewModel;
    final theme = Theme.of(context);

    const double minFraction = 0.10;
    const double maxFraction = 0.60;
    final screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return DraggableScrollableSheet(
      controller: widget.controller,
      expand: true,
      initialChildSize: 0.35,
      minChildSize: minFraction,
      maxChildSize: maxFraction,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Column(
            children: [
              // ----- DRAG HANDLE -----
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragStart: (details) {
                  _dragStartY = details.globalPosition.dy;
                  _dragStartFraction = widget.controller.pixels / screenHeight;
                },
                onVerticalDragUpdate: (details) {
                  final delta = details.globalPosition.dy - _dragStartY;
                  final deltaFraction = delta / screenHeight;
                  double newFraction = _dragStartFraction - deltaFraction;
                  newFraction = newFraction.clamp(minFraction, maxFraction);
                  widget.controller.jumpTo(newFraction);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.dividerColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // ----- TOOLBARS -----
              if (viewModel.catalogCollapsed)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.expand_more),
                        onPressed: _toggleCollapse,
                      ),
                      const SizedBox(width: 2),
                      SizedBox(
                        width: 120,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: l10n.searchHintCatalog,
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: viewModel.setSearchText,
                        ),
                      ),
                      const SizedBox(width: 4),
                      DropdownButton<String>(
                        value: viewModel.sortType,
                        items: const [
                          DropdownMenuItem(value: 'Name', child: Text('Name')),
                          DropdownMenuItem(value: 'Level', child: Text('Level')),
                          DropdownMenuItem(value: 'Rank', child: Text('Rank')),
                          DropdownMenuItem(value: 'LinkRating', child: Text('Link Rating')),
                          DropdownMenuItem(value: 'PendulumScale', child: Text('Pendulum Scale')),
                          DropdownMenuItem(value: 'Atk', child: Text('ATK')),
                          DropdownMenuItem(value: 'Def', child: Text('DEF')),
                        ],
                        onChanged: (val) => viewModel.setSortType(val!),
                      ),
                      IconButton(
                        icon: Icon(viewModel.sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
                        onPressed: viewModel.toggleSortOrder,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_sweep),
                        onPressed: () {
                          DebugLogger().logTap(details: 'Clear Filters');
                          viewModel.clearAdvancedFilters();
                        },
                      ),
                    ],
                  ),
                ),

              if (!viewModel.catalogCollapsed) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.expand_less),
                        onPressed: _toggleCollapse,
                      ),
                      const SizedBox(width: 2),
                      IconButton(
                        icon: Icon(
                          viewModel.wishlistOnly ? Icons.star : Icons.star_border,
                          color: viewModel.wishlistOnly ? Colors.amber : null,
                        ),
                        onPressed: () {
                          DebugLogger().logTap(details: 'Toggle Wishlist Only');
                          viewModel.toggleWishlistOnly();
                        },
                      ),
                      const SizedBox(width: 2),
                      IconButton(
                        icon: Icon(
                          viewModel.bookmarkOnly ? Icons.bookmark : Icons.bookmark_border,
                          color: viewModel.bookmarkOnly ? Colors.blue : null,
                        ),
                        onPressed: () {
                          DebugLogger().logTap(details: 'Toggle Bookmark Only');
                          viewModel.toggleBookmarkOnly();
                        },
                      ),
                      const SizedBox(width: 2),
                      _filterChip('M', viewModel.cardTypeFilter == 'Monster', () => _toggleCardTypeFilter('Monster')),
                      _filterChip('S', viewModel.cardTypeFilter == 'Spell', () => _toggleCardTypeFilter('Spell')),
                      _filterChip('T', viewModel.cardTypeFilter == 'Trap', () => _toggleCardTypeFilter('Trap')),
                      _filterChip('E', viewModel.cardTypeFilter == 'ExtraDeckMonster', () => _toggleCardTypeFilter('ExtraDeckMonster')),
                      const SizedBox(width: 2),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {
                          DebugLogger().logTap(details: 'Open Advanced Filters');
                          _showAdvancedFilterSheet(context, viewModel);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_sweep),
                        onPressed: () {
                          DebugLogger().logTap(details: 'Clear Filters');
                          viewModel.clearAdvancedFilters();
                        },
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: l10n.searchHintCatalog,
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: viewModel.setSearchText,
                        ),
                      ),
                      const SizedBox(width: 4),
                      DropdownButton<String>(
                        value: viewModel.sortType,
                        items: const [
                          DropdownMenuItem(value: 'Name', child: Text('Name')),
                          DropdownMenuItem(value: 'Level', child: Text('Level')),
                          DropdownMenuItem(value: 'Rank', child: Text('Rank')),
                          DropdownMenuItem(value: 'LinkRating', child: Text('Link Rating')),
                          DropdownMenuItem(value: 'PendulumScale', child: Text('Pendulum Scale')),
                          DropdownMenuItem(value: 'Atk', child: Text('ATK')),
                          DropdownMenuItem(value: 'Def', child: Text('DEF')),
                        ],
                        onChanged: (val) => viewModel.setSortType(val!),
                      ),
                      IconButton(
                        icon: Icon(viewModel.sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
                        onPressed: viewModel.toggleSortOrder,
                      ),
                    ],
                  ),
                ),
              ],

              // ----- CARD GRID -----
              Expanded(
                child: viewModel.filteredCards.isEmpty
                    ? Center(child: Text(l10n.noCardsFound))
                    : GridView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: viewModel.filteredCards.length,
                        itemBuilder: (context, index) {
                          final card = viewModel.filteredCards[index];
                          final isExtra = _isExtraDeckCard(card);
                          final targetList = isExtra
                              ? viewModel.extraDeckCardIds
                              : viewModel.mainDeckCardIds;
                          final count = targetList.where((id) => id == card.id).length;

                          return GestureDetector(
                            onLongPressStart: (details) {
                              _showRadialMenu(context, details.globalPosition, card);
                            },
                            onTap: () {
                              DebugLogger().logTap(details: 'Add Card ${card.id}');
                              if (count >= 3) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.maxCopiesReached),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                                return;
                              }
                              if (isExtra) {
                                viewModel.addCardToExtra(card);
                              } else {
                                viewModel.addCardToMain(card);
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
                                  if (count > 0)
                                    Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: theme.primaryColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'x$count',
                                        style: TextStyle(fontSize: 10, color: theme.primaryColor),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        backgroundColor: Colors.transparent,
        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      ),
    );
  }

  void _showAdvancedFilterSheet(BuildContext context, DeckProfileViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdvancedFilterSheet(viewModel: viewModel),
    );
  }
}