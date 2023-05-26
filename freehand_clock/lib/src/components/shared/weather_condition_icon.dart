import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Displays an SVG icon for `weatherCondition` at size `size` and color `color`.
class WeatherConditionIcon extends StatelessWidget {
  final WeatherCondition weatherCondition;
  final Color color;
  final double size;

  const WeatherConditionIcon({
    super.key,
    required this.weatherCondition,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        _assetForWeatherCondition(weatherCondition),
        color: color,
      ),
    );
  }
}

String _assetForWeatherCondition(WeatherCondition condition) {
  const path = 'assets/';

  switch (condition) {
    case WeatherCondition.cloudy:
      return '${path}cloudy.svg';
    case WeatherCondition.foggy:
      return '${path}foggy.svg';
    case WeatherCondition.rainy:
      return '${path}rainy.svg';
    case WeatherCondition.snowy:
      return '${path}snowy.svg';
    case WeatherCondition.sunny:
      return '${path}sunny.svg';
    case WeatherCondition.windy:
      return '${path}windy.svg';
    case WeatherCondition.thunderstorm:
      return '${path}stormy.svg';
  }
}
