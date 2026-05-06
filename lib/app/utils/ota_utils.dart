import 'dart:io';

import 'package:flutter_dynamic_weather/app/utils/toast.dart';
import 'package:flutter_dynamic_weather/net/weather_api.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

class OTAUtils {
  static Future<void> startOTA(
      String url, void Function(OtaEvent event) onData) async {
    try {
      OtaUpdate()
          .execute(
            url,
            destinationFilename: 'SimplicityWeather.apk',
          )
          .listen((OtaEvent event) {
        onData(event);
        if (event.status == OtaStatus.DOWNLOAD_ERROR) {
          ToastUtils.show("下载失败", globalKey.currentContext);
        } else if (event.status == OtaStatus.INTERNAL_ERROR) {
          ToastUtils.show("未知失败", globalKey.currentContext);
        } else if (event.status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR) {
          ToastUtils.show("请打开权限", globalKey.currentContext);
        } else if (event.status == OtaStatus.INSTALLING) {
          ToastUtils.show("正在安装...", globalKey.currentContext);
        }
      });
    } catch (e) {
      // 更新失败静默；用户可以手动重试
    }
  }

  static Future<void> initOTA() async {
    if (!Platform.isAndroid) return;
    final otaData = await WeatherApi().getOTA();
    if (otaData != null && otaData["data"] != null) {
      final String url = otaData["data"]["url"] ?? "";
      final String desc = otaData["data"]["desc"] ?? "";
      const String versionName = "";
      final appCode =
          int.tryParse("${otaData["data"]["appCode"] ?? 0}") ?? 0;
      final packageInfo = await PackageInfo.fromPlatform();
      final number = int.tryParse(packageInfo.buildNumber) ?? 0;
      if (appCode > number && url.isNotEmpty) {
        showOTADialog(url, desc, versionName);
      }
    }
  }
}
