import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';

weatherModelEntityFromJson(WeatherModelEntity data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['api_version'] != null) {
		data.apiVersion = json['api_version']?.toString();
	}
	if (json['api_status'] != null) {
		data.apiStatus = json['api_status']?.toString();
	}
	if (json['lang'] != null) {
		data.lang = json['lang']?.toString();
	}
	if (json['unit'] != null) {
		data.unit = json['unit']?.toString();
	}
	if (json['tzshift'] != null) {
		data.tzshift = json['tzshift']?.toInt();
	}
	if (json['timezone'] != null) {
		data.timezone = json['timezone']?.toString();
	}
	if (json['server_time'] != null) {
		data.serverTime = json['server_time']?.toInt();
	}
	if (json['location'] != null) {
		data.location = json['location']?.map((v) => v?.toDouble())?.toList()?.cast<double>();
	}
	if (json['result'] != null) {
		data.result = new WeatherModelResult().fromJson(json['result']);
	}
	return data;
}

Map<String, dynamic> weatherModelEntityToJson(WeatherModelEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['api_version'] = entity.apiVersion;
	data['api_status'] = entity.apiStatus;
	data['lang'] = entity.lang;
	data['unit'] = entity.unit;
	data['tzshift'] = entity.tzshift;
	data['timezone'] = entity.timezone;
	data['server_time'] = entity.serverTime;
	data['location'] = entity.location;
	if (entity.result != null) {
		data['result'] = entity.result.toJson();
	}
	return data;
}

weatherModelResultFromJson(WeatherModelResult data, Map<String, dynamic> json) {
	if (json['realtime'] != null) {
		data.realtime = new WeatherModelResultRealtime().fromJson(json['realtime']);
	}
	if (json['minutely'] != null) {
		data.minutely = new WeatherModelResultMinutely().fromJson(json['minutely']);
	}
	if (json['hourly'] != null) {
		data.hourly = new WeatherModelResultHourly().fromJson(json['hourly']);
	}
	if (json['daily'] != null) {
		data.daily = new WeatherModelResultDaily().fromJson(json['daily']);
	}
	if (json['primary'] != null) {
		data.primary = json['primary']?.toInt();
	}
	if (json['forecast_keypoint'] != null) {
		data.forecastKeypoint = json['forecast_keypoint']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultToJson(WeatherModelResult entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.realtime != null) {
		data['realtime'] = entity.realtime.toJson();
	}
	if (entity.minutely != null) {
		data['minutely'] = entity.minutely.toJson();
	}
	if (entity.hourly != null) {
		data['hourly'] = entity.hourly.toJson();
	}
	if (entity.daily != null) {
		data['daily'] = entity.daily.toJson();
	}
	data['primary'] = entity.primary;
	data['forecast_keypoint'] = entity.forecastKeypoint;
	return data;
}

weatherModelResultRealtimeFromJson(WeatherModelResultRealtime data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['temperature'] != null) {
		data.temperature = json['temperature']?.toInt();
	}
	if (json['humidity'] != null) {
		data.humidity = json['humidity']?.toDouble();
	}
	if (json['cloudrate'] != null) {
		data.cloudrate = json['cloudrate']?.toDouble();
	}
	if (json['skycon'] != null) {
		data.skycon = json['skycon']?.toString();
	}
	if (json['visibility'] != null) {
		data.visibility = json['visibility']?.toDouble();
	}
	if (json['dswrf'] != null) {
		data.dswrf = json['dswrf']?.toDouble();
	}
	if (json['wind'] != null) {
		data.wind = new WeatherModelResultRealtimeWind().fromJson(json['wind']);
	}
	if (json['pressure'] != null) {
		data.pressure = json['pressure']?.toDouble();
	}
	if (json['apparent_temperature'] != null) {
		data.apparentTemperature = json['apparent_temperature']?.toDouble();
	}
	if (json['precipitation'] != null) {
		data.precipitation = new WeatherModelResultRealtimePrecipitation().fromJson(json['precipitation']);
	}
	if (json['air_quality'] != null) {
		data.airQuality = new WeatherModelResultRealtimeAirQuality().fromJson(json['air_quality']);
	}
	if (json['life_index'] != null) {
		data.lifeIndex = new WeatherModelResultRealtimeLifeIndex().fromJson(json['life_index']);
	}
	return data;
}

Map<String, dynamic> weatherModelResultRealtimeToJson(WeatherModelResultRealtime entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['temperature'] = entity.temperature;
	data['humidity'] = entity.humidity;
	data['cloudrate'] = entity.cloudrate;
	data['skycon'] = entity.skycon;
	data['visibility'] = entity.visibility;
	data['dswrf'] = entity.dswrf;
	if (entity.wind != null) {
		data['wind'] = entity.wind.toJson();
	}
	data['pressure'] = entity.pressure;
	data['apparent_temperature'] = entity.apparentTemperature;
	if (entity.precipitation != null) {
		data['precipitation'] = entity.precipitation.toJson();
	}
	if (entity.airQuality != null) {
		data['air_quality'] = entity.airQuality.toJson();
	}
	if (entity.lifeIndex != null) {
		data['life_index'] = entity.lifeIndex.toJson();
	}
	return data;
}

