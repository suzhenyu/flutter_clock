// Copyright 2020 Stuart Delivery Limited. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:ant_clock/models/position.dart';
import 'package:ant_clock/position_shifter.dart';

class Ant {
  Ant(Position position) : _position = position;

  static const size = 18.0;

  static const halfSize = size / 2;

  Position get position => _position;

  int get frame => _frame;

  bool get isAtDestination => _positionShifter?.isFinished ?? true;

  static const _framesPerSecond = 30.0;

  Position _position;

  int _frame = 0;

  List<Position> _route = [];

  PositionShifter? _positionShifter;

  Duration? _lastFrameElapsed;

  void move(Duration elapsed) {
    if (_positionShifter != null) {
      _positionShifter!.shift(elapsed);
      _position = _positionShifter!.position;

      _lastFrameElapsed ??= elapsed;
      var elapsedSinceLastFrame = (elapsed - _lastFrameElapsed!).inMilliseconds;
      if (elapsedSinceLastFrame >= 1000 / _framesPerSecond) {
        _frame = _frame == 0 ? 1 : 0;
        _lastFrameElapsed = elapsed;
      }

      if (_positionShifter!.isFinished) {
        if (_route.isNotEmpty) {
          _positionShifter = PositionShifter(position, _route.first);
          _route.removeAt(0);
        } else {
          _positionShifter = null;
        }
      }
    }
  }

  void setRoute(List<Position> route) {
    _route = route;
    _positionShifter = PositionShifter(position, _route.first);
    _route.removeAt(0);
  }
}
