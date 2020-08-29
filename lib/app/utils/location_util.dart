class LocationUtil {
  static String convertToFlag(String longitude, String latitude) {
    return "$longitude,$latitude";
  }

  static List<String> parseFlag(String flag) {
    return flag.split(",").toList();
  }

  static String getCityFlag(String key) {
    return key.substring(0, key.lastIndexOf(","));
  }

  static String convertCityFlag(String cityFlag, bool isLocated) {
    return "$cityFlag,$isLocated";
  }
}
