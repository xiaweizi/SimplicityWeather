import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dynamic_weather/app/utils/location_util.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/shared_preference_util.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/net/weather_api.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApi weatherApi;

  WeatherBloc(this.weatherApi) : super(const WeatherLoading(null)) {
    on<FetchWeatherDataEvent>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
      FetchWeatherDataEvent event, Emitter<WeatherState> emit) async {
    final cityModel = event.cityModel;
    weatherPrint(
        "开始请求 ${cityModel.city} 城市的数据....flag: ${cityModel.cityFlag}");
    emit(WeatherLoading(cityModel));

    final resData = await weatherApi.loadWeatherData(
      LocationUtil.parseFlag(cityModel.cityFlag)[0],
      LocationUtil.parseFlag(cityModel.cityFlag)[1],
    );

    var allWeatherData = await SPUtil.getAllWeatherModels();
    allWeatherData ??= <String, String>{};

    if (resData == null) {
      weatherPrint("城市获取失败");
      emit(WeatherFailed(cityModel));
      return;
    }

    final resDataStr = json.encode(resData);
    if (cityModel.isLocated == true && allWeatherData.isNotEmpty) {
      String needRemoveKey = "";
      allWeatherData.forEach((key, value) {
        if (key.contains("true")) needRemoveKey = key;
      });
      if (needRemoveKey != "") {
        weatherPrint('需要先移除定位城市 key: $needRemoveKey');
        allWeatherData.remove(needRemoveKey);
      }
    }
    allWeatherData[LocationUtil.convertCityFlag(
        cityModel.cityFlag, cityModel.isLocated ?? false)] = resDataStr;
    await SPUtil.saveAllWeatherModels(allWeatherData);

    try {
      final weatherData = WeatherModelEntity().fromJson(resData);
      weatherPrint("城市获取成功");
      eventBus.fire(MainBgChangeEvent());
      emit(WeatherSuccess(weatherData, cityModel));
    } catch (e) {
      weatherPrint("解析失败 $e");
      emit(WeatherFailed(cityModel));
    }
  }
}
