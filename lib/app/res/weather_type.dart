import 'package:flutter/cupertino.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

enum LifeIndexType { ultraviolet, carWashing, dressing, comfort, coldRisk, typhoon }

class WeatherUtils {
  static final weatherMap = {
    "CLEAR_DAY": "晴",
    "CLEAR_NIGHT": "晴",
    "PARTLY_CLOUDY_DAY": "多云",
    "PARTLY_CLOUDY_NIGHT": "多云",
    "CLOUDY": "阴",
    "LIGHT_HAZE": "霾",
    "MODERATE_HAZE": "霾",
    "HEAVY_HAZE": "霾",
    "LIGHT_RAIN": "小雨",
    "MODERATE_RAIN": "中雨",
    "HEAVY_RAIN": "大雨",
    "STORM_RAIN": "暴雨",
    "FOG": "雾",
    "LIGHT_SNOW": "小雪",
    "MODERATE_SNOW": "中雪",
    "HEAVY_SNOW": "大雪",
    "STORM_SNOW": "暴雪",
    "DUST": "浮尘",
    "SAND": "沙尘",
    "WIND": "大风",
  };

  static final weatherTypeMap = {
    "CLEAR_DAY": WeatherType.sunny,
    "CLEAR_NIGHT": WeatherType.sunnyNight,
    "PARTLY_CLOUDY_DAY": WeatherType.cloudy,
    "PARTLY_CLOUDY_NIGHT": WeatherType.cloudyNight,
    "CLOUDY": WeatherType.overcast,
    "LIGHT_HAZE": WeatherType.hazy,
    "MODERATE_HAZE": WeatherType.hazy,
    "HEAVY_HAZE": WeatherType.hazy,
    "LIGHT_RAIN": WeatherType.lightRainy,
    "MODERATE_RAIN": WeatherType.middleRainy,
    "HEAVY_RAIN": WeatherType.heavyRainy,
    "STORM_RAIN": WeatherType.thunder,
    "FOG": WeatherType.foggy,
    "LIGHT_SNOW": WeatherType.lightSnow,
    "MODERATE_SNOW": WeatherType.middleSnow,
    "HEAVY_SNOW": WeatherType.heavySnow,
    "STORM_SNOW": WeatherType.heavySnow,
    "DUST": WeatherType.dusty,
    "SAND": WeatherType.dusty,
    "WIND": WeatherType.overcast,
  };

  static List<Color> getColor(WeatherType weatherType) {
    switch (weatherType) {
      case WeatherType.sunny:
        return [Color(0xFF0071D1), Color(0xFF6DA6E4)];
      case WeatherType.sunnyNight:
        return [Color(0xFF061E74), Color(0xFF275E9A)];
      case WeatherType.cloudy:
        return [Color(0xFF5C82C1), Color(0xFF95B1DB)];
      case WeatherType.cloudyNight:
        return [Color(0xFF2C3A60), Color(0xFF4B6685)];
      case WeatherType.overcast:
        return [Color(0xFF8FA3C0), Color(0xFF8C9FB1)];
      case WeatherType.lightRainy:
        return [Color(0xFF556782), Color(0xFF7c8b99)];
      case WeatherType.middleRainy:
        return [Color(0xFF3A4B65), Color(0xFF495764)];
      case WeatherType.heavyRainy:
      case WeatherType.thunder:
        return [Color(0xFF3B434E), Color(0xFF565D66)];
      case WeatherType.hazy:
        return [Color(0xFF989898), Color(0xFF4B4B4B)];
      case WeatherType.foggy:
        return [Color(0xFFA6B3C2), Color(0xFF737F88)];
      case WeatherType.lightSnow:
        return [Color(0xFF6989BA), Color(0xFF9DB0CE)];
      case WeatherType.middleSnow:
        return [Color(0xFF8595AD), Color(0xFF95A4BF)];
      case WeatherType.heavySnow:
        return [Color(0xFF98A2BC), Color(0xFFA7ADBF)];
      case WeatherType.dusty:
        return [Color(0xFFB99D79), Color(0xFF6C5635)];
      default:
        return [Color(0xFF0071D1), Color(0xFF6DA6E4)];
    }
  }

  static convertDesc(String skycon) {
    if (weatherMap[skycon] == null || weatherMap[skycon].isEmpty) {
      return "晴";
    }
    return weatherMap[skycon];
  }

  static WeatherType convertWeatherType(String skycon) {
    if (weatherMap[skycon] == null || weatherMap[skycon].isEmpty) {
      return WeatherType.sunny;
    }
    return weatherTypeMap[skycon];
  }

