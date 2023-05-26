import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freehand_clock/src/utils/constants.dart';

import 'painters/arc_dot_painter.dart';

/// Animates a dot of color `color` and size `dotSize` that traverses the circumference of a circle with radius `radius` once per minute. Clockwise.
class SecondHand extends StatefulWidget {
  final double radius;
  final Color color;
  final double dotSize;

  const SecondHand({
    super.key,
    required this.radius,
    required this.color,
    this.dotSize = 10,
  });

  @override
  State<SecondHand> createState() => _SecondHandState();
}

class _SecondHandState extends State<SecondHand> {
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 10),
      (time) => setState(() {}),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double seconds =
        DateTime.now().second + DateTime.now().millisecond / 1000;

    final double secondHandAngle = seconds * degreesPerSecond;

    return CustomPaint(
      painter: ArcDotPainter(
        arcAngles: [secondHandAngle],
        dotSize: widget.dotSize,
        color: widget.color,
        radius: widget.radius,
      ),
    );
  }
}
