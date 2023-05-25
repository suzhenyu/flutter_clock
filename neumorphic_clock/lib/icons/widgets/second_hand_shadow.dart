import 'package:neumorphic_clock/icons/widgets/animated_container_hand.dart';
import 'package:flutter/material.dart';

class SecondHandShadow extends StatelessWidget {
  const SecondHandShadow({
    super.key,
    required this.unit,
    required DateTime now,
    required this.customTheme,
  }) : _now = now;

  final double unit;
  final DateTime _now;
  final ThemeData customTheme;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(unit / 2, unit / 1.9),
      child: AnimatedContainerHand(
        now: _now.second,
        size: 0.6,
        child: Transform.translate(
          offset: Offset(0.0, -4 * unit),
          child: Container(
            width: unit / 3,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: customTheme.canvasColor,
                  blurRadius: unit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
