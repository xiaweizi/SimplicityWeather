import 'package:flutter_dynamic_weather/generated/json/base/json_convert_content.dart';
import 'package:flutter_dynamic_weather/generated/json/base/json_field.dart';

class WeatherModelEntity with JsonConvert<WeatherModelEntity> {
  String status;
  @JSONField(name: "api_version")
  String apiVersion;
  @JSONField(name: "api_status")
  String apiStatus;
  String lang;
  String unit;
  int tzshift;
  String timezone;
  @JSONField(name: "server_time")
  int serverTime;
  List<double> location;
  WeatherModelResult result;
}

class WeatherModelResult with JsonConvert<WeatherModelResult> {
  WeatherModelResultRealtime realtime;
  WeatherModelResultMinutely minutely;
  WeatherModelResultHourly hourly;
  WeatherModelResultDaily daily;
  int primary;
  @JSONField(name: "forecast_keypoint")
  String forecastKeypoint;
}

class WeatherModelResultRealtime with JsonConvert<WeatherModelResultRealtime> {
  String status;
  int temperature;
  double humidity;
  double cloudrate;
  String skycon;
  double visibility;
  double dswrf;
  WeatherModelResultRealtimeWind wind;
  double pressure;
  @JSONField(name: "apparent_temperature")
  double apparentTemperature;
  WeatherModelResultRealtimePrecipitation precipitation;
  @JSONField(name: "air_quality")
  WeatherModelResultRealtimeAirQuality airQuality;
  @JSONField(name: "life_index")
  WeatherModelResultRealtimeLifeIndex lifeIndex;
}

class WeatherModelResultRealtimeWind
    with JsonConvert<WeatherModelResultRealtimeWind> {
  double speed;
  double direction;
}

class WeatherModelResultRealtimePrecipitation
    with JsonConvert<WeatherModelResultRealtimePrecipitation> {
  WeatherModelResultRealtimePrecipitationLocal local;
  WeatherModelResultRealtimePrecipitationNearest nearest;
}

class WeatherModelResultRealtimePrecipitationLocal
    with JsonConvert<WeatherModelResultRealtimePrecipitationLocal> {
  String status;
  String datasource;
  int intensity;
}

class WeatherModelResultRealtimePrecipitationNearest
    with JsonConvert<WeatherModelResultRealtimePrecipitationNearest> {
  String status;
  int distance;
  int intensity;
}

class WeatherModelResultRealtimeAirQuality
    with JsonConvert<WeatherModelResultRealtimeAirQuality> {
  int pm25;
  int pm10;
  int o3;
  int so2;
  int no2;
  int co;
  WeatherModelResultRealtimeAirQualityAqi aqi;
  WeatherModelResultRealtimeAirQualityDescription description;
}

class WeatherModelResultRealtimeAirQualityAqi
    with JsonConvert<WeatherModelResultRealtimeAirQualityAqi> {
  int chn;
  int usa;
}

class WeatherModelResultRealtimeAirQualityDescription
    with JsonConvert<WeatherModelResultRealtimeAirQualityDescription> {
  String usa;
  String chn;
}

class WeatherModelResultRealtimeLifeIndex
    with JsonConvert<WeatherModelResultRealtimeLifeIndex> {
  WeatherModelResultRealtimeLifeIndexUltraviolet ultraviolet;
  WeatherModelResultRealtimeLifeIndexComfort comfort;
}

class WeatherModelResultRealtimeLifeIndexUltraviolet
    with JsonConvert<WeatherModelResultRealtimeLifeIndexUltraviolet> {
  int index;
  String desc;
}

class WeatherModelResultRealtimeLifeIndexComfort
    with JsonConvert<WeatherModelResultRealtimeLifeIndexComfort> {
  int index;
  String desc;
}

class WeatherModelResultMinutely with JsonConvert<WeatherModelResultMinutely> {
  String status;
  String datasource;
  @JSONField(name: "precipitation_2h")
  List<int> precipitation2h;
  List<int> precipitation;
  List<int> probability;
  String description;
}

class WeatherModelResultHourly with JsonConvert<WeatherModelResultHourly> {
  String status;
  String description;
  List<WeatherModelResultHourlyPrecipitation> precipitation;
  List<WeatherModelResultHourlyTemperature> temperature;
  List<WeatherModelResultHourlyWind> wind;
  List<WeatherModelResultHourlyHumidity> humidity;
  List<WeatherModelResultHourlyCloudrate> cloudrate;
  List<WeatherModelResultHourlySkycon> skycon;
  List<WeatherModelResultHourlyPressure> pressure;
  List<WeatherModelResultHourlyVisibility> visibility;
  List<WeatherModelResultHourlyDswrf> dswrf;
  @JSONField(name: "air_quality")
  WeatherModelResultHourlyAirQuality airQuality;
}

