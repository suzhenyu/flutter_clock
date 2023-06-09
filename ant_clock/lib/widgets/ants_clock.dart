// Copyright 2020 Stuart Delivery Limited. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ffi';

import 'package:ant_clock/widgets/cloudy.dart';
import 'package:ant_clock/widgets/fog.dart';
import 'package:ant_clock/widgets/ground.dart';
import 'package:ant_clock/widgets/rain_drops.dart';
import 'package:ant_clock/widgets/snow_flakes.dart';
import 'package:ant_clock/widgets/thunder_lightning.dart';
import 'package:ant_clock/widgets/windy_leaves.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import 'colony.dart';

class AntsClock extends StatefulWidget {
  const AntsClock(this.model, {super.key});

  final ClockModel model;

  @override
  State<AntsClock> createState() => _AntsClockState();
}

class _AntsClockState extends State<AntsClock> {
  DateTime _dateTime = DateTime.now();

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    widget.model.addListener(_updateModel);

    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AntsClock oldWidget) {
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
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        const Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // final weather = widget.model.weatherCondition;
    final weather = widget.model.weatherCondition!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Ground(
      weatherCondition: weather,
      isDarkMode: isDarkMode,
      child: Stack(
        children: <Widget>[
          Colony(
            hour: widget.model.is24HourFormat
                ? _dateTime.hour
                : _formatTo12Hours(_dateTime.hour),
            minute: _dateTime.minute,
            isDarkMode: isDarkMode,
          ),
          WindyLeaves(weatherCondition: weather, isDarkMode: isDarkMode),
          RainDrops(weatherCondition: weather, isDarkMode: isDarkMode),
          ThunderLightning(weatherCondition: weather, isDarkMode: isDarkMode),
          Cloudy(weatherCondition: weather, isDarkMode: isDarkMode),
          Fog(weatherCondition: weather, isDarkMode: isDarkMode),
          SnowFlakes(weatherCondition: weather, isDarkMode: isDarkMode),
        ],
      ),
    );
  }

  int _formatTo12Hours(int hour) {
    return _dateTime.hour <= 12 ? _dateTime.hour : _dateTime.hour - 12;
  }
}
