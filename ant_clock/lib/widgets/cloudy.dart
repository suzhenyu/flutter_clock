// Copyright 2020 Stuart Delivery Limited. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import 'cloud.dart';

class Cloudy extends StatefulWidget {
  final WeatherCondition weatherCondition;

  final bool isDarkMode;

  const Cloudy({
    super.key,
    required this.weatherCondition,
    required this.isDarkMode,
  });

  @override
  _CloudyState createState() => _CloudyState();
}

class _CloudyState extends State<Cloudy> {
  @override
  Widget build(BuildContext context) {
    if (widget.weatherCondition == WeatherCondition.cloudy &&
        !widget.isDarkMode) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Stack(children: [
            Cloud(assetNumber: 1, constraints: constraints),
            Cloud(assetNumber: 2, constraints: constraints),
            Cloud(assetNumber: 3, constraints: constraints),
            Cloud(assetNumber: 4, constraints: constraints),
          ]);
        },
      );
    } else {
      return Container();
    }
  }
}
