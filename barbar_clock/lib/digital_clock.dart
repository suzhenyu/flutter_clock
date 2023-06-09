import 'dart:async';

import 'package:barbar_clock/painter/clock_painter.dart';
import 'package:barbar_clock/model/theme.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'const/const.dart';
import 'model/weather_icon.dart';

enum _DigitsPosition { HourOld, MinuteOld, HourNew, MinuteNew }

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model, {super.key});

  final ClockModel model;

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  DateTime _previousDateTime = DateTime.now();
  late Timer _timer;
  double _progress = .0;

  late AnimationController _animationController;
  Animation<double>? _progressAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(
        milliseconds: Const.DIGIT_CHANGE_ANIMATION_DURATION,
      ),
      vsync: this,
    );

    _progressAnimation = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.decelerate))
        .animate(_animationController)
      ..addListener(() {
        setState(() {
          _progress = _progressAnimation?.value ?? .0;
        });
      })
      ..addStatusListener((status) {});

    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _previousDateTime = _dateTime;
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        const Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );

      // This part can be useful for testing
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
//      _timer = Timer(
//        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
//        _updateTime,
//      );

      // Run digit change animation
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hoursMinutes =
        _getDisplayedAndPreviousTime(widget.model.is24HourFormat);
    return CustomPaint(
      size: Size.infinite,
      painter: ClockPainter(
        theme: DarkTheme,
        weatherIcon: getIcon(widget.model.weatherCondition!, _isNight()),
        temperatureString: _getTemperatureString(),
        dateString: _getDateString(),
        progress: _progress,
        currentHour: hoursMinutes[_DigitsPosition.HourOld]!,
        currentMinute: hoursMinutes[_DigitsPosition.MinuteOld]!,
        newHour: hoursMinutes[_DigitsPosition.HourNew]!,
        newMinute: hoursMinutes[_DigitsPosition.MinuteNew]!,
      ),
    );
  }

  Map<_DigitsPosition, String> _getDisplayedAndPreviousTime(bool is24hFormat) {
    final hourFormat = DateFormat(is24hFormat ? 'HH' : 'hh');
    final minuteFormat = DateFormat('mm');
    return {
      _DigitsPosition.HourOld: hourFormat.format(_previousDateTime),
      _DigitsPosition.MinuteOld: minuteFormat.format(_previousDateTime),
      _DigitsPosition.HourNew: hourFormat.format(_dateTime),
      _DigitsPosition.MinuteNew: minuteFormat.format(_dateTime),
    };
  }

  /// Used to determine whether night icon set or day set should be used
  bool _isNight() => _dateTime.hour >= 22 && _dateTime.hour <= 5;

  /// Get temperature string. Returns integer value and unit
  String _getTemperatureString() {
    final num temperature = widget.model.temperature;
    final unit = widget.model.unitString;
    return "${temperature.toStringAsFixed(0)}$unit";
  }

  /// Get localized date string value
  String _getDateString() => DateFormat.MMMEd().format(_dateTime).toUpperCase();
}
