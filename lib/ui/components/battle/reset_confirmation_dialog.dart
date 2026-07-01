import 'package:flutter/material.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';
import 'package:yu_gi_oh_app/viewmodel/battle_viewmodel.dart';

class ResetConfirmationDialog extends StatelessWidget {
  final BattleViewModel viewModel;

  const ResetConfirmationDialog({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.resetConfirmTitle),
      content: Text(l10n.resetConfirmContent),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            viewModel.resetLP();
            Navigator.pop(context);
          },
          child: Text(l10n.resetConfirmReset),
        ),
      ],
    );
  }
}