weatherModelResultRealtimeWindFromJson(WeatherModelResultRealtimeWind data, Map<String, dynamic> json) {
	if (json['speed'] != null) {
		data.speed = json['speed']?.toDouble();
	}
	if (json['direction'] != null) {
		data.direction = json['direction']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultRealtimeWindToJson(WeatherModelResultRealtimeWind entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['speed'] = entity.speed;
	data['direction'] = entity.direction;
	return data;
}

weatherModelResultRealtimePrecipitationFromJson(WeatherModelResultRealtimePrecipitation data, Map<String, dynamic> json) {
	if (json['local'] != null) {
		data.local = new WeatherModelResultRealtimePrecipitationLocal().fromJson(json['local']);
	}
	if (json['nearest'] != null) {
		data.nearest = new WeatherModelResultRealtimePrecipitationNearest().fromJson(json['nearest']);
	}
	return data;
}

Map<String, dynamic> weatherModelResultRealtimePrecipitationToJson(WeatherModelResultRealtimePrecipitation entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.local != null) {
		data['local'] = entity.local.toJson();
	}
	if (entity.nearest != null) {
		data['nearest'] = entity.nearest.toJson();
	}
	return data;
}

weatherModelResultRealtimePrecipitationLocalFromJson(WeatherModelResultRealtimePrecipitationLocal data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['datasource'] != null) {
		data.datasource = json['datasource']?.toString();
	}
	if (json['intensity'] != null) {
		data.intensity = json['intensity']?.toInt();
	}
	return data;
}

Map<String, dynamic> weatherModelResultRealtimePrecipitationLocalToJson(WeatherModelResultRealtimePrecipitationLocal entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['datasource'] = entity.datasource;
	data['intensity'] = entity.intensity;
	return data;
}

weatherModelResultRealtimePrecipitationNearestFromJson(WeatherModelResultRealtimePrecipitationNearest data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['distance'] != null) {
		data.distance = json['distance']?.toInt();
	}
	if (json['intensity'] != null) {
		data.intensity = json['intensity']?.toInt();
	}
	return data;
}

Map<String, dynamic> weatherModelResultRealtimePrecipitationNearestToJson(WeatherModelResultRealtimePrecipitationNearest entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['distance'] = entity.distance;
	data['intensity'] = entity.intensity;
	return data;
}

weatherModelResultRealtimeAirQualityFromJson(WeatherModelResultRealtimeAirQuality data, Map<String, dynamic> json) {
	if (json['pm25'] != null) {
		data.pm25 = json['pm25']?.toInt();
	}
	if (json['pm10'] != null) {
		data.pm10 = json['pm10']?.toInt();
	}
	if (json['o3'] != null) {
		data.o3 = json['o3']?.toInt();
	}
	if (json['so2'] != null) {
		data.so2 = json['so2']?.toInt();
	}
	if (json['no2'] != null) {
		data.no2 = json['no2']?.toInt();
	}
	if (json['co'] != null) {
		data.co = json['co']?.toInt();
	}
	if (json['aqi'] != null) {
		data.aqi = new WeatherModelResultRealtimeAirQualityAqi().fromJson(json['aqi']);
	}
	if (json['description'] != null) {
		data.description = new WeatherModelResultRealtimeAirQualityDescription().fromJson(json['description']);
	}
	return data;
}

Map<String, dynamic> weatherModelResultRealtimeAirQualityToJson(WeatherModelResultRealtimeAirQuality entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['pm25'] = entity.pm25;
	data['pm10'] = entity.pm10;
	data['o3'] = entity.o3;
	data['so2'] = entity.so2;
	data['no2'] = entity.no2;
	data['co'] = entity.co;
	if (entity.aqi != null) {
		data['aqi'] = entity.aqi.toJson();
	}
	if (entity.description != null) {
		data['description'] = entity.description.toJson();
	}
	return data;
}

weatherModelResultRealtimeAirQualityAqiFromJson(WeatherModelResultRealtimeAirQualityAqi data, Map<String, dynamic> json) {
	if (json['chn'] != null) {
		data.chn = json['chn']?.toInt();
	}
	if (json['usa'] != null) {
		data.usa = json['usa']?.toInt();
	}
	return data;
}

Map<String, dynamic> weatherModelResultRealtimeAirQualityAqiToJson(WeatherModelResultRealtimeAirQualityAqi entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['chn'] = entity.chn;
	data['usa'] = entity.usa;
	return data;
}

