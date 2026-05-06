import 'package:flutter_dynamic_weather/model/district_model_entity.dart';
import 'package:flutter_dynamic_weather/net/net_manager.dart';

class WeatherApi {
  Future<dynamic> loadWeatherData(String longitude, String latitude) async {
    final res = await NetManager.getInstance()
        .baseUrl(weatherBaseUrl)
        .get("$longitude,$latitude/weather.json");
    if (res.status) return res.data;
    return null;
  }

  Future<dynamic> loadMinuteData(String longitude, String latitude) async {
    final res = await NetManager.getInstance()
        .baseUrl(weatherBaseUrl)
        .get("$longitude,$latitude/minutely.json");
    if (res.status) return res.data;
    return null;
  }

  Future<DistrictModelEntity?> searchCity(String keywords) async {
    final res =
        await NetManager.getInstance().baseUrl(cityBaseUrl).get(keywords);
    if (res.status) return DistrictModelEntity().fromJson(res.data);
    return null;
  }

  Future<dynamic> reGeo(String location) async {
    final res =
        await NetManager.getInstance().baseUrl(geoBaseUrl).get(location);
    if (res.status) return res.data;
    return null;
  }

  Future<dynamic> getOTA() async {
    final res = await NetManager.getInstance().baseUrl(otaBaseUrl).get("");
    if (res.status) return res.data;
    return null;
  }
}
