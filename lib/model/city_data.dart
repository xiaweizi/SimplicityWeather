class CityData {
  static const cityLevel = "city";
  static const districtLevel = "district";
  String name;
  String center;
  String level;
  bool isLocated;


  @override
  String toString() {
    return 'CityData{name: $name, center: $center, level: $level, longitude: $longitude, latitude: $latitude}';
  }

  CityData(this.name, this.center, {this.level, this.isLocated});

  get longitude {
    return center.split(",")[0];
  }

  get latitude {
    return center.split(",")[1];
  }
}