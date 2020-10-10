import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
import 'package:flutter_dynamic_weather/app/utils/ota_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/views/common/wave_view.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:ota_update/ota_update.dart';


var radius = 20.0;
var width = 250.0;
var height = 350.0;
var weatherType = WeatherType.sunny;

class OTADialog extends Dialog {
  final desc;
  final versionName;
  final apkUrl;

  OTADialog(this.desc, this.versionName, this.apkUrl, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    weatherType =
        WeatherType.values[Random().nextInt(WeatherType.values.length)];
    return new Material(
      type: MaterialType.transparency,
      child: new Center(
        child: new SizedBox(
          width: width,
          height: height,
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius))),
            child: Stack(
              children: [
                WeatherBg(
                  weatherType: weatherType,
                  width: width,
                  height: height,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 1,
                    sigmaY: 1,
                  ),
                  child: Container(
                    width: width,
                    height: height,
                    color: Colors.white.withAlpha(60),
                  ),
                ),
                OTAContentWidget(desc, versionName, apkUrl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OTAContentWidget extends StatefulWidget {

  final desc;
  final versionName;
  final apkUrl;

  OTAContentWidget(this.desc, this.versionName, this.apkUrl, {Key key})
      : super(key: key);

  @override
  _OTAContentWidgetState createState() => _OTAContentWidgetState();
}

class _OTAContentWidgetState extends State<OTAContentWidget> {
  double progress = 0.0;
  OtaStatus otaStatus;

  Widget _buildWaveBg() {
    weatherPrint("_buildWaveBg progress: $progress, status: $otaStatus");
    if (otaStatus == OtaStatus.DOWNLOADING) {
      return WaveProgress(
          Size(width, height), WeatherUtil.getColor(weatherType)[0], progress);
    }
    return Container();
  }

  Widget _buildUpdateButton() {
    String buttonText = "立即更新";
    VoidCallback action = startOta;
    if (otaStatus == OtaStatus.DOWNLOADING) {
      buttonText = "正在下载...";
      action = null;
    } else if (otaStatus == OtaStatus.PERMISSION_NOT_GRANTED_ERROR) {
      buttonText = "请打开权限";
      action = null;
    }
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40, bottom: 25, top: 10),
      width: width,
      child: MaterialButton(
        onPressed: action,
        disabledColor: WeatherUtil.getColor(weatherType)[1].withOpacity(0.5),
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
        color: WeatherUtil.getColor(weatherType)[1],
      ),
    );
  }

  void startOta() async {
    OTAUtils.startOTA(
        widget.apkUrl,
        (event) {
      otaStatus = event.status;
      if (event.status == OtaStatus.DOWNLOADING) {
        progress = int.parse(event.value).toDouble();
      } else if (event.status == OtaStatus.INSTALLING) {
        Navigator.of(context).pop();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: [
          _buildWaveBg(),
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white.withAlpha(188),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, left: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "版本更新",
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        shadows: [
                          Shadow(
                              color: Colors.black.withAlpha(100),
                              offset: Offset(6, 3),
                              blurRadius: 4)
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      widget.versionName,
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        shadows: [
                          Shadow(
                              color: Colors.black.withAlpha(80),
                              offset: Offset(2, 1),
                              blurRadius: 4)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, top: 30),
                child: Text(
                  "更新内容",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(left: 15, top: 15, right: 12),
                    child: Text(
                      widget.desc,
                      style: TextStyle(color: Colors.white, height: 1.8),
                    ),
                  ),
                ),
              ),
              _buildUpdateButton(),
            ],
          ),
        ],
      ),
    );
  }
}
