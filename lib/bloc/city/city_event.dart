part of 'city_bloc.dart';

abstract class CityEvent extends Equatable {
  const CityEvent();
}

class FetchCityDataEvent extends CityEvent {

  @override
  List<Object> get props => [];
}


class RequestLocationEvent extends CityEvent {

  const RequestLocationEvent();

  @override
  List<Object> get props => [];
}

class InsertCityData extends CityEvent {
  final CityModel cityModel;

  const InsertCityData(this.cityModel);

  @override
  List<Object> get props => [cityModel];
}

class DeleteCityData extends CityEvent {
  final String cityFlag;

  const DeleteCityData(this.cityFlag);

  @override
  List<Object> get props => [cityFlag];
}

