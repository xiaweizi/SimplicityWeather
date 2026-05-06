import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/router.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';
import 'package:flutter_dynamic_weather/views/pages/home/rain_detail.dart';
import 'package:flutter_dynamic_weather/views/pages/home/real_time_temp.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RealtimeView extends StatelessWidget {
  final WeatherModelEntity entity;
  final CityModel? cityModel;

  const RealtimeView({
    super.key,
    required this.entity,
    this.cityModel,
  });

  String buildSpeakContent() {
    const introduction = "简悦天气为您播报天气,";
    final cityName =
        cityModel?.displayedName != null ? "${cityModel!.displayedName}," : "";
    final weatherType = "今天白天到夜间，${_getWeatherDesc()},";
    final temp = _getTemperatureDesc();
    final chn = entity.result?.realtime?.airQuality?.description?.chn;
    final aqi = chn != null ? "空气质量 $chn" : "";
    return introduction + cityName + weatherType + temp + aqi;
  }

  String _getWeatherDesc() {
    final daily = entity.result?.daily;
    final day = daily?.skycon08h20h;
    final night = daily?.skycon20h32h;
    if (day == null || day.isEmpty || night == null || night.isEmpty) return "";
    final dayDesc = WeatherUtils.convertDesc(day[0].value);
    final nightDesc = WeatherUtils.convertDesc(night[0].value);
    if (dayDesc == nightDesc) return dayDesc;
    return "$dayDesc转$nightDesc";
  }

  String _getTemperatureDesc() {
    final temps = entity.result?.daily?.temperature;
    if (temps == null || temps.isEmpty) return "";
    final dayTemperature = temps[0].max;
    final nightTemperature = temps[0].min;
    return "最高温$dayTemperature摄氏度，最低温$nightTemperature摄氏度,";
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    var realTimeWidgetHeight = mq.size.height -
        DimenConstant.singleDayForecastHeight -
        DimenConstant.aqiChartHeight -
        DimenConstant.dayForecastMarginBottom * 2 -
        kToolbarHeight -
        mq.padding.top;
    realTimeWidgetHeight =
        max(realTimeWidgetHeight, DimenConstant.realtimeMinHeight);
    weatherPrint('realtime height: $realTimeWidgetHeight');

    final realtime = entity.result?.realtime;
    if (realtime == null) {
      return SizedBox(height: realTimeWidgetHeight);
    }

    return SizedBox(
      height: realTimeWidgetHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RealTimeTempView(
            temp: realtime.temperature?.toString(),
            content: buildSpeakContent(),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            width: 220,
            child: Text(
              WeatherUtils.convertDesc(realtime.skycon),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              if (Platform.isAndroid) {
                WeatherRouter.jumpToNativePage(WeatherRouter.minute);
              } else {
                showMaterialModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (_) => BlurRectWidget(
                    color: WeatherUtils.getColor(
                      WeatherUtils.convertWeatherType(realtime.skycon),
                    )[0]
                        .withAlpha(60),
                    child: SizedBox(
                      height: 0.3.sh,
                      child: RainDetailView(
                        location: entity.location,
                        title: "${entity.result?.forecastKeypoint ?? ''}",
                      ),
                    ),
                  ),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    "${entity.result?.forecastKeypoint ?? ''}",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
