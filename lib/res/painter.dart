import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_app/res/constants.dart';

class CircleProgress extends CustomPainter {
  final double value;
  final double stokeWidth;

  CircleProgress(this.value, this.stokeWidth);
  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = Paint()
      ..strokeWidth = stokeWidth
      ..color = AppColors.gray
      ..style = PaintingStyle.stroke;

    Offset center = const Offset(124 / 2, 121 / 2);
    double radius = 54;
    canvas.drawCircle(center, radius, circle);

    Paint animationArc = Paint()
      ..strokeWidth = (stokeWidth - 1)
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double angle = 2 * pi * (value / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, animationArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
