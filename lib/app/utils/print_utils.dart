import 'package:flutter/widgets.dart';

typedef WeatherPrint = void Function(String message,
    {int wrapWidth, String tag});

const DEBUG = true;

WeatherPrint weatherPrint = debugPrintThrottled;

void debugPrintThrottled(String message, {int wrapWidth, String tag}) {
  if (DEBUG) {
    debugPrint("flutter-weather: $tag: $message", wrapWidth: wrapWidth);
  }
}
