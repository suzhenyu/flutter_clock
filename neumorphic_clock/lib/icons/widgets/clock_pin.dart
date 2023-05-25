import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class ClockPin extends StatelessWidget {
  const ClockPin({
    super.key,
    required this.unit,
    required this.customTheme,
  });

  final double unit;
  final ThemeData customTheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics.fromProperties(
        properties: SemanticsProperties(label: 'Clock center'),
        child: Container(
          height: 0.8 * unit,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: customTheme.accentColor,
          ),
        ),
      ),
    );
  }
}
