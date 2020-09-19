import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/utils/location_util.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/shared_preference_util.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

class WeatherMainBg extends StatefulWidget {
  @override
  _WeatherMainBgState createState() => _WeatherMainBgState();
}

class _WeatherMainBgState extends State<WeatherMainBg>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  StreamSubscription _subscription;
  List<WeatherType> _weatherTypes;
  double _value = 1;

  Future<void> fetchWeatherTypes() async {
    weatherPrint("天气背景开始获取数据...");
    List<WeatherType> weatherTypes = [];
    List<CityModel> cityModels = await SPUtil.getCityModels();
    Map<String, String> allWeatherData = await SPUtil.getAllWeatherModels();
    if (cityModels != null &&
        cityModels.isNotEmpty &&
        allWeatherData != null &&
        allWeatherData.isNotEmpty) {
      cityModels.forEach((element) {
        String key =
            "${LocationUtil.convertCityFlag(element.cityFlag, element.isLocated)}";
        if (allWeatherData.containsKey(key)) {
          WeatherType weatherType = WeatherType.sunny;
          var modelStr = allWeatherData[key];
          if (modelStr != null && modelStr.isNotEmpty) {
            WeatherModelEntity weatherModelEntity =
                WeatherModelEntity().fromJson(json.decode(modelStr));
            if (weatherModelEntity != null &&
                weatherModelEntity.result != null &&
                weatherModelEntity.result.realtime != null) {
              weatherType = WeatherUtils.convertWeatherType(
                  weatherModelEntity.result.realtime.skycon);
            }
          }
          weatherTypes.add(weatherType);
        }
      });
    }
//    weatherTypes.clear();
//    weatherTypes = [WeatherType.lightSnow, WeatherType.middleSnow, WeatherType.heavySnow];
//    weatherTypes[0] = WeatherType.lightSnow;
//    weatherTypes[1] = WeatherType.middleSnow;
//    weatherTypes[2] = WeatherType.heavySnow;
    if (weatherTypes.isNotEmpty) {
      setState(() {
        _weatherTypes = weatherTypes;
        if (_index >= _weatherTypes.length) {
          _index = _weatherTypes.length - 1;
        }
      });
    }
  }

  @override
  void initState() {
    _subscription = eventBus.on().listen((event) {
      if (event is ChangeMainAppBarIndexEvent) {
        _index = event.index;
        if (_weatherTypes != null &&
            _weatherTypes.isNotEmpty &&
            _index < _weatherTypes.length) {
          var type = _weatherTypes[_index];
        }
        setState(() {});
      } else if (event is MainBgChangeEvent) {
        fetchWeatherTypes();
      }
    });
    fetchWeatherTypes();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    WeatherType weatherType = WeatherType.sunny;
    if (_weatherTypes != null && _weatherTypes.isNotEmpty) {
      weatherType = _weatherTypes[_index];
    }
    return Container(
      child: Stack(
        children: [
          WeatherBg(
            weatherType: weatherType,
            width: width,
            height: height,
          ),
        ],
      ),
    );
  }
}
