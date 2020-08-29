import 'package:flutter_dynamic_weather/model/district_model_entity.dart';
import 'package:flutter_dynamic_weather/net/net_manager.dart';

class WeatherApi {
  Future<dynamic> loadWeatherData(String longitude, String latitude) async {
    // WeatherModelEntity data = await WeatherApi.loadWeatherData("121.6544","25.1552");
    var res =
        await NetManager.getInstance().baseUrl(weatherBaseUrl).get("$longitude,$latitude/weather.json");
    if (res != null && res.status) {
      return res.data;
    }
    return null;
  }

  Future<DistrictModelEntity> searchCity(String keywords) async {
    // WeatherModelEntity data = await WeatherApi.loadWeatherData("121.6544","25.1552");
    var res = await NetManager.getInstance().baseUrl(cityBaseUrl).get("$keywords");
    if (res != null && res.status) {
      return DistrictModelEntity().fromJson(res.data);
    }
    return null;
  }

  Future<dynamic> reGeo(String location) async {
    // WeatherModelEntity data = await WeatherApi.loadWeatherData("121.6544","25.1552");
    var res = await NetManager.getInstance().baseUrl(geoBaseUrl).get("$location");
    if (res != null && res.status) {
      return res.data;
    }
    return null;
  }
}
