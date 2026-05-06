import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';
import 'package:flutter_dynamic_weather/views/pages/home/sun_rise_set.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RealTimeDetailView extends StatelessWidget {
  final WeatherModelEntity entity;

  const RealTimeDetailView({super.key, required this.entity});

  Widget _buildSunSetRiseWidget() {
    final astro = entity.result?.daily?.astro;
    if (astro == null || astro.isEmpty) return const SizedBox.shrink();
    return SunSetRiseView(model: astro[0]);
  }

  Widget _buildItem(String title, String desc) {
    final width = (1.sw - DimenConstant.cardMarginStartEnd * 2 - 60) / 2;
    return SizedBox(
      width: width,
      height: width / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Color(0x99ffffff), fontSize: 14)),
          const SizedBox(height: 8),
          Text(desc,
              style: const TextStyle(color: Color(0xffffffff), fontSize: 18)),
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
    final realtime = entity.result?.realtime;
    if (realtime != null) {
      final apparent = realtime.apparentTemperature;
      if (apparent != null) apparentTemp = "${apparent.toInt()}°";
      final h = realtime.humidity;
      if (h != null) humidity = "${(h * 100).toInt()}%";
      final p = realtime.pressure;
      if (p != null) pressure = "${p}hPa";
      final windSpeed = realtime.wind?.speed;
      if (windSpeed != null) wind = "${windSpeed}km/h";
      final pm = realtime.airQuality?.pm25;
      if (pm != null) pm25 = "$pm";
      final uv = realtime.lifeIndex?.ultraviolet?.index;
      if (uv != null) ultraviolet = "$uv";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(children: [_buildItem("体感", apparentTemp), _buildItem("湿度", humidity)]),
          Row(children: [_buildItem("气压", pressure), _buildItem("风速", wind)]),
          Row(children: [_buildItem("PM25", pm25), _buildItem("紫外线", ultraviolet)]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlurRectWidget(
      child: Column(
        children: [
          _buildSunSetRiseWidget(),
          _buildBottomWidget(),
        ],
      ),
    );
  }
}
