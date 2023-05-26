import 'package:flutter/material.dart';

// This widget is used as Second's, Minute's & Hour's hand in the Main Clock.
Widget customHand({
  required double angleRadians,
  required String imagePath,
  required double xOffset,
  required double yOffset,
}) {
  return SizedBox(
    child: Transform.rotate(
      angle: angleRadians,
      alignment: Alignment.center,
      child: Transform.translate(
        offset: Offset(xOffset, yOffset),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(-2, 2),
                blurRadius: 5,
              ),
            ],
            borderRadius: BorderRadius.circular(7.5),
          ),
          child: Image(
            image: AssetImage(imagePath),
          ),
        ),
      ),
    ),
  );
}

// This widget as hand that displays the current Meridiem.
Widget customHandAmPm({
  required Animation<double> rotationAnimation,
}) {
  return SizedBox(
    child: RotationTransition(
      alignment: Alignment.center,
      turns: rotationAnimation,
      child: Transform.translate(
        offset: const Offset(0.0, -6.5),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(-2, 2),
                blurRadius: 5,
              ),
            ],
            borderRadius: BorderRadius.circular(7.5),
          ),
          child: const Image(
            image: AssetImage('assets/images/hand_ampm.png'),
          ),
        ),
      ),
    ),
  );
}
