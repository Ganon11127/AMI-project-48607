import 'package:flutter/material.dart';

class MarketChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const MarketChip({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    );
  }
}