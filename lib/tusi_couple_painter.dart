import 'dart:math';
import 'package:flutter_tusi_couple_animation/radian_util.dart';
import 'package:flutter_tusi_couple_animation/random_color.dart';
import 'package:flutter/material.dart';

const int kMaxDots = 24;
const int kMinDots = 1;
const double kPointRadius = 5.0;

class TusiCouplePainter extends CustomPainter {
  TusiCouplePainter(
      {required this.numberOfLines,
      required this.colors,
      required this.angle,
      this.innerCircleVisible = false,
      this.isTracePathVisible = false});

  final double angle;
  final int numberOfLines;
  final List<Color> colors; // equal to numberOfLines
  final bool innerCircleVisible;
  final bool isTracePathVisible;

  double radius = 0.0;

  double pivotX = 0.0;
  double pivotY = 0.0;

  final circlePaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 2.5
    ..style = PaintingStyle.stroke;

  final centerPointPaint = Paint()
    ..color = Colors.grey
    ..style = PaintingStyle.fill;

  final linePaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 2.5
    ..style = PaintingStyle.stroke;

  void drawOuterCircleTracePath(Canvas canvas) {
    final linesToDraw = numberOfLines * 2;
    final theta = 360.0 / linesToDraw;
    for (int i = 0; i < linesToDraw; i++) {
      final distanceX =
          pivotX + (radius * cos(RadianUtils.angleToRadian(theta * i)));
      final distanceY =
          pivotY + (radius * sin(RadianUtils.angleToRadian(theta * i)));

      canvas.drawLine(
          Offset(pivotX, pivotY), Offset(distanceX, distanceY), linePaint);
    }
  }

  void drawInnerCircle(Canvas canvas) {
    final theta = 360.0 / numberOfLines;

    for (int i = 0; i < numberOfLines; i++) {
      final dotPaint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      final cX = pivotX +
          ((radius / 2) * cos(RadianUtils.angleToRadian((theta * i) + angle)));
      final cY = pivotY +
          ((radius / 2) * sin(RadianUtils.angleToRadian((theta * i) + angle)));
      final dX =
          cX + ((radius / 2) * cos(RadianUtils.angleToRadian(360.0 - angle)));
      final dY =
          cY + ((radius / 2) * sin(RadianUtils.angleToRadian(360.0 - angle)));

      if (innerCircleVisible) {
        final circlePath = Path()
          ..addOval(
              Rect.fromCircle(center: Offset(cX, cY), radius: radius / 2));
        canvas.drawPath(circlePath, circlePaint);

        canvas.drawLine(Offset(cX, cY), Offset(dX, dY), linePaint);

        final centerPointPath = Path()
          ..addOval(Rect.fromCircle(
              center: Offset(cX, cY), radius: kPointRadius / 2));
        canvas.drawPath(centerPointPath, centerPointPaint);
      }

      final dotPath = Path()
        ..addOval(
            Rect.fromCircle(center: Offset(dX, dY), radius: kPointRadius));
      canvas.drawPath(dotPath, dotPaint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    pivotX = size.width / 2;
    pivotY = size.height / 2;
    radius = min(size.width, size.height) / 2 - kPointRadius;

    final outerCirclePath = Path()
      ..addOval(
          Rect.fromCircle(center: Offset(pivotX, pivotY), radius: radius));
    canvas.drawPath(outerCirclePath, circlePaint);

    if (isTracePathVisible) {
      drawOuterCircleTracePath(canvas);
    }

    drawInnerCircle(canvas);
  }

  @override
  bool shouldRepaint(TusiCouplePainter oldDelegate) => true;
}
