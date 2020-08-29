import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';

class RealtimeView extends StatelessWidget {
  final WeatherModelEntity entity;

  const RealtimeView({
    Key key,
    @required this.entity,
  }) : super(key: key);

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
      child = Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                "${entity.result.realtime.temperature}",
                style: TextStyle(
                    fontSize: 150,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              Text(
                "°",
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            width: 220,
            child: Text(
              "${WeatherUtil.convertDesc(entity.result.realtime.skycon)}",
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
              weatherPrint("展示降雨图");
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
