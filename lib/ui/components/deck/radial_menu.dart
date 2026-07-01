import 'dart:math';
import 'package:flutter/material.dart';
import 'radial_menu_painter.dart';

class RadialMenu extends StatelessWidget {
  final List<RadialMenuItem> items;
  final Offset center;
  final VoidCallback onDismiss;
  final double scale;

  const RadialMenu({
    super.key,
    required this.items,
    required this.center,
    required this.onDismiss,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;

    final double containerSize = 240 * s;
    final double halfContainer = containerSize / 2;
    final double buttonRadius = 90 * s;
    final double buttonSize = 60 * s;
    final double halfButton = buttonSize / 2;
    final double painterRadius = 120 * s;

    final theme = Theme.of(context);
    final backgroundColor = theme.cardColor;

    return GestureDetector(
      onTap: onDismiss,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Container(color: Colors.black26),
            Positioned(
              left: center.dx - halfContainer,
              top: center.dy - halfContainer,
              width: containerSize,
              height: containerSize,
              child: CustomPaint(
                painter: RadialMenuPainter(
                  radius: painterRadius,
                  backgroundColor: backgroundColor,
                ),
                child: Stack(
                  children: items.map((item) {
                    return _buildRadialButton(
                      context,
                      item,
                      buttonRadius: buttonRadius,
                      halfContainer: halfContainer,
                      halfButton: halfButton,
                      buttonSize: buttonSize,
                      scale: s,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadialButton(
    BuildContext context,
    RadialMenuItem item, {
    required double buttonRadius,
    required double halfContainer,
    required double halfButton,
    required double buttonSize,
    required double scale,
  }) {
    final radians = item.angle * 3.14159 / 180;
    final dx = buttonRadius * -sin(radians);
    final dy = buttonRadius * -cos(radians);

    return Positioned(
      left: halfContainer + dx - halfButton,
      top: halfContainer + dy - halfButton,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            item.onTap();
            onDismiss();
          },
          borderRadius: BorderRadius.circular(buttonSize / 2),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30 * scale,
                  height: 30 * scale,
                  child: Center(child: item.iconWidget),
                ),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14 * scale,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RadialMenuItem {
  final double angle;
  final Widget iconWidget;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool useFontAwesome;

  RadialMenuItem({
    required this.angle,
    required this.iconWidget,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.useFontAwesome = false,
  });
}