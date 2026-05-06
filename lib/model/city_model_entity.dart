import 'package:equatable/equatable.dart';
import 'package:flutter_dynamic_weather/app/utils/location_util.dart';

class CityModel extends Equatable {
  double? latitude;
  double? longitude;
  String? country; // 中国
  String? province; // 江苏省
  String? city; // 南京市
  String? district; // 建邺区
  String? poiName;
  String? street;
  String? streetNumber;
  bool? isLocated;
  String? displayedName;

  String get cityFlag {
    return LocationUtil.convertToFlag("$longitude", "$latitude");
  }

  CityModel({
    this.latitude,
    this.longitude,
    this.country,
    this.province,
    this.city,
    this.district,
    this.poiName,
    this.street,
    this.streetNumber,
    this.isLocated,
    this.displayedName,
  });

  @override
  String toString() {
    return 'CityModel{latitude: $latitude, longitude: $longitude, '
        'displayedName: $displayedName, country: $country, province: $province, '
        'city: $city, district: $district, poiName: $poiName, street: $street, '
        'streetNumber: $streetNumber, isLocated: $isLocated}';
  }

  Map<String, dynamic> toJson() {
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
      "displayedName": displayedName,
    };
  }

  CityModel.fromJson(Map<String, dynamic> json) {
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
    country = json['country'] as String?;
    province = json['province'] as String?;
    district = json['district'] as String?;
    poiName = json['poiName'] as String?;
    street = json['street'] as String?;
    streetNumber = json['streetNumber'] as String?;
    isLocated = json['isLocated'] as bool?;
    city = json['city'] as String?;
    displayedName = json['displayedName'] as String?;
  }

  @override
  List<Object?> get props => [latitude, longitude];
}
