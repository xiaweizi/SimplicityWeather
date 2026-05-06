import 'package:flutter/widgets.dart';

typedef WeatherPrint = void Function(String message,
    {int? wrapWidth, String? tag});

const kDebug = true;

WeatherPrint weatherPrint = debugPrintThrottled;

void debugPrintThrottled(String message, {int? wrapWidth, String? tag}) {
  if (kDebug) {
    debugPrint("flutter-weather: $tag: $message", wrapWidth: wrapWidth);
  }
}