class WeatherModelResultHourlyPrecipitation
    with JsonConvert<WeatherModelResultHourlyPrecipitation> {
  String datetime;
  int value;
}

class WeatherModelResultHourlyTemperature
    with JsonConvert<WeatherModelResultHourlyTemperature> {
  String datetime;
  int value;
}

class WeatherModelResultHourlyWind
    with JsonConvert<WeatherModelResultHourlyWind> {
  String datetime;
  double speed;
  double direction;
}

class WeatherModelResultHourlyHumidity
    with JsonConvert<WeatherModelResultHourlyHumidity> {
  String datetime;
  double value;
}

class WeatherModelResultHourlyCloudrate
    with JsonConvert<WeatherModelResultHourlyCloudrate> {
  String datetime;
  double value;
}

class WeatherModelResultHourlySkycon
    with JsonConvert<WeatherModelResultHourlySkycon> {
  String datetime;
  String value;
}

class WeatherModelResultHourlyPressure
    with JsonConvert<WeatherModelResultHourlyPressure> {
  String datetime;
  double value;
}

class WeatherModelResultHourlyVisibility
    with JsonConvert<WeatherModelResultHourlyVisibility> {
  String datetime;
  double value;
}

class WeatherModelResultHourlyDswrf
    with JsonConvert<WeatherModelResultHourlyDswrf> {
  String datetime;
  double value;
}

class WeatherModelResultHourlyAirQuality
    with JsonConvert<WeatherModelResultHourlyAirQuality> {
  List<WeatherModelResultHourlyAirQualityAqi> aqi;
  List<WeatherModelResultHourlyAirQualityPm25> pm25;
}

class WeatherModelResultHourlyAirQualityAqi
    with JsonConvert<WeatherModelResultHourlyAirQualityAqi> {
  String datetime;
  WeatherModelResultHourlyAirQualityAqiValue value;
}

class WeatherModelResultHourlyAirQualityAqiValue
    with JsonConvert<WeatherModelResultHourlyAirQualityAqiValue> {
  int chn;
  int usa;
}

class WeatherModelResultHourlyAirQualityPm25
    with JsonConvert<WeatherModelResultHourlyAirQualityPm25> {
  String datetime;
  int value;
}

class WeatherModelResultDaily with JsonConvert<WeatherModelResultDaily> {
  String status;
  List<WeatherModelResultDailyAstro> astro;
  List<WeatherModelResultDailyPrecipitation> precipitation;
  List<WeatherModelResultDailyTemperature> temperature;
  List<WeatherModelResultDailyWind> wind;
  List<WeatherModelResultDailyHumidity> humidity;
  List<WeatherModelResultDailyCloudrate> cloudrate;
  List<WeatherModelResultDailyPressure> pressure;
  List<WeatherModelResultDailyVisibility> visibility;
  List<WeatherModelResultDailyDswrf> dswrf;
  @JSONField(name: "air_quality")
  WeatherModelResultDailyAirQuality airQuality;
  List<WeatherModelResultDailySkycon> skycon;
  @JSONField(name: "skycon_08h_20h")
  List<WeatherModelResultDailySkycon08h20h> skycon08h20h;
  @JSONField(name: "skycon_20h_32h")
  List<WeatherModelResultDailySkycon20h32h> skycon20h32h;
  @JSONField(name: "life_index")
  WeatherModelResultDailyLifeIndex lifeIndex;
}

class WeatherModelResultDailyAstro
    with JsonConvert<WeatherModelResultDailyAstro> {
  String date;
  WeatherModelResultDailyAstroSunrise sunrise;
  WeatherModelResultDailyAstroSunset sunset;
}

class WeatherModelResultDailyAstroSunrise
    with JsonConvert<WeatherModelResultDailyAstroSunrise> {
  String time;
}

class WeatherModelResultDailyAstroSunset
    with JsonConvert<WeatherModelResultDailyAstroSunset> {
  String time;
}

class WeatherModelResultDailyPrecipitation
    with JsonConvert<WeatherModelResultDailyPrecipitation> {
  String date;
  int max;
  int min;
  int avg;
}

class WeatherModelResultDailyTemperature
    with JsonConvert<WeatherModelResultDailyTemperature> {
  String date;
  int max;
  int min;
  double avg;
}

class WeatherModelResultDailyWind
    with JsonConvert<WeatherModelResultDailyWind> {
  String date;
  WeatherModelResultDailyWindMax max;
  WeatherModelResultDailyWindMin min;
  WeatherModelResultDailyWindAvg avg;
}

