part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class FetchWeatherDataEvent extends WeatherEvent {

  final CityModel cityModel;

  const FetchWeatherDataEvent(this.cityModel);

  @override
  List<Object> get props => [cityModel];
}
