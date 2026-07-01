import 'package:flutter/material.dart';

class BattleLifeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const BattleLifeButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 50,
      height: 30,
      child: MaterialButton(
        onPressed: onPressed,
        color: theme.cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: theme.colorScheme.onSurface, width: 2),
        ),
        padding: EdgeInsets.zero,
        textColor: theme.colorScheme.onSurface,
        minWidth: 50,
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}