import 'dart:async';
import 'dart:collection';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
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
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

part 'city_event.dart';

part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final WeatherApi weatherApi;

  CityBloc(this.weatherApi) : super(CityInit());

  @override
  Stream<CityState> mapEventToState(
    CityEvent event,
  ) async* {
    weatherPrint('cityBloc || mapEventToState evet: ${event.runtimeType}');
    if (event is FetchCityDataEvent) {
      yield* mapFetchCityDataEventToState();
    } else if (event is RequestLocationEvent) {
      showAppDialog(loadingMsg: "正在定位");
      weatherPrint("开始请求定位...");
      Location location = await AmapLocation.instance.fetchLocation();
      weatherPrint("定位结束: $location");
      CityModel cityModel = convert(location);
      cityModel.displayedName = WeatherUtil.getCityName(cityModel);
      UmengAnalyticsPlugin.event(AnalyticsConstant.locatedCityName, label: "${cityModel.displayedName}");
      List<CityModel> cityModels = [];
      if (cityModel.latitude == 0.0 || cityModel.longitude == 0.0) {
        ToastUtils.show("高德 API 调用上限, 默认添加北京，请见谅", globalKey.currentContext, duration: 5);
        cityModel = _buildDefault();
      }
      cityModels = await insertCityMode(cityModel);
      weatherPrint('定位成功 location: $cityModel');
      eventBus.fire(MainBgChangeEvent());
      Navigator.of(globalKey.currentContext).pop();
      yield CitySuccess(cityModels);
    } else if (event is InsertCityData) {
      weatherPrint("开始添加城市 ${event.cityModel.cityFlag}");
      List<CityModel> cacheModels = await SPUtil.getCityModels();
      bool needInsert = true;
      if (cacheModels != null && cacheModels.isNotEmpty) {
        cacheModels.forEach((element) {
          if (event.cityModel.cityFlag == element.cityFlag) {
            needInsert = false;
            return;
          }
        });
      }
      if (!needInsert) {
        weatherPrint("城市已存在，不需要插入");
        return;
      }
      List<CityModel> cityModels = [];
      if (event.cityModel.latitude != 0.0 && event.cityModel.longitude != 0.0) {
        cityModels = await insertCityMode(event.cityModel);
      }
      eventBus.fire(MainBgChangeEvent());
      yield CitySuccess(cityModels);
    } else if (event is DeleteCityData) {
      weatherPrint("开始删除城市 ${event.cityFlag}");
      List<CityModel> cacheModels = await SPUtil.getCityModels();
      CityModel needRemoveModel;
      cacheModels.forEach((element) {
        if (element.cityFlag == event.cityFlag) {
          needRemoveModel = element;
        }
      });
      if (needRemoveModel != null) {
        weatherPrint("从 cityModels 删除成功!!");
        cacheModels.remove(needRemoveModel);
        await SPUtil.saveCityModels(cacheModels);
        Map<String, String> allData = await SPUtil.getAllWeatherModels();
        String key = LocationUtil.convertCityFlag(
            needRemoveModel.cityFlag, needRemoveModel.isLocated);
        if (allData != null &&
            allData.containsKey(key)) {
          allData.remove(key);
          await SPUtil.saveAllWeatherModels(allData);
          weatherPrint("从 AllWeatherModels 删除成功!!");
        }
        eventBus.fire(MainBgChangeEvent());
        yield CitySuccess(cacheModels);
      }
    }
  }

  CityModel _buildDefault() {
    CityModel cityModel = CityModel(
      latitude: 39.904989,
      longitude: 116.405285,
      country: "中国",
      province: "北京市",
      district: "东城区",
      displayedName: "北京市",
      isLocated: true,
    );
    return cityModel;
  }

  Future<List<CityModel>> insertCityMode(CityModel cityModel) async {
    weatherPrint("开始插入城市数据 $cityModel");
    List<CityModel> cityModels = await SPUtil.getCityModels();
    if (cityModels == null) {
      cityModels = [];
    }
    if (cityModels.isNotEmpty) {
      CityModel needRemoveModel;
      cityModels.forEach((element) {
        if (cityModel.isLocated == true) {
          needRemoveModel = element;
          return;
        }
      });
      if (needRemoveModel != null) {
        weatherPrint("定位城市需要先从 CityModels 中移除");
        cityModels.remove(needRemoveModel);
      }
    }
    if (cityModel.isLocated == true) {
      cityModels.insert(0, cityModel);
    } else {
      cityModels.add(cityModel);
    }
    await SPUtil.saveCityModels(cityModels);
    weatherPrint("插入成功后 size: ${cityModels?.length}");
    return cityModels;
  }

  CityModel convert(Location location) {
    return CityModel(
        latitude: location.latLng.latitude,
        longitude: location.latLng.longitude,
        country: location.country,
        province: location.province,
        city: location.city,
        district: location.district,
        poiName: location.poiName,
        street: location.street,
        streetNumber: location.streetNumber,
        isLocated: true);
  }

  Stream<CityState> mapFetchCityDataEventToState() async* {
    weatherPrint("开始获取本地城市列表数据====");
    var cityModels = await SPUtil.getCityModels();
    if (cityModels == null || cityModels.isEmpty) {
      // 本地没有城市数据
      weatherPrint('本地列表数据为空');
      yield CityInit();
    } else {
      weatherPrint('成功获取到城市列表数据 size: ${cityModels.length}');
      UmengAnalyticsPlugin.event(AnalyticsConstant.cityTotalCount, label: "${cityModels.length}");
      yield CitySuccess(cityModels);
    }
  }
}
