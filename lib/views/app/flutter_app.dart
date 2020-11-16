import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/router.dart';
import 'package:flutter_dynamic_weather/app/utils/image_utils.dart';
import 'package:flutter_dynamic_weather/views/common/loading_dialog.dart';
import 'package:flutter_dynamic_weather/views/common/ota_dialog.dart';
import 'package:flutter_dynamic_weather/views/pages/home/home_page.dart';
import 'dart:ui' as ui;

import 'package:flutter_weather_bg/flutter_weather_bg.dart';

EventBus eventBus = EventBus();
GlobalKey globalKey = GlobalKey();
ValueNotifier<double> offsetNotifier = ValueNotifier<double>(0);
Map<WeatherType, ui.Image> weatherImages = {};

void showAppDialog({String loadingMsg = "正在加载中..."}) {
  showDialog<LoadingDialog>(
      context: globalKey.currentContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new LoadingDialog(
          text: loadingMsg,
        );
      });
}

void showOTADialog(String apkUrl, String desc, String versionName) {
  showDialog<LoadingDialog>(
      context: globalKey.currentContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new OTADialog(desc, versionName, apkUrl);
      });
}

void fetchWeatherImages() async {
  WeatherType.values.forEach((element) async {
    weatherImages[element] = await ImageUtils.getImage(WeatherUtils.getWeatherIcon(element));
  });
}

class FlutterApp extends StatelessWidget {
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
