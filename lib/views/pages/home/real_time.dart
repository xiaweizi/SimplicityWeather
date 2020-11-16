import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/router.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';
import 'package:flutter_dynamic_weather/views/pages/home/rain_detail.dart';
import 'package:flutter_dynamic_weather/views/pages/home/real_time_temp.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RealtimeView extends StatelessWidget {
  final WeatherModelEntity entity;
  final CityModel cityModel;

  const RealtimeView({
    Key key,
    @required this.entity,
    this.cityModel
  }) : super(key: key);

  String buildSpeakContent() {
    String introduction = "简悦天气为您播报天气,";
    String cityName = "";
    if (cityModel != null) {
      cityName = cityModel.displayedName + ",";
    }
    String weatherType = "今天白天到夜间，${_getWeatherDesc()},";
    String temp = _getTemperatureDesc();
    String aqi = "";
    var chn = entity?.result?.realtime?.airQuality?.description?.chn;
    if (chn != null) {
      aqi = "空气质量 $chn";
    }
    return introduction + cityName + weatherType + temp + aqi;
  }

  String _getWeatherDesc() {
    if (entity.result.daily == null ||
        entity.result.daily.skycon08h20h == null ||
        entity.result.daily.skycon08h20h.isEmpty) {
      return "";
    }
    if (entity.result.daily.skycon20h32h == null ||
        entity.result.daily.skycon20h32h.isEmpty) {
      return "";
    }
    var dayDesc =
        WeatherUtils.convertDesc(entity.result.daily.skycon08h20h[0].value);
    var nightDesc =
        WeatherUtils.convertDesc(entity.result.daily.skycon20h32h[0].value);
    if (dayDesc == nightDesc) {
      return "$dayDesc";
    }
    return "$dayDesc转$nightDesc";
  }

  String _getTemperatureDesc() {
    if (entity.result.daily == null ||
        entity.result.daily.temperature == null ||
        entity.result.daily.temperature.isEmpty) {
      return "";
    }
    var dayTemperature = entity.result.daily.temperature[0].max;
    var nightTemperature = entity.result.daily.temperature[0].min;
    return "最高温$dayTemperature摄氏度，最低温$nightTemperature摄氏度,";
  }

  @override
  Widget build(BuildContext context) {
    var realTimeWidgetHeight = MediaQuery.of(context).size.height -
        DimenConstant.singleDayForecastHeight -
        DimenConstant.aqiChartHeight -
        DimenConstant.dayForecastMarginBottom * 2 -
        kToolbarHeight -
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).padding.top;
    realTimeWidgetHeight =
        max(realTimeWidgetHeight, DimenConstant.realtimeMinHeight);
    weatherPrint('realtime height: $realTimeWidgetHeight');
    var child;
    if (entity != null &&
        entity.result != null &&
        entity.result.realtime != null) {
      UmengAnalyticsPlugin.event(AnalyticsConstant.weatherType, label: WeatherUtils.convertDesc(entity.result.realtime.skycon));
      child = Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RealTimeTempView(temp: entity.result.realtime.temperature?.toString(), content: buildSpeakContent(),),
          Container(
            margin: EdgeInsets.only(left: 20),
            width: 220,
            child: Text(
              "${WeatherUtils.convertDesc(entity.result.realtime.skycon)}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: (){
              UmengAnalyticsPlugin.event(AnalyticsConstant.bottomSheet, label: "降雨卡片");
              if (Platform.isAndroid) {
                WeatherRouter.jumpToNativePage(WeatherRouter.minute);
              } else {
                showMaterialModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context, scrollController) =>
                      BlurRectWidget(
                        color: WeatherUtils.getColor(
                            WeatherUtils.convertWeatherType(
                                entity.result.realtime.skycon))[0].withAlpha(
                            60),
                        child: Container(
                          height: 0.3.hp,
                          child: RainDetailView(location: entity.location,
                            title: "${entity.result.forecastKeypoint}",),
                        ),
                      ),
                );
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    "${entity.result.forecastKeypoint}",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      );
    }
    return Container(
      height: realTimeWidgetHeight,
      child: child,
    );
  }
}
