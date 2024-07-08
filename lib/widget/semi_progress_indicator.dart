import 'package:flutter/material.dart';
import 'dart:math' as math;

class SemiCircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  SemiCircleProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 4.0;
    final double radius = size.width / 2;
    final Offset center = Offset(radius, size.height);

    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start angle (180 degrees in radians)
      math.pi, // Sweep angle (180 degrees in radians)
      false,
      backgroundPaint,
    );

    double sweepAngle = math.pi * progress; // Convert progress to radians
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start angle (180 degrees in radians)
      sweepAngle, // Sweep angle based on progress
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(SemiCircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
