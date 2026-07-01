import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';

import '../../l10n/app_localizations.dart';
import '../../viewmodel/translation_viewmodel.dart';
import '../../viewmodel/navigation_viewmodel.dart';
import '../components/common/bottom_nav_bar.dart';
import '../components/translation/translation_card_info.dart';
import '../../debug/debug_logger.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize camera after the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<TranslationViewModel>();
      vm.initializeCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    final navVM = context.watch<NavigationViewModel>();
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
                children: [
                  Text(
                    l10n.translationTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 35,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.settings, color: Theme.of(context).primaryColor, size: 42),
                    onPressed: () {
                      DebugLogger().logTap(details: 'Settings from Translation');
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
            ),
            // Camera and overlay
            Expanded(
              child: Consumer<TranslationViewModel>(
                builder: (context, viewmodel, _) {
                  if (!viewmodel.isCameraReady) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      if (viewmodel.isCameraReady)
                        CameraPreview(viewmodel.cameraController!),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black54,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewmodel.recognizedText.isEmpty
                                    ? l10n.translationHint
                                    : viewmodel.recognizedText,
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                              ),
                              const SizedBox(height: 8),
                              if (viewmodel.isSearching)
                                const Center(child: CircularProgressIndicator())
                              else if (viewmodel.searchErrorCode != null)
                                Builder(
                                  builder: (_) {
                                    final code = viewmodel.searchErrorCode!;
                                    final params = viewmodel.errorParams;
                                    String message;
                                    if (code == 'noCardFound') {
                                      message = l10n.noCardFound(params?['text'] ?? '');
                                    } else if (code == 'errorOccurred') {
                                      message = l10n.errorOccurred(params?['error'] ?? '');
                                    } else {
                                      message = code;
                                    }
                                    return Text(message, style: const TextStyle(color: Colors.red));
                                  },
                                )
                              else if (viewmodel.matchedCard != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: viewmodel.matchedCard!.mainImageUrl,
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
                                            viewmodel.matchedCard!.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          TranslationCardInfo(
                                            card: viewmodel.matchedCard!,
                                            viewModel: viewmodel,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              else
                                const SizedBox.shrink(),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  DebugLogger().logTap(details: 'Find Card');
                                  viewmodel.processImageAndSearch();
                                },
                                child: Text(l10n.findCardButton),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: navVM.getIndexOfKey('bottomNavTranslation'),
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
}