class WeatherModelResultDailyWindMax
    with JsonConvert<WeatherModelResultDailyWindMax> {
  double speed;
  double direction;
}

class WeatherModelResultDailyWindMin
    with JsonConvert<WeatherModelResultDailyWindMin> {
  double speed;
  double direction;
}

class WeatherModelResultDailyWindAvg
    with JsonConvert<WeatherModelResultDailyWindAvg> {
  double speed;
  double direction;
}

class WeatherModelResultDailyHumidity
    with JsonConvert<WeatherModelResultDailyHumidity> {
  String date;
  double max;
  double min;
  double avg;
}

class WeatherModelResultDailyCloudrate
    with JsonConvert<WeatherModelResultDailyCloudrate> {
  String date;
  double max;
  double min;
  double avg;
}

class WeatherModelResultDailyPressure
    with JsonConvert<WeatherModelResultDailyPressure> {
  String date;
  double max;
  double min;
  double avg;
}

class WeatherModelResultDailyVisibility
    with JsonConvert<WeatherModelResultDailyVisibility> {
  String date;
  double max;
  double min;
  int avg;
}

class WeatherModelResultDailyDswrf
    with JsonConvert<WeatherModelResultDailyDswrf> {
  String date;
  double max;
  int min;
  double avg;
}

class WeatherModelResultDailyAirQuality
    with JsonConvert<WeatherModelResultDailyAirQuality> {
  List<WeatherModelResultDailyAirQualityAqi> aqi;
  List<WeatherModelResultDailyAirQualityPm25> pm25;
}

class WeatherModelResultDailyAirQualityAqi
    with JsonConvert<WeatherModelResultDailyAirQualityAqi> {
  String date;
  WeatherModelResultDailyAirQualityAqiMax max;
  WeatherModelResultDailyAirQualityAqiAvg avg;
  WeatherModelResultDailyAirQualityAqiMin min;
}

class WeatherModelResultDailyAirQualityAqiMax
    with JsonConvert<WeatherModelResultDailyAirQualityAqiMax> {
  int chn;
  int usa;
}

class WeatherModelResultDailyAirQualityAqiAvg
    with JsonConvert<WeatherModelResultDailyAirQualityAqiAvg> {
  double chn;
  double usa;
}

class WeatherModelResultDailyAirQualityAqiMin
    with JsonConvert<WeatherModelResultDailyAirQualityAqiMin> {
  int chn;
  int usa;
}

class WeatherModelResultDailyAirQualityPm25
    with JsonConvert<WeatherModelResultDailyAirQualityPm25> {
  String date;
  int max;
  double avg;
  int min;
}

class WeatherModelResultDailySkycon
    with JsonConvert<WeatherModelResultDailySkycon> {
  String date;
  String value;
}

class WeatherModelResultDailySkycon08h20h
    with JsonConvert<WeatherModelResultDailySkycon08h20h> {
  String date;
  String value;
}

class WeatherModelResultDailySkycon20h32h
    with JsonConvert<WeatherModelResultDailySkycon20h32h> {
  String date;
  String value;
}

class WeatherModelResultDailyLifeIndex
    with JsonConvert<WeatherModelResultDailyLifeIndex> {
  List<WeatherModelResultDailyLifeIndexUltraviolet> ultraviolet;
  List<WeatherModelResultDailyLifeIndexCarWashing> carWashing;
  List<WeatherModelResultDailyLifeIndexDressing> dressing;
  List<WeatherModelResultDailyLifeIndexComfort> comfort;
  List<WeatherModelResultDailyLifeIndexColdRisk> coldRisk;
}

class WeatherModelResultDailyLifeIndexUltraviolet
    with JsonConvert<WeatherModelResultDailyLifeIndexUltraviolet> {
  String date;
  String index;
  String desc;
}

class WeatherModelResultDailyLifeIndexCarWashing
    with JsonConvert<WeatherModelResultDailyLifeIndexCarWashing> {
  String date;
  String index;
  String desc;
}

class WeatherModelResultDailyLifeIndexDressing
    with JsonConvert<WeatherModelResultDailyLifeIndexDressing> {
  String date;
  String index;
  String desc;
}

class WeatherModelResultDailyLifeIndexComfort
    with JsonConvert<WeatherModelResultDailyLifeIndexComfort> {
  String date;
  String index;
  String desc;
}

class WeatherModelResultDailyLifeIndexColdRisk
    with JsonConvert<WeatherModelResultDailyLifeIndexColdRisk> {
  String date;
  String index;
  String desc;
}
