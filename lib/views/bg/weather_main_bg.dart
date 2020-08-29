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
import 'package:flutter_dynamic_weather/views/bg/weather_cloud_bg.dart';
import 'package:flutter_dynamic_weather/views/bg/weather_color_bg.dart';
import 'package:flutter_dynamic_weather/views/bg/weather_rain_snow_bg.dart';

class WeatherMainBg extends StatefulWidget {
  @override
  _WeatherMainBgState createState() => _WeatherMainBgState();
}

class _WeatherMainBgState extends State<WeatherMainBg>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  int _lastIndex = -1;
  StreamSubscription _subscription;
  List<WeatherType> _weatherTypes;
  AnimationController _controller;
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
              weatherType = WeatherUtil.convertWeatherType(
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
      });
    }
  }

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.addListener(() {
      setState(() {
        _value = _controller.value;
      });
    });
    _subscription = eventBus.on().listen((event) {
      if (event is ChangeMainAppBarIndexEvent) {
        weatherPrint("首页背景 view 收到 event ${event.index} lastIndex: $_lastIndex");
        _lastIndex = _index;
        _index = event.index;
        if (_weatherTypes != null &&
            _weatherTypes.isNotEmpty &&
            _lastIndex < _weatherTypes.length &&
            _index < _weatherTypes.length) {
          var lastType = _weatherTypes[_lastIndex];
          var type = _weatherTypes[_index];
          if (lastType != type) {
            weatherPrint("首页背景开始做转场动画");
            _controller.reset();
            _controller.forward();
          }
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
    _controller.dispose();
    super.dispose();
  }

  Widget _buildColorBg() {
    if (_weatherTypes == null ||
        _weatherTypes.isEmpty ||
        _lastIndex >= _weatherTypes.length ||
        _index >= _weatherTypes.length) {
      return Container(
        color: Colors.blue,
      );
    }

    List<Color> colors = [];
    if (_lastIndex != -1) {
      var lastType = _weatherTypes[_lastIndex];
      var type = _weatherTypes[_index];
      List<Color> lastColors = WeatherUtil.getColor(lastType);
      List<Color> currentColors = WeatherUtil.getColor(type);
      colors.add(Color.lerp(lastColors[0], currentColors[0], _value));
      colors.add(Color.lerp(lastColors[1], currentColors[1], _value));
    } else {
      colors.addAll(WeatherUtil.getColor(_weatherTypes[_index]));
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: colors,
        stops: [0, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
    );
  }

  Widget _buildCloudBg() {
    if (_weatherTypes == null ||
        _weatherTypes.isEmpty ||
        _lastIndex >= _weatherTypes.length ||
        _index >= _weatherTypes.length) {
      return Container();
    }

    List<Widget> widgets = [];
    if (_lastIndex != -1) {
      var lastType = _weatherTypes[_lastIndex];
      var type = _weatherTypes[_index];
      widgets.add(Opacity(
        opacity: (1 - _value),
        child: WeatherCloudBg(
          weatherType: lastType,
        ),
      ));
      widgets.add(Opacity(
        opacity: _value,
        child: WeatherCloudBg(
          weatherType: type,
        ),
      ));
    } else {
      widgets.add(Opacity(
        opacity: _value,
        child: WeatherCloudBg(
          weatherType: _weatherTypes[_index],
        ),
      ));
    }
    return Stack(
      children: widgets,
    );
  }

  Widget _buildRainSnowBg() {
    if (_weatherTypes == null ||
        _weatherTypes.isEmpty ||
        _lastIndex >= _weatherTypes.length ||
        _index >= _weatherTypes.length) {
      return Container();
    }
    weatherPrint("开始构建雨雪层");
    List<Widget> widgets = [];
    if (_lastIndex != -1) {
      var lastType = _weatherTypes[_lastIndex];
      var type = _weatherTypes[_index];
      if (WeatherUtil.isSnowRain(lastType)) {
        widgets.add(Opacity(
          opacity: (1 - _value),
          child: WeatherRainSnowBg(
            weatherType: lastType,
          ),
        ));
      }
      if (WeatherUtil.isSnowRain(type)) {
        widgets.add(Opacity(
          opacity: _value,
          child: WeatherRainSnowBg(
            weatherType: type,
          ),
        ));
      }
    } else {
      if (WeatherUtil.isSnowRain(_weatherTypes[_index])) {
        widgets.add(Opacity(
          opacity: _value,
          child: WeatherRainSnowBg(
            weatherType: _weatherTypes[_index],
          ),
        ));
      }
    }
    return Stack(
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          _buildColorBg(),
          _buildCloudBg(),
          _buildRainSnowBg(),
        ],
      ),
    );
  }
}
