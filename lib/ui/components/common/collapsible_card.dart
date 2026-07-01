import 'package:flutter/material.dart';

class CollapsibleCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isInitiallyExpanded;
  final Widget? addButton;
  final EdgeInsetsGeometry childrenPadding;

  const CollapsibleCard({
    super.key,
    required this.title,
    required this.children,
    this.isInitiallyExpanded = false,
    this.addButton,
    this.childrenPadding = const EdgeInsets.fromLTRB(0, 0, 0, 5),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 6, 10, 6),
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerTheme: const DividerThemeData(
            space: 0,
            thickness: 0,
            color: Colors.transparent,
          ),
          listTileTheme: const ListTileThemeData(
            dense: true,
            minVerticalPadding: 0, 
            contentPadding:
                EdgeInsets.zero,
          ),
        ),
        child: ExpansionTile(
          title: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              ?addButton,
            ],
          ),
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ), // keep as is
          childrenPadding: childrenPadding,
          initiallyExpanded: isInitiallyExpanded,
          shape: const Border(),
          collapsedShape: const Border(),
          children: children,
        ),
      ),
    );
  }
}
