import 'package:flutter/material.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteConfirmationDialog({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.deleteDeckTitle),
      content: Text(l10n.deleteDeckContent),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(l10n.delete),
        ),
      ],
    );
  }
}