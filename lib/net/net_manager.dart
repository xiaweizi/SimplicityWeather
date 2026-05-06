import 'package:dio/dio.dart';
import 'package:flutter_dynamic_weather/net/code.dart';
import 'package:flutter_dynamic_weather/net/rep_result.dart';
import 'package:flutter_dynamic_weather/net/response_interceptor.dart';

const String weatherBaseUrl =
    "https://api.caiyunapp.com/v2.5/sas9gfwyRX2NVehl/";
const String cityBaseUrl =
    "https://restapi.amap.com/v3/config/district?subdistrict=1&key=请使用自己的key&keywords=";
const String geoBaseUrl =
    "https://restapi.amap.com/v3/geocode/regeo?key=请使用自己的key&location=";
const String otaBaseUrl = "http://xiaweizi.online/config/ota/";
const Duration _kReceiveTimeout = Duration(seconds: 15);
const Duration _kSendTimeout = Duration(seconds: 15);
const Duration _kConnectTimeout = Duration(seconds: 15);

/// http 请求
class NetManager {
  static final NetManager _instance = NetManager._internal();

  late Dio _dio;

  NetManager._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: weatherBaseUrl,
      connectTimeout: _kConnectTimeout,
      receiveTimeout: _kReceiveTimeout,
      sendTimeout: _kSendTimeout,
    ));
    _dio.interceptors.add(LogInterceptor());
    _dio.interceptors.add(ResponseInterceptors());
  }

  static NetManager getInstance() => _instance;

  NetManager baseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    return _instance;
  }

  Future<RepResult> get(
    String url, {
    Map<String, dynamic>? header,
    Map<String, dynamic>? param,
  }) async {
    Response response;
    try {
      response = await _dio.get(url, queryParameters: param);
    } on DioException catch (e) {
      return _resultError(e);
    }
    final data = response.data;
    if (data is RepResult) {
      return data;
    }
    return RepResult(data, true, Code.SUCCESS);
  }

  RepResult _resultError(DioException e) {
    int code = e.response?.statusCode ?? 666;
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      code = Code.NETWORK_TIMEOUT;
    }
    return RepResult(
      Code.errorHandleFunction(code, e.message ?? "", false),
      false,
      code,
    );
  }
}