weatherModelResultRealtimeAirQualityDescriptionFromJson(WeatherModelResultRealtimeAirQualityDescription data, Map<String, dynamic> json) {
	if (json['usa'] != null) {
		data.usa = json['usa']?.toString();
	}
	if (json['chn'] != null) {
		data.chn = json['chn']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultRealtimeAirQualityDescriptionToJson(WeatherModelResultRealtimeAirQualityDescription entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['usa'] = entity.usa;
	data['chn'] = entity.chn;
	return data;
}

weatherModelResultRealtimeLifeIndexFromJson(WeatherModelResultRealtimeLifeIndex data, Map<String, dynamic> json) {
	if (json['ultraviolet'] != null) {
		data.ultraviolet = new WeatherModelResultRealtimeLifeIndexUltraviolet().fromJson(json['ultraviolet']);
	}
	if (json['comfort'] != null) {
		data.comfort = new WeatherModelResultRealtimeLifeIndexComfort().fromJson(json['comfort']);
	}
	return data;
}

Map<String, dynamic> weatherModelResultRealtimeLifeIndexToJson(WeatherModelResultRealtimeLifeIndex entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.ultraviolet != null) {
		data['ultraviolet'] = entity.ultraviolet.toJson();
	}
	if (entity.comfort != null) {
		data['comfort'] = entity.comfort.toJson();
	}
	return data;
}

weatherModelResultRealtimeLifeIndexUltravioletFromJson(WeatherModelResultRealtimeLifeIndexUltraviolet data, Map<String, dynamic> json) {
	if (json['index'] != null) {
		data.index = json['index']?.toInt();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultRealtimeLifeIndexUltravioletToJson(WeatherModelResultRealtimeLifeIndexUltraviolet entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['index'] = entity.index;
	data['desc'] = entity.desc;
	return data;
}

weatherModelResultRealtimeLifeIndexComfortFromJson(WeatherModelResultRealtimeLifeIndexComfort data, Map<String, dynamic> json) {
	if (json['index'] != null) {
		data.index = json['index']?.toInt();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultRealtimeLifeIndexComfortToJson(WeatherModelResultRealtimeLifeIndexComfort entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['index'] = entity.index;
	data['desc'] = entity.desc;
	return data;
}

weatherModelResultMinutelyFromJson(WeatherModelResultMinutely data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['datasource'] != null) {
		data.datasource = json['datasource']?.toString();
	}
	if (json['precipitation_2h'] != null) {
		data.precipitation2h = json['precipitation_2h']?.map((v) => v?.toInt())?.toList()?.cast<int>();
	}
	if (json['precipitation'] != null) {
		data.precipitation = json['precipitation']?.map((v) => v?.toInt())?.toList()?.cast<int>();
	}
	if (json['probability'] != null) {
		data.probability = json['probability']?.map((v) => v?.toInt())?.toList()?.cast<int>();
	}
	if (json['description'] != null) {
		data.description = json['description']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultMinutelyToJson(WeatherModelResultMinutely entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['datasource'] = entity.datasource;
	data['precipitation_2h'] = entity.precipitation2h;
	data['precipitation'] = entity.precipitation;
	data['probability'] = entity.probability;
	data['description'] = entity.description;
	return data;
}

weatherModelResultHourlyFromJson(WeatherModelResultHourly data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['description'] != null) {
		data.description = json['description']?.toString();
	}
	if (json['precipitation'] != null) {
		data.precipitation = new List<WeatherModelResultHourlyPrecipitation>();
		(json['precipitation'] as List).forEach((v) {
			data.precipitation.add(new WeatherModelResultHourlyPrecipitation().fromJson(v));
		});
	}
	if (json['temperature'] != null) {
		data.temperature = new List<WeatherModelResultHourlyTemperature>();
		(json['temperature'] as List).forEach((v) {
			data.temperature.add(new WeatherModelResultHourlyTemperature().fromJson(v));
		});
	}
	if (json['wind'] != null) {
		data.wind = new List<WeatherModelResultHourlyWind>();
		(json['wind'] as List).forEach((v) {
			data.wind.add(new WeatherModelResultHourlyWind().fromJson(v));
		});
	}
	if (json['humidity'] != null) {
		data.humidity = new List<WeatherModelResultHourlyHumidity>();
		(json['humidity'] as List).forEach((v) {
			data.humidity.add(new WeatherModelResultHourlyHumidity().fromJson(v));
		});
	}
	if (json['cloudrate'] != null) {
		data.cloudrate = new List<WeatherModelResultHourlyCloudrate>();
		(json['cloudrate'] as List).forEach((v) {
			data.cloudrate.add(new WeatherModelResultHourlyCloudrate().fromJson(v));
		});
	}
	if (json['skycon'] != null) {
		data.skycon = new List<WeatherModelResultHourlySkycon>();
		(json['skycon'] as List).forEach((v) {
			data.skycon.add(new WeatherModelResultHourlySkycon().fromJson(v));
		});
	}
	if (json['pressure'] != null) {
		data.pressure = new List<WeatherModelResultHourlyPressure>();
		(json['pressure'] as List).forEach((v) {
			data.pressure.add(new WeatherModelResultHourlyPressure().fromJson(v));
		});
	}
	if (json['visibility'] != null) {
		data.visibility = new List<WeatherModelResultHourlyVisibility>();
		(json['visibility'] as List).forEach((v) {
			data.visibility.add(new WeatherModelResultHourlyVisibility().fromJson(v));
		});
	}
	if (json['dswrf'] != null) {
		data.dswrf = new List<WeatherModelResultHourlyDswrf>();
		(json['dswrf'] as List).forEach((v) {
			data.dswrf.add(new WeatherModelResultHourlyDswrf().fromJson(v));
		});
	}
	if (json['air_quality'] != null) {
		data.airQuality = new WeatherModelResultHourlyAirQuality().fromJson(json['air_quality']);
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlyToJson(WeatherModelResultHourly entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	data['description'] = entity.description;
	if (entity.precipitation != null) {
		data['precipitation'] =  entity.precipitation.map((v) => v.toJson()).toList();
	}
	if (entity.temperature != null) {
		data['temperature'] =  entity.temperature.map((v) => v.toJson()).toList();
	}
	if (entity.wind != null) {
		data['wind'] =  entity.wind.map((v) => v.toJson()).toList();
	}
	if (entity.humidity != null) {
		data['humidity'] =  entity.humidity.map((v) => v.toJson()).toList();
	}
	if (entity.cloudrate != null) {
		data['cloudrate'] =  entity.cloudrate.map((v) => v.toJson()).toList();
	}
	if (entity.skycon != null) {
		data['skycon'] =  entity.skycon.map((v) => v.toJson()).toList();
	}
	if (entity.pressure != null) {
		data['pressure'] =  entity.pressure.map((v) => v.toJson()).toList();
	}
	if (entity.visibility != null) {
		data['visibility'] =  entity.visibility.map((v) => v.toJson()).toList();
	}
	if (entity.dswrf != null) {
		data['dswrf'] =  entity.dswrf.map((v) => v.toJson()).toList();
	}
	if (entity.airQuality != null) {
		data['air_quality'] = entity.airQuality.toJson();
	}
	return data;
}

weatherModelResultHourlyPrecipitationFromJson(WeatherModelResultHourlyPrecipitation data, Map<String, dynamic> json) {
	if (json['datetime'] != null) {
		data.datetime = json['datetime']?.toString();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toInt();
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlyPrecipitationToJson(WeatherModelResultHourlyPrecipitation entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['datetime'] = entity.datetime;
	data['value'] = entity.value;
	return data;
}

weatherModelResultHourlyTemperatureFromJson(WeatherModelResultHourlyTemperature data, Map<String, dynamic> json) {
	if (json['datetime'] != null) {
		data.datetime = json['datetime']?.toString();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toInt();
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlyTemperatureToJson(WeatherModelResultHourlyTemperature entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['datetime'] = entity.datetime;
	data['value'] = entity.value;
	return data;
}

weatherModelResultHourlyWindFromJson(WeatherModelResultHourlyWind data, Map<String, dynamic> json) {
	if (json['datetime'] != null) {
		data.datetime = json['datetime']?.toString();
	}
	if (json['speed'] != null) {
		data.speed = json['speed']?.toDouble();
	}
	if (json['direction'] != null) {
		data.direction = json['direction']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlyWindToJson(WeatherModelResultHourlyWind entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['datetime'] = entity.datetime;
	data['speed'] = entity.speed;
	data['direction'] = entity.direction;
	return data;
}

weatherModelResultHourlyHumidityFromJson(WeatherModelResultHourlyHumidity data, Map<String, dynamic> json) {
	if (json['datetime'] != null) {
		data.datetime = json['datetime']?.toString();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlyHumidityToJson(WeatherModelResultHourlyHumidity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['datetime'] = entity.datetime;
	data['value'] = entity.value;
	return data;
}

weatherModelResultHourlyCloudrateFromJson(WeatherModelResultHourlyCloudrate data, Map<String, dynamic> json) {
	if (json['datetime'] != null) {
		data.datetime = json['datetime']?.toString();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlyCloudrateToJson(WeatherModelResultHourlyCloudrate entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['datetime'] = entity.datetime;
	data['value'] = entity.value;
	return data;
}

weatherModelResultHourlySkyconFromJson(WeatherModelResultHourlySkycon data, Map<String, dynamic> json) {
	if (json['datetime'] != null) {
		data.datetime = json['datetime']?.toString();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlySkyconToJson(WeatherModelResultHourlySkycon entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['datetime'] = entity.datetime;
	data['value'] = entity.value;
	return data;
}

weatherModelResultHourlyPressureFromJson(WeatherModelResultHourlyPressure data, Map<String, dynamic> json) {
	if (json['datetime'] != null) {
		data.datetime = json['datetime']?.toString();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlyPressureToJson(WeatherModelResultHourlyPressure entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['datetime'] = entity.datetime;
	data['value'] = entity.value;
	return data;
}

weatherModelResultHourlyVisibilityFromJson(WeatherModelResultHourlyVisibility data, Map<String, dynamic> json) {
	if (json['datetime'] != null) {
		data.datetime = json['datetime']?.toString();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlyVisibilityToJson(WeatherModelResultHourlyVisibility entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['datetime'] = entity.datetime;
	data['value'] = entity.value;
	return data;
}

weatherModelResultHourlyDswrfFromJson(WeatherModelResultHourlyDswrf data, Map<String, dynamic> json) {
	if (json['datetime'] != null) {
		data.datetime = json['datetime']?.toString();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlyDswrfToJson(WeatherModelResultHourlyDswrf entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['datetime'] = entity.datetime;
	data['value'] = entity.value;
	return data;
}

weatherModelResultHourlyAirQualityFromJson(WeatherModelResultHourlyAirQuality data, Map<String, dynamic> json) {
	if (json['aqi'] != null) {
		data.aqi = new List<WeatherModelResultHourlyAirQualityAqi>();
		(json['aqi'] as List).forEach((v) {
			data.aqi.add(new WeatherModelResultHourlyAirQualityAqi().fromJson(v));
		});
	}
	if (json['pm25'] != null) {
		data.pm25 = new List<WeatherModelResultHourlyAirQualityPm25>();
		(json['pm25'] as List).forEach((v) {
			data.pm25.add(new WeatherModelResultHourlyAirQualityPm25().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlyAirQualityToJson(WeatherModelResultHourlyAirQuality entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.aqi != null) {
		data['aqi'] =  entity.aqi.map((v) => v.toJson()).toList();
	}
	if (entity.pm25 != null) {
		data['pm25'] =  entity.pm25.map((v) => v.toJson()).toList();
	}
	return data;
}

weatherModelResultHourlyAirQualityAqiFromJson(WeatherModelResultHourlyAirQualityAqi data, Map<String, dynamic> json) {
	if (json['datetime'] != null) {
		data.datetime = json['datetime']?.toString();
	}
	if (json['value'] != null) {
		data.value = new WeatherModelResultHourlyAirQualityAqiValue().fromJson(json['value']);
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlyAirQualityAqiToJson(WeatherModelResultHourlyAirQualityAqi entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['datetime'] = entity.datetime;
	if (entity.value != null) {
		data['value'] = entity.value.toJson();
	}
	return data;
}

weatherModelResultHourlyAirQualityAqiValueFromJson(WeatherModelResultHourlyAirQualityAqiValue data, Map<String, dynamic> json) {
	if (json['chn'] != null) {
		data.chn = json['chn']?.toInt();
	}
	if (json['usa'] != null) {
		data.usa = json['usa']?.toInt();
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlyAirQualityAqiValueToJson(WeatherModelResultHourlyAirQualityAqiValue entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['chn'] = entity.chn;
	data['usa'] = entity.usa;
	return data;
}

weatherModelResultHourlyAirQualityPm25FromJson(WeatherModelResultHourlyAirQualityPm25 data, Map<String, dynamic> json) {
	if (json['datetime'] != null) {
		data.datetime = json['datetime']?.toString();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toInt();
	}
	return data;
}

Map<String, dynamic> weatherModelResultHourlyAirQualityPm25ToJson(WeatherModelResultHourlyAirQualityPm25 entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['datetime'] = entity.datetime;
	data['value'] = entity.value;
	return data;
}

weatherModelResultDailyFromJson(WeatherModelResultDaily data, Map<String, dynamic> json) {
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['astro'] != null) {
		data.astro = new List<WeatherModelResultDailyAstro>();
		(json['astro'] as List).forEach((v) {
			data.astro.add(new WeatherModelResultDailyAstro().fromJson(v));
		});
	}
	if (json['precipitation'] != null) {
		data.precipitation = new List<WeatherModelResultDailyPrecipitation>();
		(json['precipitation'] as List).forEach((v) {
			data.precipitation.add(new WeatherModelResultDailyPrecipitation().fromJson(v));
		});
	}
	if (json['temperature'] != null) {
		data.temperature = new List<WeatherModelResultDailyTemperature>();
		(json['temperature'] as List).forEach((v) {
			data.temperature.add(new WeatherModelResultDailyTemperature().fromJson(v));
		});
	}
	if (json['wind'] != null) {
		data.wind = new List<WeatherModelResultDailyWind>();
		(json['wind'] as List).forEach((v) {
			data.wind.add(new WeatherModelResultDailyWind().fromJson(v));
		});
	}
	if (json['humidity'] != null) {
		data.humidity = new List<WeatherModelResultDailyHumidity>();
		(json['humidity'] as List).forEach((v) {
			data.humidity.add(new WeatherModelResultDailyHumidity().fromJson(v));
		});
	}
	if (json['cloudrate'] != null) {
		data.cloudrate = new List<WeatherModelResultDailyCloudrate>();
		(json['cloudrate'] as List).forEach((v) {
			data.cloudrate.add(new WeatherModelResultDailyCloudrate().fromJson(v));
		});
	}
	if (json['pressure'] != null) {
		data.pressure = new List<WeatherModelResultDailyPressure>();
		(json['pressure'] as List).forEach((v) {
			data.pressure.add(new WeatherModelResultDailyPressure().fromJson(v));
		});
	}
	if (json['visibility'] != null) {
		data.visibility = new List<WeatherModelResultDailyVisibility>();
		(json['visibility'] as List).forEach((v) {
			data.visibility.add(new WeatherModelResultDailyVisibility().fromJson(v));
		});
	}
	if (json['dswrf'] != null) {
		data.dswrf = new List<WeatherModelResultDailyDswrf>();
		(json['dswrf'] as List).forEach((v) {
			data.dswrf.add(new WeatherModelResultDailyDswrf().fromJson(v));
		});
	}
	if (json['air_quality'] != null) {
		data.airQuality = new WeatherModelResultDailyAirQuality().fromJson(json['air_quality']);
	}
	if (json['skycon'] != null) {
		data.skycon = new List<WeatherModelResultDailySkycon>();
		(json['skycon'] as List).forEach((v) {
			data.skycon.add(new WeatherModelResultDailySkycon().fromJson(v));
		});
	}
	if (json['skycon_08h_20h'] != null) {
		data.skycon08h20h = new List<WeatherModelResultDailySkycon08h20h>();
		(json['skycon_08h_20h'] as List).forEach((v) {
			data.skycon08h20h.add(new WeatherModelResultDailySkycon08h20h().fromJson(v));
		});
	}
	if (json['skycon_20h_32h'] != null) {
		data.skycon20h32h = new List<WeatherModelResultDailySkycon20h32h>();
		(json['skycon_20h_32h'] as List).forEach((v) {
			data.skycon20h32h.add(new WeatherModelResultDailySkycon20h32h().fromJson(v));
		});
	}
	if (json['life_index'] != null) {
		data.lifeIndex = new WeatherModelResultDailyLifeIndex().fromJson(json['life_index']);
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyToJson(WeatherModelResultDaily entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['status'] = entity.status;
	if (entity.astro != null) {
		data['astro'] =  entity.astro.map((v) => v.toJson()).toList();
	}
	if (entity.precipitation != null) {
		data['precipitation'] =  entity.precipitation.map((v) => v.toJson()).toList();
	}
	if (entity.temperature != null) {
		data['temperature'] =  entity.temperature.map((v) => v.toJson()).toList();
	}
	if (entity.wind != null) {
		data['wind'] =  entity.wind.map((v) => v.toJson()).toList();
	}
	if (entity.humidity != null) {
		data['humidity'] =  entity.humidity.map((v) => v.toJson()).toList();
	}
	if (entity.cloudrate != null) {
		data['cloudrate'] =  entity.cloudrate.map((v) => v.toJson()).toList();
	}
	if (entity.pressure != null) {
		data['pressure'] =  entity.pressure.map((v) => v.toJson()).toList();
	}
	if (entity.visibility != null) {
		data['visibility'] =  entity.visibility.map((v) => v.toJson()).toList();
	}
	if (entity.dswrf != null) {
		data['dswrf'] =  entity.dswrf.map((v) => v.toJson()).toList();
	}
	if (entity.airQuality != null) {
		data['air_quality'] = entity.airQuality.toJson();
	}
	if (entity.skycon != null) {
		data['skycon'] =  entity.skycon.map((v) => v.toJson()).toList();
	}
	if (entity.skycon08h20h != null) {
		data['skycon_08h_20h'] =  entity.skycon08h20h.map((v) => v.toJson()).toList();
	}
	if (entity.skycon20h32h != null) {
		data['skycon_20h_32h'] =  entity.skycon20h32h.map((v) => v.toJson()).toList();
	}
	if (entity.lifeIndex != null) {
		data['life_index'] = entity.lifeIndex.toJson();
	}
	return data;
}

weatherModelResultDailyAstroFromJson(WeatherModelResultDailyAstro data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['sunrise'] != null) {
		data.sunrise = new WeatherModelResultDailyAstroSunrise().fromJson(json['sunrise']);
	}
	if (json['sunset'] != null) {
		data.sunset = new WeatherModelResultDailyAstroSunset().fromJson(json['sunset']);
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyAstroToJson(WeatherModelResultDailyAstro entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	if (entity.sunrise != null) {
		data['sunrise'] = entity.sunrise.toJson();
	}
	if (entity.sunset != null) {
		data['sunset'] = entity.sunset.toJson();
	}
	return data;
}

weatherModelResultDailyAstroSunriseFromJson(WeatherModelResultDailyAstroSunrise data, Map<String, dynamic> json) {
	if (json['time'] != null) {
		data.time = json['time']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyAstroSunriseToJson(WeatherModelResultDailyAstroSunrise entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['time'] = entity.time;
	return data;
}

weatherModelResultDailyAstroSunsetFromJson(WeatherModelResultDailyAstroSunset data, Map<String, dynamic> json) {
	if (json['time'] != null) {
		data.time = json['time']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyAstroSunsetToJson(WeatherModelResultDailyAstroSunset entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['time'] = entity.time;
	return data;
}

weatherModelResultDailyPrecipitationFromJson(WeatherModelResultDailyPrecipitation data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['max'] != null) {
		data.max = json['max']?.toInt();
	}
	if (json['min'] != null) {
		data.min = json['min']?.toInt();
	}
	if (json['avg'] != null) {
		data.avg = json['avg']?.toInt();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyPrecipitationToJson(WeatherModelResultDailyPrecipitation entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['max'] = entity.max;
	data['min'] = entity.min;
	data['avg'] = entity.avg;
	return data;
}

weatherModelResultDailyTemperatureFromJson(WeatherModelResultDailyTemperature data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['max'] != null) {
		data.max = json['max']?.toInt();
	}
	if (json['min'] != null) {
		data.min = json['min']?.toInt();
	}
	if (json['avg'] != null) {
		data.avg = json['avg']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyTemperatureToJson(WeatherModelResultDailyTemperature entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['max'] = entity.max;
	data['min'] = entity.min;
	data['avg'] = entity.avg;
	return data;
}

weatherModelResultDailyWindFromJson(WeatherModelResultDailyWind data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['max'] != null) {
		data.max = new WeatherModelResultDailyWindMax().fromJson(json['max']);
	}
	if (json['min'] != null) {
		data.min = new WeatherModelResultDailyWindMin().fromJson(json['min']);
	}
	if (json['avg'] != null) {
		data.avg = new WeatherModelResultDailyWindAvg().fromJson(json['avg']);
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyWindToJson(WeatherModelResultDailyWind entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	if (entity.max != null) {
		data['max'] = entity.max.toJson();
	}
	if (entity.min != null) {
		data['min'] = entity.min.toJson();
	}
	if (entity.avg != null) {
		data['avg'] = entity.avg.toJson();
	}
	return data;
}

weatherModelResultDailyWindMaxFromJson(WeatherModelResultDailyWindMax data, Map<String, dynamic> json) {
	if (json['speed'] != null) {
		data.speed = json['speed']?.toDouble();
	}
	if (json['direction'] != null) {
		data.direction = json['direction']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyWindMaxToJson(WeatherModelResultDailyWindMax entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['speed'] = entity.speed;
	data['direction'] = entity.direction;
	return data;
}

weatherModelResultDailyWindMinFromJson(WeatherModelResultDailyWindMin data, Map<String, dynamic> json) {
	if (json['speed'] != null) {
		data.speed = json['speed']?.toDouble();
	}
	if (json['direction'] != null) {
		data.direction = json['direction']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyWindMinToJson(WeatherModelResultDailyWindMin entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['speed'] = entity.speed;
	data['direction'] = entity.direction;
	return data;
}

weatherModelResultDailyWindAvgFromJson(WeatherModelResultDailyWindAvg data, Map<String, dynamic> json) {
	if (json['speed'] != null) {
		data.speed = json['speed']?.toDouble();
	}
	if (json['direction'] != null) {
		data.direction = json['direction']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyWindAvgToJson(WeatherModelResultDailyWindAvg entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['speed'] = entity.speed;
	data['direction'] = entity.direction;
	return data;
}

weatherModelResultDailyHumidityFromJson(WeatherModelResultDailyHumidity data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['max'] != null) {
		data.max = json['max']?.toDouble();
	}
	if (json['min'] != null) {
		data.min = json['min']?.toDouble();
	}
	if (json['avg'] != null) {
		data.avg = json['avg']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyHumidityToJson(WeatherModelResultDailyHumidity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['max'] = entity.max;
	data['min'] = entity.min;
	data['avg'] = entity.avg;
	return data;
}

weatherModelResultDailyCloudrateFromJson(WeatherModelResultDailyCloudrate data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['max'] != null) {
		data.max = json['max']?.toDouble();
	}
	if (json['min'] != null) {
		data.min = json['min']?.toDouble();
	}
	if (json['avg'] != null) {
		data.avg = json['avg']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyCloudrateToJson(WeatherModelResultDailyCloudrate entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['max'] = entity.max;
	data['min'] = entity.min;
	data['avg'] = entity.avg;
	return data;
}

weatherModelResultDailyPressureFromJson(WeatherModelResultDailyPressure data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['max'] != null) {
		data.max = json['max']?.toDouble();
	}
	if (json['min'] != null) {
		data.min = json['min']?.toDouble();
	}
	if (json['avg'] != null) {
		data.avg = json['avg']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyPressureToJson(WeatherModelResultDailyPressure entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['max'] = entity.max;
	data['min'] = entity.min;
	data['avg'] = entity.avg;
	return data;
}

weatherModelResultDailyVisibilityFromJson(WeatherModelResultDailyVisibility data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['max'] != null) {
		data.max = json['max']?.toDouble();
	}
	if (json['min'] != null) {
		data.min = json['min']?.toDouble();
	}
	if (json['avg'] != null) {
		data.avg = json['avg']?.toInt();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyVisibilityToJson(WeatherModelResultDailyVisibility entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['max'] = entity.max;
	data['min'] = entity.min;
	data['avg'] = entity.avg;
	return data;
}

weatherModelResultDailyDswrfFromJson(WeatherModelResultDailyDswrf data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['max'] != null) {
		data.max = json['max']?.toDouble();
	}
	if (json['min'] != null) {
		data.min = json['min']?.toInt();
	}
	if (json['avg'] != null) {
		data.avg = json['avg']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyDswrfToJson(WeatherModelResultDailyDswrf entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['max'] = entity.max;
	data['min'] = entity.min;
	data['avg'] = entity.avg;
	return data;
}

weatherModelResultDailyAirQualityFromJson(WeatherModelResultDailyAirQuality data, Map<String, dynamic> json) {
	if (json['aqi'] != null) {
		data.aqi = new List<WeatherModelResultDailyAirQualityAqi>();
		(json['aqi'] as List).forEach((v) {
			data.aqi.add(new WeatherModelResultDailyAirQualityAqi().fromJson(v));
		});
	}
	if (json['pm25'] != null) {
		data.pm25 = new List<WeatherModelResultDailyAirQualityPm25>();
		(json['pm25'] as List).forEach((v) {
			data.pm25.add(new WeatherModelResultDailyAirQualityPm25().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyAirQualityToJson(WeatherModelResultDailyAirQuality entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.aqi != null) {
		data['aqi'] =  entity.aqi.map((v) => v.toJson()).toList();
	}
	if (entity.pm25 != null) {
		data['pm25'] =  entity.pm25.map((v) => v.toJson()).toList();
	}
	return data;
}

weatherModelResultDailyAirQualityAqiFromJson(WeatherModelResultDailyAirQualityAqi data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['max'] != null) {
		data.max = new WeatherModelResultDailyAirQualityAqiMax().fromJson(json['max']);
	}
	if (json['avg'] != null) {
		data.avg = new WeatherModelResultDailyAirQualityAqiAvg().fromJson(json['avg']);
	}
	if (json['min'] != null) {
		data.min = new WeatherModelResultDailyAirQualityAqiMin().fromJson(json['min']);
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyAirQualityAqiToJson(WeatherModelResultDailyAirQualityAqi entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	if (entity.max != null) {
		data['max'] = entity.max.toJson();
	}
	if (entity.avg != null) {
		data['avg'] = entity.avg.toJson();
	}
	if (entity.min != null) {
		data['min'] = entity.min.toJson();
	}
	return data;
}

weatherModelResultDailyAirQualityAqiMaxFromJson(WeatherModelResultDailyAirQualityAqiMax data, Map<String, dynamic> json) {
	if (json['chn'] != null) {
		data.chn = json['chn']?.toInt();
	}
	if (json['usa'] != null) {
		data.usa = json['usa']?.toInt();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyAirQualityAqiMaxToJson(WeatherModelResultDailyAirQualityAqiMax entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['chn'] = entity.chn;
	data['usa'] = entity.usa;
	return data;
}

weatherModelResultDailyAirQualityAqiAvgFromJson(WeatherModelResultDailyAirQualityAqiAvg data, Map<String, dynamic> json) {
	if (json['chn'] != null) {
		data.chn = json['chn']?.toDouble();
	}
	if (json['usa'] != null) {
		data.usa = json['usa']?.toDouble();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyAirQualityAqiAvgToJson(WeatherModelResultDailyAirQualityAqiAvg entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['chn'] = entity.chn;
	data['usa'] = entity.usa;
	return data;
}

weatherModelResultDailyAirQualityAqiMinFromJson(WeatherModelResultDailyAirQualityAqiMin data, Map<String, dynamic> json) {
	if (json['chn'] != null) {
		data.chn = json['chn']?.toInt();
	}
	if (json['usa'] != null) {
		data.usa = json['usa']?.toInt();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyAirQualityAqiMinToJson(WeatherModelResultDailyAirQualityAqiMin entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['chn'] = entity.chn;
	data['usa'] = entity.usa;
	return data;
}

weatherModelResultDailyAirQualityPm25FromJson(WeatherModelResultDailyAirQualityPm25 data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['max'] != null) {
		data.max = json['max']?.toInt();
	}
	if (json['avg'] != null) {
		data.avg = json['avg']?.toDouble();
	}
	if (json['min'] != null) {
		data.min = json['min']?.toInt();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyAirQualityPm25ToJson(WeatherModelResultDailyAirQualityPm25 entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['max'] = entity.max;
	data['avg'] = entity.avg;
	data['min'] = entity.min;
	return data;
}

weatherModelResultDailySkyconFromJson(WeatherModelResultDailySkycon data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailySkyconToJson(WeatherModelResultDailySkycon entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['value'] = entity.value;
	return data;
}

weatherModelResultDailySkycon08h20hFromJson(WeatherModelResultDailySkycon08h20h data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailySkycon08h20hToJson(WeatherModelResultDailySkycon08h20h entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['value'] = entity.value;
	return data;
}

weatherModelResultDailySkycon20h32hFromJson(WeatherModelResultDailySkycon20h32h data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['value'] != null) {
		data.value = json['value']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailySkycon20h32hToJson(WeatherModelResultDailySkycon20h32h entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['value'] = entity.value;
	return data;
}

weatherModelResultDailyLifeIndexFromJson(WeatherModelResultDailyLifeIndex data, Map<String, dynamic> json) {
	if (json['ultraviolet'] != null) {
		data.ultraviolet = new List<WeatherModelResultDailyLifeIndexUltraviolet>();
		(json['ultraviolet'] as List).forEach((v) {
			data.ultraviolet.add(new WeatherModelResultDailyLifeIndexUltraviolet().fromJson(v));
		});
	}
	if (json['carWashing'] != null) {
		data.carWashing = new List<WeatherModelResultDailyLifeIndexCarWashing>();
		(json['carWashing'] as List).forEach((v) {
			data.carWashing.add(new WeatherModelResultDailyLifeIndexCarWashing().fromJson(v));
		});
	}
	if (json['dressing'] != null) {
		data.dressing = new List<WeatherModelResultDailyLifeIndexDressing>();
		(json['dressing'] as List).forEach((v) {
			data.dressing.add(new WeatherModelResultDailyLifeIndexDressing().fromJson(v));
		});
	}
	if (json['comfort'] != null) {
		data.comfort = new List<WeatherModelResultDailyLifeIndexComfort>();
		(json['comfort'] as List).forEach((v) {
			data.comfort.add(new WeatherModelResultDailyLifeIndexComfort().fromJson(v));
		});
	}
	if (json['coldRisk'] != null) {
		data.coldRisk = new List<WeatherModelResultDailyLifeIndexColdRisk>();
		(json['coldRisk'] as List).forEach((v) {
			data.coldRisk.add(new WeatherModelResultDailyLifeIndexColdRisk().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyLifeIndexToJson(WeatherModelResultDailyLifeIndex entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.ultraviolet != null) {
		data['ultraviolet'] =  entity.ultraviolet.map((v) => v.toJson()).toList();
	}
	if (entity.carWashing != null) {
		data['carWashing'] =  entity.carWashing.map((v) => v.toJson()).toList();
	}
	if (entity.dressing != null) {
		data['dressing'] =  entity.dressing.map((v) => v.toJson()).toList();
	}
	if (entity.comfort != null) {
		data['comfort'] =  entity.comfort.map((v) => v.toJson()).toList();
	}
	if (entity.coldRisk != null) {
		data['coldRisk'] =  entity.coldRisk.map((v) => v.toJson()).toList();
	}
	return data;
}

weatherModelResultDailyLifeIndexUltravioletFromJson(WeatherModelResultDailyLifeIndexUltraviolet data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['index'] != null) {
		data.index = json['index']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyLifeIndexUltravioletToJson(WeatherModelResultDailyLifeIndexUltraviolet entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['index'] = entity.index;
	data['desc'] = entity.desc;
	return data;
}

weatherModelResultDailyLifeIndexCarWashingFromJson(WeatherModelResultDailyLifeIndexCarWashing data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['index'] != null) {
		data.index = json['index']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyLifeIndexCarWashingToJson(WeatherModelResultDailyLifeIndexCarWashing entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['index'] = entity.index;
	data['desc'] = entity.desc;
	return data;
}

weatherModelResultDailyLifeIndexDressingFromJson(WeatherModelResultDailyLifeIndexDressing data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['index'] != null) {
		data.index = json['index']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyLifeIndexDressingToJson(WeatherModelResultDailyLifeIndexDressing entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['index'] = entity.index;
	data['desc'] = entity.desc;
	return data;
}

weatherModelResultDailyLifeIndexComfortFromJson(WeatherModelResultDailyLifeIndexComfort data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['index'] != null) {
		data.index = json['index']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyLifeIndexComfortToJson(WeatherModelResultDailyLifeIndexComfort entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['index'] = entity.index;
	data['desc'] = entity.desc;
	return data;
}

weatherModelResultDailyLifeIndexColdRiskFromJson(WeatherModelResultDailyLifeIndexColdRisk data, Map<String, dynamic> json) {
	if (json['date'] != null) {
		data.date = json['date']?.toString();
	}
	if (json['index'] != null) {
		data.index = json['index']?.toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc']?.toString();
	}
	return data;
}

Map<String, dynamic> weatherModelResultDailyLifeIndexColdRiskToJson(WeatherModelResultDailyLifeIndexColdRisk entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['date'] = entity.date;
	data['index'] = entity.index;
	data['desc'] = entity.desc;
	return data;
}