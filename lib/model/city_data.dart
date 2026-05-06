class CityData {
  static const cityLevel = "city";
  static const districtLevel = "district";
  String name;
  String center;
  String level;
  bool isLocated;

  CityData(this.name, this.center,
      {this.level = "", this.isLocated = false});

  String get longitude => center.split(",")[0];
  String get latitude => center.split(",")[1];

  @override
  String toString() =>
      'CityData{name:$name, center:$center, level:$level, lng:$longitude, lat:$latitude}';
}
