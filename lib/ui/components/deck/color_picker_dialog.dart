import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final String deckId;
  final Function(String newHex) onColorSelected;

  const ColorPickerDialog({
    super.key,
    required this.initialColor,
    required this.deckId,
    required this.onColorSelected,
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _pickedColor;

  @override
  void initState() {
    super.initState();
    _pickedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 5),
              child: Text(
                l10n.editColorTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ColorPicker(
                  pickerColor: _pickedColor,
                  onColorChanged: (color) => setState(() => _pickedColor = color),
                  paletteType: PaletteType.hueWheel,
                  pickerAreaHeightPercent: 0.9,
                  colorPickerWidth: 180,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    final hex = _pickedColor.toARGB32()
                        .toRadixString(16)
                        .substring(2, 8)
                        .toUpperCase();
                    widget.onColorSelected('#$hex');
                    Navigator.pop(context);
                  },
                  child: Text(l10n.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}