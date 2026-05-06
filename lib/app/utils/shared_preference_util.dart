import 'dart:convert';

import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPUtil {
  static SharedPreferences? _sp;
  static const KEY_CITY_MODELS = "city_models";
  static const KEY_WEATHER_MODELS = "weather_models";

  static Future<SharedPreferences> get sp async {
    _sp ??= await SharedPreferences.getInstance();
    return _sp!;
  }

  static Future<bool> saveCityModels(List<CityModel> cityModels) async {
    weatherPrint("saveCityModels ${cityModels.length}", tag: "SPUtil");
    final prefs = await sp;
    final encodeStr = json.encode(cityModels);
    weatherPrint('sp -encode: $encodeStr');
    return prefs.setString(KEY_CITY_MODELS, encodeStr);
  }

  static Future<List<CityModel>?> getCityModels() async {
    weatherPrint("getCityModels", tag: "SPUtil");
    final prefs = await sp;
    final parseValue = prefs.getString(KEY_CITY_MODELS);
    weatherPrint('sp-get: $parseValue');
    if (parseValue == null || parseValue.isEmpty) return null;
    final decoded = json.decode(parseValue) as List<dynamic>;
    return decoded.map((e) => CityModel.fromJson(e)).toList();
  }

  static Future<bool> saveAllWeatherModels(
      Map<String, String> allWeatherDat) async {
    weatherPrint("saveAllWeatherModels ${allWeatherDat.length}",
        tag: "SPUtil");
    final prefs = await sp;
    final encodeStr = json.encode(allWeatherDat);
    return prefs.setString(KEY_WEATHER_MODELS, encodeStr);
  }

  static Future<Map<String, String>?> getAllWeatherModels() async {
    weatherPrint("getAllWeatherModels", tag: "SPUtil");
    final prefs = await sp;
    final parseValue = prefs.getString(KEY_WEATHER_MODELS);
    if (parseValue == null || parseValue.isEmpty) return null;
    return Map<String, String>.from(json.decode(parseValue));
  }
}
