import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../../viewmodel/navigation_viewmodel.dart';
import '../../viewmodel/battle_viewmodel.dart';
import '../components/common/bottom_nav_bar.dart';
import '../components/battle/battle_player_panel.dart';
import '../components/battle/battle_control_button.dart';
import '../components/battle/help_dialog.dart';
import '../components/battle/reset_confirmation_dialog.dart';
import '../components/common/result_dialog.dart';
import '../../debug/debug_logger.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Start sensor listening when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BattleViewModel>().startSensorListening();
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Stop sensor listening when screen is disposed
    context.read<BattleViewModel>().stopSensorListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BattleViewModel>(
      builder: (context, viewModel, child) {
        final navVM = context.watch<NavigationViewModel>();
        final l10n = AppLocalizations.of(context)!;
        final theme = Theme.of(context);

        // Show result dialog if any
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (viewModel.diceResult != null) {
            _showResultDialog(
              context,
              '${l10n.dicePrefix}: ${viewModel.diceResult}',
              viewModel.clearResults,
            );
          } else if (viewModel.coinResult != null) {
            final coinText = viewModel.coinResult == 'Heads'
                ? l10n.coinHeads
                : l10n.coinTails;
            _showResultDialog(
              context,
              coinText,
              viewModel.clearResults,
            );
          }
        });

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: BattlePlayerPanel(
                  playerLabel: '${l10n.battlePlayer} 1',
                  lp: viewModel.player1LP,
                  buffer: viewModel.player1Buffer,
                  playerId: 1,
                  viewModel: viewModel,
                  quarterTurns: viewModel.rotationQuarterTurns,
                ),
              ),
              // MIDDLE CONTROLS
              Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                width: MediaQuery.of(context).size.width,
                height: 55,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: theme.colorScheme.onSurface, width: 3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    BattleControlButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        DebugLogger().logTap(details: 'Battle Refresh');
                        _confirmReset(context, viewModel);
                      },
                    ),
                    BattleControlButton(
                      icon: const Icon(Icons.sync),
                      onPressed: () {
                        DebugLogger().logTap(details: 'Battle Rotate');
                        viewModel.rotateScreen();
                      },
                    ),
                    BattleControlButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        DebugLogger().logTap(details: 'Battle Settings');
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                    BattleControlButton(
                      icon: viewModel.showBottomNav
                          ? const Icon(Icons.expand_more)
                          : const Icon(Icons.expand_less),
                      onPressed: () {
                        DebugLogger().logTap(details: 'Battle Toggle Nav');
                        viewModel.toggleBottomNav();
                      },
                    ),
                    BattleControlButton(
                      icon: const FaIcon(FontAwesomeIcons.language),
                      onPressed: () {
                        DebugLogger().logTap(details: 'Battle Translation');
                        Navigator.pushNamed(context, '/translation');
                      },
                    ),
                    BattleControlButton(
                      icon: const Icon(Icons.help),
                      onPressed: () {
                        DebugLogger().logTap(details: 'Battle Help');
                        _showHelpDialog(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: BattlePlayerPanel(
                  playerLabel: '${l10n.battlePlayer} 2',
                  lp: viewModel.player2LP,
                  buffer: viewModel.player2Buffer,
                  playerId: 2,
                  viewModel: viewModel,
                  quarterTurns: viewModel.rotationQuarterTurns,
                ),
              ),
            ],
          ),
          bottomNavigationBar: viewModel.showBottomNav
              ? BottomNavBar(
                  currentIndex: navVM.getIndexOfKey('bottomNavBattle'),
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
                )
              : null,
        );
      },
    );
  }

  void _showResultDialog(BuildContext context, String result, VoidCallback onClear) {
    if (ModalRoute.of(context)?.isCurrent != true) return;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ResultDialog(
        result: result,
        onClear: onClear,
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const HelpDialog(),
    );
  }

  void _confirmReset(BuildContext context, BattleViewModel viewModel) {
    showDialog(
      context: context,
      builder: (_) => ResetConfirmationDialog(viewModel: viewModel),
    );
  }
}