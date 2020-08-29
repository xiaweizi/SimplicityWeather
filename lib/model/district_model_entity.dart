import 'package:flutter_dynamic_weather/generated/json/base/json_convert_content.dart';

class DistrictModelEntity with JsonConvert<DistrictModelEntity> {
  String status;
  String info;
  String count;
  List<DistrictModelDistrict> districts;
}

class DistrictModelDistrict with JsonConvert<DistrictModelDistrict> {
  String adcode;
  String name;
  String center;
  String level;
  List<DistrictModelDistrictsDistrict> districts;
}

class DistrictModelDistrictsDistrict
    with JsonConvert<DistrictModelDistrictsDistrict> {
  String adcode;
  String name;
  String center;
  String level;
  List<dynamic> districts;
}