  static String getAqiDesc(int aqi) {
    if (aqi >= 0 && aqi <= 50) {
      return "优";
    }
    if (aqi > 50 && aqi <= 100) {
      return "良";
    }
    if (aqi > 100 && aqi <= 150) {
      return "轻度污染";
    }
    if (aqi > 150 && aqi <= 200) {
      return "中度污染";
    }
    if (aqi > 200 && aqi <= 300) {
      return "重度污染";
    }
    if (aqi > 300) {
      return "严重污染";
    }
    return "";
  }

  static String getCityName(CityModel cityModel) {
    String cityName = "";
    if (cityModel.isLocated == true) {
      cityName = "${cityModel.district}  ${cityModel.street}";
    } else {
      String city = "";
      if (cityModel.city != null && cityModel.city.isNotEmpty) {
        city = "${cityModel.city}";
      }
      String district = "";
      if (cityModel.district != null && cityModel.district.isNotEmpty) {
        district = "${cityModel.district}";
      }
      String province = "";
      if (cityModel.province != null && cityModel.province.isNotEmpty) {
        province = "${cityModel.province}";
      }
      if (city != "") {
        cityName = "$city $district";
      } else {
        cityName = "$province";
      }
    }
    return cityName;
  }

  static String getTemperatureDesc(WeatherModelResultDaily resultDaily) {
    if (resultDaily == null ||
        resultDaily.temperature == null ||
        resultDaily.temperature.isEmpty ||
        resultDaily.temperature.length <= 1) {
      return "";
    }
    var dayTemperature = resultDaily.temperature[1].max;
    var nightTemperature = resultDaily.temperature[1].min;
    return "$dayTemperature°/$nightTemperature°";
  }

  static bool isRainy(WeatherType weatherType) {
    return weatherType == WeatherType.lightRainy ||
        weatherType == WeatherType.middleRainy ||
        weatherType == WeatherType.heavyRainy ||
        weatherType == WeatherType.thunder;
  }

  static bool isSnow(WeatherType weatherType) {
    return weatherType == WeatherType.lightSnow ||
        weatherType == WeatherType.middleSnow ||
        weatherType == WeatherType.heavySnow;
  }

  static bool isSnowRain(WeatherType weatherType) {
    return isRainy(weatherType) || isSnow(weatherType);
  }

  static String getWeatherIcon(WeatherType weatherType) {
    switch (weatherType) {
      case WeatherType.sunny:
        return "assets/images/weather/sunny.png";
      case WeatherType.sunnyNight:
        return "assets/images/weather/sunny_night.png";
      case WeatherType.cloudy:
        return "assets/images/weather/cloudy.png";
      case WeatherType.overcast:
        return "assets/images/weather/overcast.png";
      case WeatherType.lightRainy:
        return "assets/images/weather/small_rain.png";
      case WeatherType.middleRainy:
        return "assets/images/weather/middle_rain.png";
      case WeatherType.heavyRainy:
      case WeatherType.thunder:
        return "assets/images/weather/heavy_rain.png";
      case WeatherType.hazy:
        return "assets/images/weather/foggy.png";
      case WeatherType.foggy:
        return "assets/images/weather/foggy.png";
      case WeatherType.lightSnow:
        return "assets/images/weather/small_snow.png";
      case WeatherType.middleSnow:
        return "assets/images/weather/middle_snow.png";
      case WeatherType.heavySnow:
        return "assets/images/weather/heavy_snow.png";
      case WeatherType.dusty:
        return "assets/images/weather/sandy.png";
      case WeatherType.cloudyNight:
        return "assets/images/weather/cloudy_night.png";
      default:
        return "assets/images/weather/sunnyy.png";
    }
  }

  static String getLifeIndexDesc(LifeIndexType indexType) {
    switch (indexType) {
      case LifeIndexType.dressing:
        return "穿衣指数";
      case LifeIndexType.coldRisk:
        return "感冒指数";
      case LifeIndexType.comfort:
        return "舒适指数";
      case LifeIndexType.carWashing:
        return "洗车指数";
      case LifeIndexType.typhoon:
        return "台风路径";
      default:
        return "紫外线";
    }
  }

  static String getLifeIndexIcon(LifeIndexType lifeIndexType) {
    switch (lifeIndexType) {
      case LifeIndexType.dressing:
        return "assets/images/dressing.png";
      case LifeIndexType.coldRisk:
        return "assets/images/coldRisk.png";
      case LifeIndexType.comfort:
        return "assets/images/comfort.png";
      case LifeIndexType.carWashing:
        return "assets/images/carWashing.png";
      case LifeIndexType.typhoon:
        return "assets/images/typhoon.png";
      default:
        return "assets/images/ultraviolet.png";
    }
  }
}
