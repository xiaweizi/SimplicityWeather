import 'package:dio/dio.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/net/code.dart';
import 'package:flutter_dynamic_weather/net/rep_result.dart';

class ResponseInterceptors extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final option = response.requestOptions;
    RepResult? value;
    try {
      final header = response.headers.value(Headers.contentTypeHeader);
      final statusCode = response.statusCode ?? 0;
      if (header != null && header.toString().contains("text")) {
        value = RepResult(response.data, true, Code.SUCCESS);
      } else if (statusCode >= 200 && statusCode < 300) {
        value = RepResult(response.data, true, Code.SUCCESS);
      }
    } catch (e) {
      weatherPrint(e.toString() + option.path);
      value = RepResult(
        response.data,
        false,
        response.statusCode ?? 0,
        msg: e.toString(),
      );
    }
    if (value != null) {
      response.data = value;
    }
    handler.next(response);
  }
}
