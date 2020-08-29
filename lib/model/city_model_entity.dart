import 'package:equatable/equatable.dart';
import 'package:flutter_dynamic_weather/app/utils/location_util.dart';

class CityModel extends Equatable {
  double latitude;
  double longitude;
  String country; // 中国
  String province; // 江苏省
  String city; // 南京市
  String district; // 建邺区
  String poiName; // 南京原力数字艺术培训中心
  String street; //  西城路
  String streetNumber; // 8号
  bool isLocated = false;
  String displayedName;

  String get cityFlag {
    return LocationUtil.convertToFlag("$longitude", "$latitude");
  }

  CityModel(
      {this.latitude,
      this.longitude,
      this.country,
      this.province,
      this.city,
      this.district,
      this.poiName,
      this.street,
      this.streetNumber,
      this.isLocated,
        this.displayedName});

  @override
  String toString() {
    return 'CityModel{latitude: $latitude, longitude: $longitude, displayedName: $displayedName, country: $country, province: $province, city: $city, district: $district, poiName: $poiName, street: $street, streetNumber: $streetNumber, isLocated: $isLocated}';
  }

  Map toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "country": country,
      "province": province,
      "city": city,
      "district": district,
      "poiName": poiName,
      "street": street,
      "streetNumber": streetNumber,
      "isLocated": isLocated,
      "displayedName": displayedName
    };
  }

  CityModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    country = json['country'];
    province = json['province'];
    district = json['district'];
    poiName = json['poiName'];
    street = json['street'];
    streetNumber = json['streetNumber'];
    isLocated = json['isLocated'];
    city = json['city'];
    displayedName = json['displayedName'];
  }

  @override
  List<Object> get props => [latitude, longitude];
}
