import 'package:flutter/material.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';

class EditNameDialog extends StatefulWidget {
  final String currentName;
  final Function(String newName) onSave;

  const EditNameDialog({super.key, required this.currentName, required this.onSave});

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.editNameTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(hintText: l10n.enterNewName),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            final newName = _controller.text.trim();
            if (newName.isNotEmpty) {
              widget.onSave(newName);
            }
            Navigator.pop(context);
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}