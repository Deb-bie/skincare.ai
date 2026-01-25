import 'dart:math' as math;

import 'package:flutter/material.dart';


class AnimatedRingsPainter extends CustomPainter {
  final double animation;
  final bool isDarkMode;

  AnimatedRingsPainter({
    required this.animation,
    this.isDarkMode = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Define orange color variants
    const primaryOrange = Color(0xFFFF7A59);
    const lightOrange = Color(0xFFFFB09C);
    const paleOrange = Color(0xFFFFF0EC);

    // Adjust colors for dark mode
    final outerRingColor = isDarkMode
        ? paleOrange.withValues(alpha: 0.2)
        : paleOrange;

    final innerRingColor = isDarkMode
        ? lightOrange.withValues(alpha: 0.8)
        : lightOrange;

    final centerFillColor = isDarkMode
        ? primaryOrange.withValues(alpha: 0.15)
        : primaryOrange.withValues(alpha: 0.1);

    final pulseColor = isDarkMode
        ? primaryOrange.withValues(alpha: 0.08)
        : primaryOrange.withValues(alpha: 0.05);

    // Outer ring
    paint.color = outerRingColor;
    paint.strokeWidth = 3;
    final outerRadius = size.width / 2 - 10;

    final outerStartAngle = -math.pi / 2 + (animation * 2 * math.pi);
    final outerSweepAngle = math.pi * 1.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      outerStartAngle,
      outerSweepAngle,
      false,
      paint,
    );

    // Inner ring
    paint.color = innerRingColor;
    paint.strokeWidth = 3;
    final innerRadius = size.width / 2 - 40;

    final innerStartAngle = -math.pi / 2 - (animation * 2 * math.pi);
    final innerSweepAngle = math.pi * 1.8;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      innerStartAngle,
      innerSweepAngle,
      false,
      paint,
    );

    // Center circle
    paint.style = PaintingStyle.fill;
    paint.color = centerFillColor;
    canvas.drawCircle(center, innerRadius - 20, paint);

    // Pulsing effect
    final pulseRadius = innerRadius - 20 + (10 * math.sin(animation * 2 * math.pi));
    paint.color = pulseColor;
    canvas.drawCircle(center, pulseRadius, paint);
  }

  @override
  bool shouldRepaint(covariant AnimatedRingsPainter oldDelegate) {
    return animation != oldDelegate.animation || isDarkMode != oldDelegate.isDarkMode;
  }
}
