part of 'city_bloc.dart';

abstract class CityState extends Equatable {
  const CityState();
}

@immutable
class CitySuccess extends CityState {
  
  final List<CityModel> cityModels;

  CitySuccess(this.cityModels);

  @override
  List<Object> get props => [cityModels];
}


@immutable
class CityInit extends CityState {

  CityInit();

  @override
  List<Object> get props => [];
}

@immutable
class LocationSuccessState extends CityState {

  LocationSuccessState();

  @override
  List<Object> get props => [];
}

