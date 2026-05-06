// ignore_for_file: constant_identifier_names
class Code {
  static const NETWORK_ERROR = -1;
  static const NETWORK_TIMEOUT = -2;
  static const NETWORK_JSON_EXCEPTION = -3;
  static const GITHUB_API_REFUSED = -4;
  static const SUCCESS = 200;

  static String errorHandleFunction(int code, String message, bool noTip) {
    if (noTip) return message;
    if (message.contains("Connection refused") ||
        message.contains("Connection reset")) {
      code = GITHUB_API_REFUSED;
    }
    return message;
  }
}
