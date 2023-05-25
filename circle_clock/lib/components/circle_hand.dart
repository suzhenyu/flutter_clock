import 'package:flutter/material.dart';

class CircleHand extends StatelessWidget {
  const CircleHand({
    super.key,
    required this.scale,
    required this.lightness,
  });

  final double scale;
  final double lightness;

  @override
  Widget build(BuildContext context) => Transform.scale(
        scale: scale,
        child: Container(
          decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.difference,
            //color: HSLColor.fromAHSL(1.0, 0.0, 0.65, lightness).toColor(),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: const <double>[0.0, 1.0],
              colors: [
                HSLColor.fromAHSL(1.0, 0.0, 0.5, lightness - 0.1).toColor(),
                HSLColor.fromAHSL(1.0, 0.0, 0.5, lightness + 0.1).toColor(),
              ],
            ),
            shape: BoxShape.circle,
          ),
        ),
      );
}
