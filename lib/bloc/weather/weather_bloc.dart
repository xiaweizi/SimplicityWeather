import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
import 'package:flutter_dynamic_weather/app/utils/location_util.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/shared_preference_util.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/net/weather_api.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApi weatherApi;

  WeatherBloc(this.weatherApi) : super(WeatherLoading(null));

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    weatherPrint('WeatherBloc || mapEventToState event: ${event.runtimeType}');
    if (event is FetchWeatherDataEvent) {
      yield* _mapFetchWeatherToState(event.cityModel);
    }
  }

  Stream<WeatherState> _mapFetchWeatherToState(CityModel cityModel) async* {
    weatherPrint("开始请求 ${cityModel.city} 城市的数据....flag: ${cityModel.cityFlag}");
    yield WeatherLoading(cityModel);
    final resData = await weatherApi.loadWeatherData(
        LocationUtil.parseFlag(cityModel.cityFlag)[0],
        LocationUtil.parseFlag(cityModel.cityFlag)[1]);

    var allWeatherData = await SPUtil.getAllWeatherModels();
    if (allWeatherData == null || allWeatherData.isEmpty) {
      allWeatherData = {};
    }
    if (resData == null) {
      weatherPrint("城市获取失败");
      yield WeatherFailed(cityModel);
    } else {
      var resDataStr = json.encode(resData);
      if (cityModel.isLocated == true && allWeatherData.isNotEmpty) {
        String needRemoveKey = "";
        allWeatherData.forEach((key, value) {
          if (key.contains("true")) {
            needRemoveKey = key;
            return;
          }
        });
        if (needRemoveKey != "") {
          weatherPrint('需要先移除定位城市 key: $needRemoveKey');
          allWeatherData.remove(needRemoveKey);
        }
      }
      // 如果是定位城市，需要先移除定位城市，然后在添加
      allWeatherData[LocationUtil.convertCityFlag(cityModel.cityFlag, cityModel.isLocated)] = resDataStr;
      await SPUtil.saveAllWeatherModels(allWeatherData);

      final weatherData = WeatherModelEntity().fromJson(resData);
      if (weatherData == null) {
        weatherPrint("城市获取失败");
        yield WeatherFailed(cityModel);
      } else {
        weatherPrint("城市获取成功");
        eventBus.fire(MainBgChangeEvent());
        yield WeatherSuccess(weatherData, cityModel);
      }
    }

  }
}
