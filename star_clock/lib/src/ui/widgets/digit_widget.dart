import 'package:star_clock/src/core/flare_controllers/digit_controller.dart';
import 'package:star_clock/src/core/helpers/state_helper.dart';
import 'package:star_clock/src/ui/widgets/digit_layer.dart';
import 'package:star_clock/star_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class DigitWidget extends StatefulWidget {
  static const String ANIMATION_ENTRY = "entry";
  static const String ANIMATION_IDLE = "idle";
  static const String ANIMATION_EXIT = "exit";

  /// This is necessary to get unique keys to rebuild the widget
  final int position;

  /// Set to -1 to display a colon
  final int digit;

  final ClockTheme theme;
  final WeatherCondition weather;
  final DateTime dateTime;

  const DigitWidget({
    super.key,
    required this.digit,
    required this.position,
    required this.theme,
    required this.weather,
    required this.dateTime,
  });

  @override
  _DigitWidgetState createState() => _DigitWidgetState();
}

class _DigitWidgetState extends State<DigitWidget> {
  bool active = true;
  List<DigitController> digitController = [
    DigitController(),
    DigitController()
  ];

  List<int?> digits = [null, null];

  List<String> animation = ["idle", "idle"];

  int counter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkNow = isDark(widget.theme, widget.dateTime, widget.weather);

    bool shouldRebuild = widget.digit != digits[getLayer(active)];
    if (shouldRebuild) {
      digits[getLayer(!active)] = digits[getLayer(active)];
      digits[getLayer(active)] = widget.digit;

      animation[getLayer(active)] = DigitWidget.ANIMATION_ENTRY;
      animation[getLayer(!active)] = DigitWidget.ANIMATION_EXIT;
      counter++;
    }

    var ret = Container(
      // Rebuild only if any of the data changes
      key: Key(
          "DigitContainer_${isDarkNow.toString()}_${widget.theme.toString()}_${widget.weather.toString()}_${widget.position}_$counter"),
      child: Stack(
        children: [
          getAnimationLayer(0),
          getAnimationLayer(1),
        ],
      ),
    );

    return ret;
  }

  Widget getAnimationLayer(int layer) {
    int? digit = digits[layer];

    if (digit == null) {
      return Container();
    }

    return DigitLayer(
      animation: animation[layer],
      digit: digit,
      theme: widget.theme,
      weather: widget.weather,
      dateTime: widget.dateTime,
    );
  }

  int getLayer(topIsActive) {
    return topIsActive ? 1 : 0;
  }

  bool notNull(Object o) => o != null;
}
