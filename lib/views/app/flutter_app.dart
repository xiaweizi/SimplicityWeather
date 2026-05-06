import 'dart:ui' as ui;

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/router.dart';
import 'package:flutter_dynamic_weather/app/utils/image_utils.dart';
import 'package:flutter_dynamic_weather/views/common/loading_dialog.dart';
import 'package:flutter_dynamic_weather/views/common/ota_dialog.dart';
import 'package:flutter_dynamic_weather/views/pages/home/home_page.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

EventBus eventBus = EventBus();
GlobalKey globalKey = GlobalKey();
ValueNotifier<double> offsetNotifier = ValueNotifier<double>(0);
Map<WeatherType, ui.Image> weatherImages = {};

void showAppDialog({String loadingMsg = "正在加载中..."}) {
  final ctx = globalKey.currentContext;
  if (ctx == null) return;
  showDialog<LoadingDialog>(
    context: ctx,
    barrierDismissible: false,
    builder: (_) => LoadingDialog(text: loadingMsg),
  );
}

void showOTADialog(String apkUrl, String desc, String versionName) {
  final ctx = globalKey.currentContext;
  if (ctx == null) return;
  showDialog<LoadingDialog>(
    context: ctx,
    barrierDismissible: false,
    builder: (_) => OTADialog(desc, versionName, apkUrl),
  );
}

Future<void> fetchWeatherImages() async {
  for (final element in WeatherType.values) {
    weatherImages[element] =
        await ImageUtils.getImage(WeatherUtils.getWeatherIcon(element));
  }
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    fetchWeatherImages();
    return MaterialApp(
      title: "动态天气",
      debugShowCheckedModeBanner: false,
      onGenerateRoute: WeatherRouter.generateRoute,
      navigatorObservers: [AppAnalysis()],
      color: Colors.blue[600],
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: HomePage(key: globalKey),
      ),
    );
  }
}
