
import 'package:flutter/widgets.dart';

typedef WeatherPrint = void Function(String message, { int wrapWidth, String tag});

WeatherPrint weatherPrint = debugPrintThrottled;

void debugPrintThrottled(String message, { int wrapWidth, String tag}) {
  debugPrint("flutter-weather: $tag: $message", wrapWidth: wrapWidth);
}