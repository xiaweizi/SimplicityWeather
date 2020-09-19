import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/utils/color_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/ui_utils.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/app/res/common_extension.dart';
import 'dart:ui' as ui;

import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

class HourForecastView extends StatelessWidget {
  final WeatherModelResultHourly resultHourly;
  List<HourData> _hourData = [];

  HourForecastView({Key key, @required this.resultHourly}) : super(key: key) {
    if (resultHourly != null &&
        resultHourly.temperature != null &&
        resultHourly.temperature.isNotEmpty) {
      resultHourly.temperature.forEach((element) {
        int index = resultHourly.temperature.indexOf(element);
        DateTime targetTime = element.datetime.dateTime;

        String showTime =
            "${targetTime.hour.gapTime}:${targetTime.minute.gapTime}";
        int temperature = element.value;
        WeatherType weatherType = WeatherType.sunny;
        double windDirection;
        double speed;
        int aqiValue;
        String skycon;
        if (resultHourly.skycon != null && resultHourly.skycon.isNotEmpty) {
          weatherType =
              WeatherUtils.convertWeatherType(resultHourly.skycon[index].value);
          skycon = resultHourly.skycon[index].value;
        }
        if (resultHourly.wind != null && resultHourly.wind.isNotEmpty) {
          windDirection = resultHourly.wind[index].direction;
          speed = resultHourly.wind[index].speed;
        }
        if (resultHourly.wind != null && resultHourly.wind.isNotEmpty) {
          windDirection = resultHourly.wind[index].direction;
          speed = resultHourly.wind[index].speed;
        }
        if (resultHourly.airQuality != null &&
            resultHourly.airQuality.aqi != null &&
            resultHourly.airQuality.aqi.isNotEmpty) {
          aqiValue = resultHourly.airQuality.aqi[index].value.chn;
        }
        _hourData.add(HourData(showTime, temperature, weatherType,
            windDirection, speed, aqiValue, skycon));
      });
      weatherPrint("获取到小时数据为: $_hourData");
    }
  }

  String completionGap(int src) {
    return src < 10 ? "0$src" : "$src";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: BlurRectWidget(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: CustomPaint(
          painter: MyPaint(_hourData),
          size: Size(_hourData.length * 50.toDouble(), 200),
        ),
        scrollDirection: Axis.horizontal,
      ),
    ));
  }
}

class MyPaint extends CustomPainter {
  final List<HourData> _hourData;
  double itemWidth;
  double itemHeight = 80;
  double circleRadius = 2;
  double temTextSize = 14;
  double temTextMarginBottom = 5; // 温度距离折线的距离
  double showTimeMarginTop = 5; // 时间距离折线顶部的距离
  double iconHeight = 25; // 直线预留底部的距离
  double iconMargin = 10;
  int maxTem, minTem;
  Map<int, HourData> _weatherTypes = {};
  List<Offset> _bgOffset = [];

  Path _path = Path();
  Paint _paint = Paint();
  Path _bgPath = Path();
  Paint _bgPaint = Paint();

  MyPaint(this._hourData);

  void setMinMax() {
    if (maxTem == null || minTem == null) {
      minTem = maxTem = _hourData[0].temperature;
      _hourData.forEach((element) {
        if (element.temperature > maxTem) {
          maxTem = element.temperature;
        }
        if (element.temperature < minTem) {
          minTem = element.temperature;
        }
      });
      weatherPrint("setMinMax== min: $minTem, max: $maxTem");
    }
  }

