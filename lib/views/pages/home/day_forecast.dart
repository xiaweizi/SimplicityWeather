import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/utils/color_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/time_util.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';
import 'package:flutter_dynamic_weather/views/pages/home/day_forecast_detail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

class DayForecastView extends StatelessWidget {
  final WeatherModelResultDaily resultDaily;
  final WeatherModelEntity modelEntity;

  DayForecastView({Key key, @required this.resultDaily, this.modelEntity})
      : super(key: key);

  String _getWeatherDesc(int index) {
    if (resultDaily == null ||
        resultDaily.skycon08h20h == null ||
        resultDaily.skycon08h20h.isEmpty ||
        index >= resultDaily.skycon08h20h.length) {
      return "";
    }
    if (resultDaily.skycon20h32h == null ||
        resultDaily.skycon20h32h.isEmpty ||
        index >= resultDaily.skycon20h32h.length) {
      return "";
    }
    var dayDesc =
        WeatherUtil.convertDesc(resultDaily.skycon08h20h[index].value);
    var nightDesc =
        WeatherUtil.convertDesc(resultDaily.skycon20h32h[index].value);
    if (dayDesc == nightDesc) {
      return "$dayDesc";
    }
    return "$dayDesc转$nightDesc";
  }

  String _getTemperatureDesc(int index) {
    if (resultDaily == null ||
        resultDaily.temperature == null ||
        resultDaily.temperature.isEmpty ||
        index >= resultDaily.temperature.length) {
      return "";
    }
    var dayTemperature = resultDaily.temperature[index].max;
    var nightTemperature = resultDaily.temperature[index].min;
    return "$dayTemperature°/$nightTemperature°";
  }

  String _getWeatherDayDesc(int index) {
    if (resultDaily == null) {
      return "";
    }
    return "${TimeUtil.getWeatherDayDesc(resultDaily.temperature[index].date)}";
  }

  String _getAqiDesc(int index) {
    if (resultDaily == null ||
        resultDaily.airQuality == null ||
        resultDaily.airQuality.aqi == null ||
        resultDaily.airQuality.aqi.isEmpty ||
        index >= resultDaily.airQuality.aqi.length) {
      return "";
    }
    return "${WeatherUtil.getAqiDesc(resultDaily.airQuality.aqi[index].max.chn)}";
  }

  Widget _buildDayItemWidget(BuildContext context, int index) {
    var itemWidth = (1.wp -
            DimenConstant.cardMarginStartEnd * 2 -
            DimenConstant.dayMiddleMargin) /
        2;
    return GestureDetector(
      onTap: () {
        UmengAnalyticsPlugin.event(AnalyticsConstant.bottomSheet, label: "多日");
        showMaterialModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context, scrollController) => BlurRectWidget(
            color: WeatherUtil.getColor(WeatherUtil.convertWeatherType(
                    modelEntity?.result?.realtime?.skycon))[0]
                .withAlpha(60),
            child: Container(
              height: 0.5.hp,
              child: DayForecastDetail(
                resultDaily: modelEntity?.result?.daily,
              ),
            ),
          ),
        );
      },
      child: BlurRectWidget(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13),
          width: itemWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    child: Text(_getWeatherDayDesc(index),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                  ),
                  Expanded(
                    child: Container(
                      child: Text("${_getWeatherDesc(index)}",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1)),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Text("${_getTemperatureDesc(index)}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              letterSpacing: 0.2,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Container(
                    width: 60,
                    child: Text(_getAqiDesc(index),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            child: _buildDayItemWidget(context, 0),
            height: DimenConstant.singleDayForecastHeight,
          ),
          SizedBox(
            width: DimenConstant.dayMiddleMargin,
          ),
          Container(
            child: _buildDayItemWidget(context, 1),
            height: DimenConstant.singleDayForecastHeight,
          )
        ],
      ),
    );
  }
}
