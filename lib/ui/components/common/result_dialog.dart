import 'package:flutter/material.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';

class ResultDialog extends StatelessWidget {
  final String result;
  final VoidCallback onClear;

  const ResultDialog({super.key, required this.result, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.resultTitle),
      content: Text(result, style: const TextStyle(fontSize: 48)),
      actions: [
        TextButton(
          onPressed: () {
            onClear();
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}