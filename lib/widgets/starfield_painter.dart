import 'dart:math';
import 'package:flutter/material.dart';

class StarfieldPainter extends CustomPainter {
  final int starCount;
  final Color starColor;
  final List<Offset> _stars = [];
  final Random _rng = Random(42);

  StarfieldPainter({
    this.starCount = 70,
    this.starColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (_stars.isEmpty) {
      for (int i = 0; i < starCount; i++) {
        _stars.add(Offset(
          _rng.nextDouble() * size.width,
          _rng.nextDouble() * size.height,
        ));
      }
    }

    final Paint paint = Paint()..color = starColor.withValues(alpha: 0.3);
    for (var star in _stars) {
      final double radius = _rng.nextDouble() * 2.0; // Slightly bigger stars
      canvas.drawCircle(star, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
