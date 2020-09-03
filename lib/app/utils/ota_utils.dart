import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
import 'package:flutter_dynamic_weather/app/utils/toast.dart';
import 'package:flutter_dynamic_weather/net/weather_api.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info/package_info.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

class OTAUtils {
  static startOTA(String url) async {
    try {
      OtaUpdate()
          .execute(
        url,
        destinationFilename: 'SimplicityWeather.apk',
      )
          .listen(
        (OtaEvent event) {
          print('status: ${event.status}, value: ${event.value}');
          if (event.status == OtaStatus.DOWNLOAD_ERROR) {
            ToastUtils.show("下载失败", globalKey.currentContext);
            UmengAnalyticsPlugin.event(AnalyticsConstant.ota, label: "download_error");
          } else if (event.status == OtaStatus.INTERNAL_ERROR) {
            ToastUtils.show("未知失败", globalKey.currentContext);
            UmengAnalyticsPlugin.event(AnalyticsConstant.ota, label: "internal_error");
          } else if (event.status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR) {
            UmengAnalyticsPlugin.event(AnalyticsConstant.ota, label: "permission_not_granted_error");
            ToastUtils.show("请打开权限", globalKey.currentContext);
          } else if (event.status == OtaStatus.INSTALLING) {
            UmengAnalyticsPlugin.event(AnalyticsConstant.ota, label: "installing");
            ToastUtils.show("正在安装...", globalKey.currentContext);
          }
        },
      );
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }

  static initOTA() async {
    if (!Platform.isAndroid) {
      return;
    }
    var otaData = await WeatherApi().getOTA();
    if (otaData != null && otaData["data"] != null) {
      String url = otaData["data"]["url"];
      int appCode = int.parse(otaData["data"]["appCode"]);
      var packageInfo = await PackageInfo.fromPlatform();
      var number = int.parse(packageInfo.buildNumber);
      if (appCode >= number) {
        UmengAnalyticsPlugin.event(AnalyticsConstant.ota, label: "needOTA");
        showDialog(
            context: globalKey.currentContext,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("检测到新版本更新"),
                content: Text("是否更新"),
                actions: [
                  FlatButton(
                    child: Text("更新"),
                    onPressed: () {
                      UmengAnalyticsPlugin.event(AnalyticsConstant.ota, label: "start");
                      startOTA(url);
                      Navigator.of(globalKey.currentContext).pop();
                      ToastUtils.show("正在后台下载中...", context);
                    },
                  ),
                  FlatButton(
                    child: Text("取消"),
                    onPressed: () {
                      UmengAnalyticsPlugin.event(AnalyticsConstant.ota, label: "cancel");
                      Navigator.of(globalKey.currentContext).pop();
                    },
                  ),
                ],
              );
            });
      }
    }
  }
}
