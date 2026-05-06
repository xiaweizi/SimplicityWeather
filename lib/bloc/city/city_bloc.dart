import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/utils/location_util.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/shared_preference_util.dart';
import 'package:flutter_dynamic_weather/app/utils/toast.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/net/weather_api.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';

part 'city_event.dart';

part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final WeatherApi weatherApi;

  CityBloc(this.weatherApi) : super(const CityInit()) {
    on<FetchCityDataEvent>(_onFetchCityData);
    on<RequestLocationEvent>(_onRequestLocation);
    on<InsertCityData>(_onInsertCity);
    on<DeleteCityData>(_onDeleteCity);
  }

  Future<void> _onFetchCityData(
      FetchCityDataEvent event, Emitter<CityState> emit) async {
    weatherPrint("开始获取本地城市列表数据====");
    final cityModels = await SPUtil.getCityModels();
    if (cityModels == null || cityModels.isEmpty) {
      weatherPrint('本地列表数据为空');
      emit(const CityInit());
    } else {
      weatherPrint('成功获取到城市列表数据 size: ${cityModels.length}');
      emit(CitySuccess(cityModels));
    }
  }

  Future<void> _onRequestLocation(
      RequestLocationEvent event, Emitter<CityState> emit) async {
    showAppDialog(loadingMsg: "正在定位");
    weatherPrint("开始请求定位...");

    var cityModel = await LocationUtil.fetchCurrentLocation();
    weatherPrint("定位结束: $cityModel");

    if (cityModel == null ||
        (cityModel.latitude ?? 0.0) == 0.0 ||
        (cityModel.longitude ?? 0.0) == 0.0) {
      ToastUtils.show(
        "定位失败，已默认使用北京",
        globalKey.currentContext,
        duration: 5,
      );
      cityModel = _buildDefault();
    } else {
      cityModel.displayedName = WeatherUtils.getCityName(cityModel);
    }

    final cityModels = await _insertCityModel(cityModel);
    weatherPrint('定位成功 location: $cityModel');
    eventBus.fire(MainBgChangeEvent());
    final ctx = globalKey.currentContext;
    if (ctx != null && Navigator.of(ctx).canPop()) {
      Navigator.of(ctx).pop();
    }
    emit(CitySuccess(cityModels));
  }

  Future<void> _onInsertCity(
      InsertCityData event, Emitter<CityState> emit) async {
    weatherPrint("开始添加城市 ${event.cityModel.cityFlag}");
    final cacheModels = await SPUtil.getCityModels();
    bool needInsert = true;
    if (cacheModels != null && cacheModels.isNotEmpty) {
      for (final element in cacheModels) {
        if (event.cityModel.cityFlag == element.cityFlag) {
          needInsert = false;
          break;
        }
      }
    }
    if (!needInsert) {
      weatherPrint("城市已存在，不需要插入");
      return;
    }
    List<CityModel> cityModels = [];
    if ((event.cityModel.latitude ?? 0.0) != 0.0 &&
        (event.cityModel.longitude ?? 0.0) != 0.0) {
      cityModels = await _insertCityModel(event.cityModel);
    }
    eventBus.fire(MainBgChangeEvent());
    emit(CitySuccess(cityModels));
  }

  Future<void> _onDeleteCity(
      DeleteCityData event, Emitter<CityState> emit) async {
    weatherPrint("开始删除城市 ${event.cityFlag}");
    final cacheModels = await SPUtil.getCityModels();
    if (cacheModels == null) return;
    CityModel? needRemoveModel;
    for (final element in cacheModels) {
      if (element.cityFlag == event.cityFlag) {
        needRemoveModel = element;
        break;
      }
    }
    if (needRemoveModel != null) {
      weatherPrint("从 cityModels 删除成功!!");
      cacheModels.remove(needRemoveModel);
      await SPUtil.saveCityModels(cacheModels);
      final allData = await SPUtil.getAllWeatherModels();
      final key = LocationUtil.convertCityFlag(
          needRemoveModel.cityFlag, needRemoveModel.isLocated ?? false);
      if (allData != null && allData.containsKey(key)) {
        allData.remove(key);
        await SPUtil.saveAllWeatherModels(allData);
        weatherPrint("从 AllWeatherModels 删除成功!!");
      }
      eventBus.fire(MainBgChangeEvent());
      emit(CitySuccess(cacheModels));
    }
  }

  CityModel _buildDefault() {
    return CityModel(
      latitude: 39.904989,
      longitude: 116.405285,
      country: "中国",
      province: "北京市",
      district: "东城区",
      displayedName: "北京市",
      isLocated: true,
    );
  }

  Future<List<CityModel>> _insertCityModel(CityModel cityModel) async {
    weatherPrint("开始插入城市数据 $cityModel");
    var cityModels = await SPUtil.getCityModels() ?? <CityModel>[];
    if (cityModels.isNotEmpty && cityModel.isLocated == true) {
      // 定位城市需要先从 CityModels 中移除旧的定位项
      cityModels.removeWhere((e) => e.isLocated == true);
    }
    if (cityModel.isLocated == true) {
      cityModels.insert(0, cityModel);
    } else {
      cityModels.add(cityModel);
    }
    await SPUtil.saveCityModels(cityModels);
    weatherPrint("插入成功后 size: ${cityModels.length}");
    return cityModels;
  }
}
