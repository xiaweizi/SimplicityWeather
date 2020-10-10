import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
import 'package:flutter_dynamic_weather/app/utils/toast.dart';
import 'package:flutter_dynamic_weather/net/weather_api.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info/package_info.dart';


class OTAUtils {
  static startOTA(String url, void onData(OtaEvent event)) async {
    try {
      OtaUpdate()
          .execute(
        url,
        destinationFilename: 'SimplicityWeather.apk',
      )
          .listen(
        (OtaEvent event) {
          onData(event);
          print('status: ${event.status}, value: ${event.value}');
          if (event.status == OtaStatus.DOWNLOAD_ERROR) {
            ToastUtils.show("下载失败", globalKey.currentContext);
          } else if (event.status == OtaStatus.INTERNAL_ERROR) {
            ToastUtils.show("未知失败", globalKey.currentContext);
          } else if (event.status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR) {
            ToastUtils.show("请打开权限", globalKey.currentContext);
          } else if (event.status == OtaStatus.INSTALLING) {
            ToastUtils.show("正在安装...", globalKey.currentContext);
          }
        },
      );
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }
}
