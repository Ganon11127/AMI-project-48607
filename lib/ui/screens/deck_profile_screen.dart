import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/deck_profile_viewmodel.dart';
import '../../l10n/app_localizations.dart';
import '../components/deck/deck_section.dart';
import '../components/deck/catalog_sheet.dart';
import '../components/deck/color_picker_dialog.dart';
import '../components/deck/delete_confirmation_dialog.dart';
// Debug
import 'package:yu_gi_oh_app/debug/debug_logger.dart';

class DeckProfileScreen extends StatefulWidget {
  const DeckProfileScreen({super.key});

  @override
  State<DeckProfileScreen> createState() => _DeckProfileScreenState();
}

class _DeckProfileScreenState extends State<DeckProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _colorFocus = FocusNode();

  final DraggableScrollableController _sheetController = DraggableScrollableController();
  double _sheetHeight = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<DeckProfileViewModel>();
      _nameController.text = viewModel.deckName;
      _colorController.text = viewModel.deckColor;
    });
    _sheetController.addListener(_updateSheetHeight);
  }

  @override
  void dispose() {
    _sheetController.removeListener(_updateSheetHeight);
    _sheetController.dispose();
    _nameController.dispose();
    _colorController.dispose();
    _nameFocus.dispose();
    _colorFocus.dispose();
    super.dispose();
  }

  void _updateSheetHeight() {
    setState(() {
      _sheetHeight = _sheetController.pixels;
    });
  }

  Color _getColorFromHex(String hex) {
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Color _getTextColorForBackground(Color bg) {
    final luminance = bg.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  void _showColorPicker(BuildContext context, DeckProfileViewModel viewModel) {
    final currentColor = _getColorFromHex(viewModel.deckColor);
    showDialog(
      context: context,
      builder: (_) => ColorPickerDialog(
        initialColor: currentColor,
        deckId: viewModel.deckId,
        onColorSelected: (newHex) {
          viewModel.setDeckColor(newHex);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.watch<DeckProfileViewModel>();
    final theme = Theme.of(context);

    if (!_nameFocus.hasFocus && _nameController.text != viewModel.deckName) {
      _nameController.text = viewModel.deckName;
    }
    if (!_colorFocus.hasFocus && _colorController.text != viewModel.deckColor) {
      _colorController.text = viewModel.deckColor;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        await viewModel.saveDeck();
        if (!mounted) return;
        navigator.pop(result);
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: _sheetHeight),
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: theme.primaryColor),
                            onPressed: () async {
                              DebugLogger().logTap(details: 'Back to Deck List');
                              final navigator = Navigator.of(context);
                              await viewModel.saveDeck();
                              if (!mounted) return;
                              navigator.pop();
                            },
                          ),
                          const Spacer(),
                          Text(
                            l10n.deckProfileTitle,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          // Favourite
                          IconButton(
                            icon: Icon(
                              viewModel.isFavourite ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              DebugLogger().logTap(details: 'Toggle Favourite');
                              viewModel.toggleFavourite();
                            },
                          ),
                          // Wishlist
                          IconButton(
                            icon: FaIcon(
                              viewModel.isWishlist ? FontAwesomeIcons.solidBell : FontAwesomeIcons.bell,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              DebugLogger().logTap(details: 'Toggle Wishlist');
                              viewModel.toggleWishlist();
                            },
                          ),
                          // Delete
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              DebugLogger().logTap(details: 'Delete Deck from Profile');
                              showDialog(
                                context: context,
                                builder: (_) => DeleteConfirmationDialog(
                                  onDelete: () {
                                    viewModel.deleteDeck();
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Deck name and color picker
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              focusNode: _nameFocus,
                              decoration: InputDecoration(
                                labelText: l10n.deckName,
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: viewModel.setDeckName,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _colorController,
                              focusNode: _colorFocus,
                              readOnly: true,
                              onTap: () {
                                DebugLogger().logTap(details: 'Open Color Picker');
                                _showColorPicker(context, viewModel);
                              },
                              decoration: InputDecoration(
                                labelText: l10n.colorHex,
                                hintText: '#1a73e8',
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: _getColorFromHex(viewModel.deckColor),
                                labelStyle: TextStyle(
                                  color: _getTextColorForBackground(
                                    _getColorFromHex(viewModel.deckColor),
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  color: _getTextColorForBackground(
                                    _getColorFromHex(viewModel.deckColor),
                                  ).withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            DeckSection(
                              title: '${l10n.mainDeck} (${viewModel.mainDeckCardIds.length}/60)',
                              cardIds: viewModel.mainDeckCardIds,
                              isMain: true,
                              viewModel: viewModel,
                            ),
                            const SizedBox(height: 8),
                            DeckSection(
                              title: '${l10n.extraDeck} (${viewModel.extraDeckCardIds.length}/15)',
                              cardIds: viewModel.extraDeckCardIds,
                              isMain: false,
                              viewModel: viewModel,
                            ),
                            if (!viewModel.isMainDeckLegal)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.warning, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        l10n.mainDeckWarning,
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: CatalogSheet(
                  viewModel: viewModel,
                  controller: _sheetController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}