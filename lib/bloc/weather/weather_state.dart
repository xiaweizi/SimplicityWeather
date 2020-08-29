part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
}

class WeatherLoading extends WeatherState {
  final CityModel cityModel;

  const WeatherLoading(this.cityModel);

  @override
  List<Object> get props => [cityModel];
}

class WeatherFailed extends WeatherState{
  final CityModel cityModel;

  const WeatherFailed(this.cityModel);

  @override
  List<Object> get props => [cityModel];
}

class WeatherSuccess extends WeatherState{

  final WeatherModelEntity entity;
  final CityModel cityModel;

  const WeatherSuccess(this.entity, this.cityModel);

  @override
  List<Object> get props => [entity, cityModel];
}