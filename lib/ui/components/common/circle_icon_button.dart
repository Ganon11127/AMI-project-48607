import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 50,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: theme.cardColor,
        shape: BoxShape.circle,
        border: Border.all(color: theme.colorScheme.onSurface, width: 2),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: theme.colorScheme.onSurface,
        iconSize: iconSize,
      ),
    );
  }
}