  void initWeatherType() {
    if (_weatherTypes.isEmpty) {
      HourData lastHourData = _hourData[0];
      _weatherTypes[0] = lastHourData;
      _hourData.forEach((element) {
        int index = _hourData.indexOf(element);
        if (element.weatherType != lastHourData.weatherType) {
          _weatherTypes[index] = element;
          lastHourData = element;
        }
        if (index == _hourData.length - 1) {
          _weatherTypes[index] = element;
        }
      });
      weatherPrint("total weather types: $_weatherTypes");
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    setMinMax();
    initWeatherType();
    _paint.color = Colors.white;
    itemWidth = size.width / _hourData.length;
    double gapHeight = itemHeight / (maxTem - minTem);
    _path.reset();
    double startX = itemWidth / 2;
    double startY = temTextSize + temTextMarginBottom * 2;
    _bgOffset.clear();
    _hourData.forEach((element) {
      int index = _hourData.indexOf(element);
      double x = startX + index * itemWidth;
      double y =
          startY + itemHeight - (element.temperature - minTem) * gapHeight;

      var temperatureParagraph = UiUtils.getParagraph("${element.temperature}°", temTextSize, itemWidth: itemWidth);
      canvas.drawParagraph(
          temperatureParagraph,
          Offset(x - temperatureParagraph.width / 2,
              y - temperatureParagraph.height - temTextMarginBottom));

      var offset = Offset(x, y);
      if (index == 0) {
        _path.moveTo(x, y);
      } else {
        _path.lineTo(x, y);
        _paint.style = PaintingStyle.fill;
        canvas.drawCircle(offset, circleRadius, _paint);
      }
      _bgOffset.add(offset);

      // 绘制展示时间
      var showTimeParagraph = UiUtils.getParagraph("${element.showTime}", temTextSize, itemWidth: itemWidth);
      canvas.drawParagraph(
          showTimeParagraph,
          Offset(
              x - showTimeParagraph.width / 2,
              startY +
                  itemHeight +
                  showTimeMarginTop +
                  iconHeight +
                  iconMargin * 2));

      // 添加背景点
    });
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 2;
    _paint.strokeCap = StrokeCap.round;
    _paint.strokeJoin = StrokeJoin.round;
    canvas.drawPath(_path, _paint);
    drawWeatherTypeBg(canvas, size);
  }

  /// 绘制天气类型
  void drawWeatherTypeBg(Canvas canvas, Size size) {
    weatherPrint("_weatherTypes.keys: ${_weatherTypes.keys}");
    bool flag = true;
    int lastIndex;
    double bottomY = temTextSize +
        temTextMarginBottom * 2 +
        itemHeight +
        iconHeight +
        iconMargin * 2;
    _bgPaint.style = PaintingStyle.fill;
    _weatherTypes.forEach((index, hourData) {
      if (lastIndex != null) {
        var offsets = _bgOffset.sublist(lastIndex, index + 1);
        _bgPath.reset();
        offsets.forEach((element) {
          int index = offsets.indexOf(element);
          if (index == 0) {
            _bgPath.moveTo(element.dx, bottomY);
          }
          _bgPath.lineTo(element.dx, element.dy);
          if (index == offsets.length - 1) {
            _bgPath.lineTo(element.dx, bottomY);
            _bgPath.close();
          }
        });
        double middleX = (offsets.first.dx + offsets.last.dx) / 2;
        double middleY =
            temTextSize + temTextMarginBottom * 2 + itemHeight + iconMargin;
        var image = weatherImages[hourData.weatherType];
        canvas.save();
        double scale = iconHeight / image.height;
        canvas.scale(scale);
        var iconOffset =
            Offset(middleX / scale - image.width / 2 * scale, middleY / scale);
        canvas.drawImage(image, iconOffset, _paint);
        canvas.restore();

        flag = !flag;
        var gradient = ui.Gradient.linear(
          Offset(0, temTextSize + temTextMarginBottom * 2),
          Offset(
              0,
              temTextSize +
                  temTextMarginBottom * 2 +
                  itemHeight +
                  iconHeight +
                  iconMargin * 3),
          <Color>[
            flag ? const Color(0xFFffffff) : const Color(0x88FFffff),
            const Color(0x00FFFFFF)
          ],
        );
        _bgPaint.shader = gradient;
        canvas.drawPath(_bgPath, _bgPaint);
      }
      lastIndex = index;
    });
  }

  @override
  bool shouldRepaint(MyPaint oldDelegate) {
    return false;
  }
}

class HourData {
  String showTime;
  int temperature;
  WeatherType weatherType;
  double windDirection;
  double speed;
  int aqiValue;
  String skycon;

  HourData(this.showTime, this.temperature, this.weatherType,
      this.windDirection, this.speed, this.aqiValue, this.skycon);

  @override
  String toString() {
    return 'HourData{showTime: $showTime, temperature: $temperature, weatherType: $weatherType, windDirection: $windDirection, speed: $speed, aqiValue: $aqiValue}';
  }
}
