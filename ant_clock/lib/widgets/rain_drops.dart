// Copyright 2020 Stuart Delivery Limited. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:ant_clock/math_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class RainDrops extends StatefulWidget {
  final WeatherCondition weatherCondition;

  final bool isDarkMode;

  const RainDrops({
    super.key,
    required this.weatherCondition,
    required this.isDarkMode,
  });

  @override
  State<RainDrops> createState() => _RainDropsState();
}

class _RainDropsState extends State<RainDrops> {
  static const _rainDropsInterval = 100;

  static const _dropsPerIntervalWhenRainy = 1;

  static const _dropsPerIntervalWhenThunderstorm = 5;

  final List<_RainDropPosition> _rainDropPositions = [];

  late int _dropsPerInterval;

  late Timer _timer;

  double _width = 0;
  double _height = 0;

  @override
  void initState() {
    super.initState();
    _dropsPerInterval = _getDropsPerInterval();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(RainDrops oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.weatherCondition != oldWidget.weatherCondition ||
        widget.isDarkMode != oldWidget.isDarkMode) {
      _dropsPerInterval = _getDropsPerInterval();

      _timer.cancel();

      _width = 0;
      _height = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weather = widget.weatherCondition;
    if (!widget.isDarkMode &&
        (weather == WeatherCondition.rainy ||
            weather == WeatherCondition.thunderstorm)) {
      return LayoutBuilder(
        builder: (context, constraints) {
          _initTimer(constraints);
          return Stack(
            children: _buildRainDrops(),
          );
        },
      );
    } else {
      return Container();
    }
  }

  void _initTimer(BoxConstraints constraints) {
    if (_width == constraints.maxWidth && _height == constraints.maxHeight) {
      return;
    }

    _width = constraints.maxWidth;
    _height = constraints.maxHeight;

    _rainDropPositions.clear();
    _timer.cancel();
    _timer =
        Timer.periodic(Duration(milliseconds: _rainDropsInterval), (timer) {
      setState(() {
        _rainDropPositions.removeWhere((position) {
          return position.rainDropKey.currentState?.isCompleted ?? true;
        });

        for (var i = 0; i < _dropsPerInterval; ++i) {
          final rainDropKey = GlobalKey<_RainDropState>();

          final _RainDropPosition rainDropPosition = _RainDropPosition(
            randomDouble(0.0, _width - _RainDropState.rainDropSize),
            randomDouble(0.0, _height - _RainDropState.rainDropSize),
            _RainDrop(key: rainDropKey),
            rainDropKey,
          );

          _rainDropPositions.add(rainDropPosition);
        }
      });
    });
  }

  List<Widget> _buildRainDrops() {
    return _rainDropPositions.map<Widget>((rainDropPosition) {
      return Positioned(
        left: rainDropPosition.left,
        top: rainDropPosition.top,
        child: rainDropPosition.rainDrop,
      );
    }).toList();
  }

  int _getDropsPerInterval() {
    return widget.weatherCondition == WeatherCondition.rainy
        ? _dropsPerIntervalWhenRainy
        : _dropsPerIntervalWhenThunderstorm;
  }
}

class _RainDropPosition {
  final double left;
  final double top;
  final _RainDrop rainDrop;
  final GlobalKey<_RainDropState> rainDropKey;

  _RainDropPosition(this.left, this.top, this.rainDrop, this.rainDropKey);
}

class _RainDrop extends StatefulWidget {
  const _RainDrop({super.key});

  @override
  _RainDropState createState() => _RainDropState();
}

class _RainDropState extends State<_RainDrop>
    with SingleTickerProviderStateMixin {
  static const rainDropSize = 35.0;

  late AnimationController _controller;

  bool get isCompleted => _controller.status == AnimationStatus.completed;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _CustomPainter(_controller.value),
          size: Size(rainDropSize, rainDropSize),
        );
      },
    );
  }
}

class _CustomPainter extends CustomPainter {
  static const Color _color = Color.fromRGBO(34, 144, 156, 1.0);

  static const double _beginOpacity = 0.60;

  final double t;

  final Paint _paintStroke = Paint()
    ..color = _color.withOpacity(1.0)
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  final Paint _paintFill = Paint()
    ..color = _color.withOpacity(0.10)
    ..style = PaintingStyle.fill;

  _CustomPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    _drawDropFalling(canvas, center);

    _drawDropRipple(canvas, center, size.shortestSide / 2.0, 0.25, 1.0);

    _drawDropRipple(canvas, center, size.shortestSide / 3.0, 0.5, 1.0);
  }

  void _drawDropFalling(Canvas canvas, Offset center) {
    final interval = CurveTween(curve: Interval(0.0, 0.25));
    final radius = Tween(begin: 5.0, end: 0.0).chain(interval);
    canvas.drawCircle(center, radius.transform(t), _paintFill);
  }

  void _drawDropRipple(
    Canvas canvas,
    Offset center,
    double size,
    double intervalBegin,
    double intervalEnd,
  ) {
    final interval = CurveTween(curve: Interval(intervalBegin, intervalEnd));
    final opacity = Tween(begin: _beginOpacity, end: 0.0).chain(interval);
    final radius = Tween(begin: 0.0, end: size).chain(interval);

    _paintStroke.color = _color.withOpacity(opacity.transform(t));
    canvas.drawCircle(center, radius.transform(t), _paintStroke);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return (oldDelegate as _CustomPainter).t != t;
  }
}
