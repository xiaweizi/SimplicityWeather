import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/utils/color_utils.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';
import 'package:flutter_dynamic_weather/views/pages/home/sun_rise_set.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RealTimeDetailView extends StatelessWidget {
  final WeatherModelEntity entity;

  const RealTimeDetailView({
    Key key,
    @required this.entity,
  }) : super(key: key);

  Widget _buildSunSetRiseWidget() {
    List<WeatherModelResultDailyAstro> astro = entity?.result?.daily?.astro;
    if (astro == null || astro.isEmpty) {
      return Container();
    }
    return SunSetRiseView(model: entity?.result?.daily?.astro[0]);
  }

  Widget _buildItem(String title, String desc) {
    var width = (1.sw - DimenConstant.cardMarginStartEnd * 2 - 60) / 2;
    return Container(
      width: width,
      height: width / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Color(0x99ffffff), fontSize: 14),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            desc,
            style: TextStyle(color: Color(0xffffffff), fontSize: 18),
          )
        ],
      ),
    );
  }

  Widget _buildBottomWidget() {
    const defaultStr = "--";
    String apparentTemp = defaultStr;
    String humidity = defaultStr;
    String pressure = defaultStr;
    String wind = defaultStr;
    String pm25 = defaultStr;
    String ultraviolet = defaultStr;
    if (entity != null &&
        entity.result != null &&
        entity.result.realtime != null) {
      var realtime = entity.result.realtime;
      if (realtime.apparentTemperature != null) {
        apparentTemp = "${realtime.apparentTemperature.toInt()}°";
      }
      if (realtime.humidity != null) {
        humidity = "${(realtime.humidity * 100).toInt()}%";
      }
      if (realtime.pressure != null) {
        pressure = "${realtime.pressure}hPa";
      }
      if (realtime.wind != null && realtime.wind.speed != null) {
        wind = "${realtime.wind.speed}km/h";
      }
      if (realtime.airQuality != null && realtime.airQuality.pm25 != null) {
        pm25 = "${realtime.airQuality.pm25}";
      }
      if (realtime.lifeIndex != null &&
          realtime.lifeIndex.ultraviolet != null) {
        ultraviolet = "${realtime.lifeIndex.ultraviolet.index}";
      }
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(
            children: [
              _buildItem("体感", apparentTemp),
              _buildItem("湿度", humidity),
            ],
          ),
          Row(
            children: [
              _buildItem("气压", pressure),
              _buildItem("风速", wind),
            ],
          ),
          Row(
            children: [
              _buildItem("PM25", pm25),
              _buildItem("紫外线", ultraviolet),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlurRectWidget(
        child: Column(
          children: [
            _buildSunSetRiseWidget(),
            _buildBottomWidget(),
          ],
        ),
      ),
    );
  }
}
