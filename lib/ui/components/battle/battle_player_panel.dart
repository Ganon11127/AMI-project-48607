import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yu_gi_oh_app/ui/components/common/circle_icon_button.dart';
import 'package:yu_gi_oh_app/ui/components/battle/battle_life_button.dart';
import 'package:yu_gi_oh_app/viewmodel/battle_viewmodel.dart';
import 'package:yu_gi_oh_app/ui/components/battle/calculator_dialog.dart';
// Debug
import 'package:yu_gi_oh_app/debug/debug_logger.dart';

class BattlePlayerPanel extends StatelessWidget {
  final String playerLabel;
  final int lp;
  final int buffer;
  final int playerId;
  final BattleViewModel viewModel;
  final int quarterTurns;

  const BattlePlayerPanel({
    super.key,
    required this.playerLabel,
    required this.lp,
    required this.buffer,
    required this.playerId,
    required this.viewModel,
    required this.quarterTurns,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RotatedBox(
      quarterTurns: quarterTurns,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(playerLabel, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16)),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    lp.toString(),
                    style: TextStyle(fontSize: 65, color: theme.colorScheme.onSurface),
                  ),
                  if (buffer != 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '$buffer',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.primaryColor),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    border: Border.all(color: theme.colorScheme.onSurface, width: 2),
                                  ),
                                  child: IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.calculator),
                                    onPressed: () {
                                      DebugLogger().logTap(details: 'Calculator P$playerId');
                                      CalculatorDialog.show(context, playerId, viewModel);
                                    },
                                    color: theme.colorScheme.onSurface,
                                    iconSize: 20,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              BattleLifeButton(
                                label: '10',
                                onPressed: () {
                                  DebugLogger().logTap(details: 'Add 10 P$playerId');
                                  viewModel.addToBuffer(playerId, 10);
                                },
                              ),
                              const SizedBox(width: 4),
                              BattleLifeButton(
                                label: '50',
                                onPressed: () {
                                  DebugLogger().logTap(details: 'Add 50 P$playerId');
                                  viewModel.addToBuffer(playerId, 50);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BattleLifeButton(
                                label: '100',
                                onPressed: () {
                                  DebugLogger().logTap(details: 'Add 100 P$playerId');
                                  viewModel.addToBuffer(playerId, 100);
                                },
                              ),
                              const SizedBox(width: 4),
                              BattleLifeButton(
                                label: '500',
                                onPressed: () {
                                  DebugLogger().logTap(details: 'Add 500 P$playerId');
                                  viewModel.addToBuffer(playerId, 500);
                                },
                              ),
                              const SizedBox(width: 4),
                              BattleLifeButton(
                                label: '1000',
                                onPressed: () {
                                  DebugLogger().logTap(details: 'Add 1000 P$playerId');
                                  viewModel.addToBuffer(playerId, 1000);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleIconButton(
                          icon: Icons.add,
                          onPressed: () {
                            DebugLogger().logTap(details: 'Apply Buffer + P$playerId');
                            viewModel.applyBuffer(playerId);
                          },
                        ),
                        CircleIconButton(
                          icon: Icons.remove,
                          onPressed: () {
                            DebugLogger().logTap(details: 'Apply Buffer - P$playerId');
                            viewModel.applyBuffer(playerId, isNegative: true);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}