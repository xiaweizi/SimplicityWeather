import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPUtil {
  static SharedPreferences _sp;
  static const KEY_CITY_MODELS = "city_models";
  static const KEY_WEATHER_MODELS = "weather_models";

  static Future<SharedPreferences> get sp async {
    _sp = _sp ?? await SharedPreferences.getInstance();
    return _sp;
  }

  static Future<bool> saveCityModels(List<CityModel> cityModels) async {
    weatherPrint("saveCityModels ${cityModels?.length}", tag: "SPUtil");
    var prefs = await sp;
    var encodeStr = json.encode(cityModels);
    weatherPrint('sp -encode: $encodeStr');
    return prefs.setString(KEY_CITY_MODELS, encodeStr);
  }

  static Future<List<CityModel>> getCityModels() async {
    weatherPrint("getCityModels", tag: "SPUtil");
    var prefs = await sp;
    var parseValue = prefs.getString(KEY_CITY_MODELS);
    weatherPrint('sp-get: $parseValue');
    if (parseValue == null || parseValue == "") {
      return null;
    }
    List<dynamic> decodeObject = json.decode(parseValue);
    List<CityModel> model = [];
    decodeObject.forEach((element) {
      model.add(CityModel.fromJson(element));
    });
    return model;
  }

  static Future<bool> saveAllWeatherModels(Map<String, String> allWeatherDat) async {
    weatherPrint("saveAllWeatherModels ${allWeatherDat?.length}", tag: "SPUtil");
    var prefs = await sp;
    var encodeStr = json.encode(allWeatherDat);
    return prefs.setString(KEY_WEATHER_MODELS, encodeStr);
  }

  static Future<Map<String, String>> getAllWeatherModels() async {
    weatherPrint("getAllWeatherModels", tag: "SPUtil");
    var prefs = await sp;
    var parseValue = prefs.getString(KEY_WEATHER_MODELS);
    if (parseValue == null || parseValue == "") {
      return null;
    }
    Map<String, String> model = new Map<String, String>.from(json.decode(parseValue));
    return model;
  }

}