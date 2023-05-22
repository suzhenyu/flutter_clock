import 'package:flare_flutter/flare_controls.dart';

// Class that extends [FlareControls] and implements a callback for [FlareControls.onCompleted].
class BirdController extends FlareControls {
  final Function onAnimationEnd;

  // Constructor with our callback.
  //
  // The class is used in [Clock] to give access to the [Clock._dateTime] and other
  // variables.
  BirdController({required this.onAnimationEnd});

  @override
  void onCompleted(String name) {
    // Execute the callback.
    onAnimationEnd(name);
    super.onCompleted(name);
  }
}
