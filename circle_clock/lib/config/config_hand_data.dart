import 'package:circle_clock/models/circle_hand_model.dart';

class ConfigHandData {
  static const hourHand = CircleHandModel(
    scale: 1.3,
    lightness: 0.25,
    animationMs: 4900,
  );
  static const minuteHand = CircleHandModel(
    scale: 0.7,
    lightness: 0.50,
    animationMs: 2900,
  );
  static const secondHand = CircleHandModel(
    scale: 0.15,
    lightness: 0.70,
    animationMs: 900,
  );
}
