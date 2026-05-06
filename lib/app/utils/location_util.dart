import 'package:geolocator/geolocator.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';

class LocationUtil {
  static String convertToFlag(String longitude, String latitude) {
    return "$longitude,$latitude";
  }

  static List<String> parseFlag(String flag) {
    return flag.split(",").toList();
  }

  static String getCityFlag(String key) {
    return key.substring(0, key.lastIndexOf(","));
  }

  static String convertCityFlag(String cityFlag, bool isLocated) {
    return "$cityFlag,$isLocated";
  }

  /// 使用 geolocator 拉一次 GPS 定位，失败返回 null。
  ///
  /// 不做逆地理编码（城市/区/街道字段留空），
  /// 上层可根据经纬度再去调接口补。
  static Future<CityModel?> fetchCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return CityModel(
        latitude: pos.latitude,
        longitude: pos.longitude,
        country: "",
        province: "",
        city: "",
        district: "当前位置",
        poiName: "",
        street: "",
        streetNumber: "",
        isLocated: true,
        displayedName: "当前位置",
      );
    } catch (e) {
      return null;
    }
  }
}
