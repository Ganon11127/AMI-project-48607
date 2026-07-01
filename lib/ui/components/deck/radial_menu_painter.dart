import 'package:flutter/material.dart';

class RadialMenuPainter extends CustomPainter {
  final double radius;
  final Color backgroundColor;
  final Color? borderColor;

  const RadialMenuPainter({
    this.radius = 120,
    required this.backgroundColor,
    this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);

    if (borderColor != null) {
      final borderPaint = Paint()
        ..color = borderColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}