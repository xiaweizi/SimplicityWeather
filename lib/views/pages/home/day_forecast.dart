import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/utils/time_util.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';
import 'package:flutter_dynamic_weather/views/pages/home/day_forecast_detail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DayForecastView extends StatelessWidget {
  final WeatherModelResultDaily? resultDaily;
  final WeatherModelEntity? modelEntity;

  const DayForecastView(
      {super.key, required this.resultDaily, this.modelEntity});

  String _getWeatherDesc(int index) {
    final day = resultDaily?.skycon08h20h;
    final night = resultDaily?.skycon20h32h;
    if (day == null ||
        night == null ||
        day.isEmpty ||
        night.isEmpty ||
        index >= day.length ||
        index >= night.length) {
      return "";
    }
    final dayDesc = WeatherUtils.convertDesc(day[index].value);
    final nightDesc = WeatherUtils.convertDesc(night[index].value);
    return dayDesc == nightDesc ? dayDesc : "$dayDesc转$nightDesc";
  }

  String _getTemperatureDesc(int index) {
    final temps = resultDaily?.temperature;
    if (temps == null || temps.isEmpty || index >= temps.length) return "";
    return "${temps[index].max}°/${temps[index].min}°";
  }

  String _getWeatherDayDesc(int index) {
    final temps = resultDaily?.temperature;
    if (temps == null || temps.isEmpty || index >= temps.length) return "";
    return TimeUtil.getWeatherDayDesc(temps[index].date);
  }

  String _getAqiDesc(int index) {
    final aqi = resultDaily?.airQuality?.aqi;
    if (aqi == null || aqi.isEmpty || index >= aqi.length) return "";
    final max = aqi[index].max?.chn;
    if (max == null) return "";
    return WeatherUtils.getAqiDesc(max);
  }

  Widget _buildDayItemWidget(BuildContext context, int index) {
    final itemWidth = (1.sw -
            DimenConstant.cardMarginStartEnd * 2 -
            DimenConstant.dayMiddleMargin) /
        2;
    return GestureDetector(
      onTap: () {
        showMaterialModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          backgroundColor: Colors.transparent,
          context: context,
          builder: (ctx) => BlurRectWidget(
            color: WeatherUtils.getColor(WeatherUtils.convertWeatherType(
                    modelEntity?.result?.realtime?.skycon))[0]
                .withAlpha(60),
            child: SizedBox(
              height: 0.5.sh,
              child: DayForecastDetail(
                resultDaily: modelEntity?.result?.daily,
              ),
            ),
          ),
        );
      },
      child: BlurRectWidget(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          width: itemWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Text(
                      _getWeatherDayDesc(index),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _getWeatherDesc(index),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _getTemperatureDesc(index),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      _getAqiDesc(index),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800),
                    ),
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
    return Row(
      children: [
        SizedBox(
          height: DimenConstant.singleDayForecastHeight,
          child: _buildDayItemWidget(context, 0),
        ),
        const SizedBox(width: DimenConstant.dayMiddleMargin),
        SizedBox(
          height: DimenConstant.singleDayForecastHeight,
          child: _buildDayItemWidget(context, 1),
        ),
      ],
    );
  }
}
