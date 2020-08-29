import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';

class WeatherColorBg extends StatelessWidget {
  final WeatherType weatherType;
  final double height;

  WeatherColorBg({Key key, this.weatherType, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: WeatherUtil.getColor(weatherType),
        stops: [0, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
    );
  }
}
