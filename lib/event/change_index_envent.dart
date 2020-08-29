import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_page.dart';

class ChangeMainAppBarIndexEvent {
  final int index;
  final String cityFlag;

  ChangeMainAppBarIndexEvent(this.index, this.cityFlag);
}

class ChangeCityEvent {
  final String cityFlag;

  ChangeCityEvent(this.cityFlag);
}

class UpdateManagerData {

}

class MainBgChangeEvent {}