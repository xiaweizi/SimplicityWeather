import 'package:dio/dio.dart';
import 'package:flutter_dynamic_weather/net/code.dart';
import 'package:flutter_dynamic_weather/net/rep_result.dart';
import 'package:flutter_dynamic_weather/net/response_interceptor.dart';
const String weatherBaseUrl = "https://api.caiyunapp.com/v2.5/sas9gfwyRX2NVehl/";
const String cityBaseUrl = "https://restapi.amap.com/v3/config/district?subdistrict=1&key=请使用自己的key&keywords=";
const String geoBaseUrl = "https://restapi.amap.com/v3/geocode/regeo?key=请使用自己的key&location=";
const String otaBaseUrl = "http://xiaweizi.online/config/ota/";
const int _kReceiveTimeout = 15000;
const int _kSendTimeout = 15000;
const int _kConnectTimeout = 15000;

///http请求
class NetManager {

  static NetManager _instance = NetManager._internal();

  Dio _dio;

  ///通用全局单例，第一次使用时初始化
  NetManager._internal({String token}) {
    if (null == _dio) {
      _dio = Dio(BaseOptions(
        baseUrl: weatherBaseUrl,
        connectTimeout: _kReceiveTimeout,
        receiveTimeout: _kConnectTimeout,
        sendTimeout: _kSendTimeout,
      ));
    }
    _dio.interceptors.add(LogInterceptor());
    _dio.interceptors.add(ResponseInterceptors());
  }

  static NetManager getInstance() {
    return _instance;
  }

  baseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    return _instance;
  }

  Future<RepResult> get(String url,
      {Map<String, dynamic> header, Map<String, dynamic> param}) async {
    Response response;
    try {
      response = await _dio.get(url, queryParameters: param);
    } on DioError catch (e) {
      return resultError(e);
    }
    if (response.data is DioError) {
      return resultError(response.data);
    }
    return response.data;
  }

  resultError(DioError e) {
    Response errorResponse;
    if (e.response != null) {
      errorResponse = e.response;
    } else {
      errorResponse = Response(statusCode: 666);
    }
    if (e.type == DioErrorType.CONNECT_TIMEOUT ||
        e.type == DioErrorType.RECEIVE_TIMEOUT) {
      errorResponse.statusCode = Code.NETWORK_TIMEOUT;
    }
    return RepResult(
        Code.errorHandleFunction(errorResponse.statusCode, e.message, false),
        false,
        errorResponse.statusCode);
  }


}