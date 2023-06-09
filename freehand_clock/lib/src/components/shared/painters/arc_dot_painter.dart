import 'package:flutter/material.dart';
import 'package:freehand_clock/src/utils/tools.dart';

/// For every angle value in `arcAngles`, paints a dot at a corresponding point along the circumference of a circle with radius `radius`.
class ArcDotPainter extends CustomPainter {
  final List<double> arcAngles;
  final double dotSize;
  final Color color;
  final double radius;

  const ArcDotPainter({
    required this.arcAngles,
    required this.dotSize,
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size _) {
    final Paint paint = Paint()
      ..strokeWidth = dotSize
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (num angle in arcAngles) {
      canvas.drawArc(
        Rect.fromCircle(
          center: const Offset(0, 0),
          radius: radius,
        ),
        radiansFromAngle(angle - 90),
        .001,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
