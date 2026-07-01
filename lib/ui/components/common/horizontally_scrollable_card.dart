import 'package:flutter/material.dart';

/// A widget that displays a horizontally scrollable row of clickable cards.
/// [items] is a list of data objects (for example a yugioh Card or a Deck) to display.
/// [itemBuilder] is a function that builds a Widget from the data item and index.
/// [onItemTap] is an optional callback when an item is tapped.
class HorizontallyScrollableCard<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final void Function(T item, int index)? onItemTap;
  final double height;

  const HorizontallyScrollableCard({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onItemTap,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: onItemTap != null ? () => onItemTap!(item, index) : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
              child: itemBuilder(context, item, index),
            ),
          );
        },
      ),
    );
  }
}