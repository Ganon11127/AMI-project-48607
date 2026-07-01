import 'package:flutter/material.dart';

class BattleControlButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;

  const BattleControlButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: theme.cardColor,
        shape: BoxShape.circle,
        border: Border.all(color: theme.colorScheme.onSurface, width: 1),
      ),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
        color: theme.colorScheme.onSurface,
        iconSize: 24,
      ),
    );
  }
}