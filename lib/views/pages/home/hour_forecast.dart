import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/common_extension.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/ui_utils.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

class HourForecastView extends StatelessWidget {
  final WeatherModelResultHourly? resultHourly;
  final List<HourData> _hourData = [];

  HourForecastView({super.key, required this.resultHourly}) {
    final temps = resultHourly?.temperature;
    if (resultHourly == null || temps == null || temps.isEmpty) return;
    for (var i = 0; i < temps.length; i++) {
      final element = temps[i];
      final targetTime = element.datetime?.dateTime;
      final showTime = targetTime == null
          ? ""
          : "${targetTime.hour.gapTime}:${targetTime.minute.gapTime}";
      final temperature = element.value ?? 0;
      WeatherType weatherType = WeatherType.sunny;
      double windDirection = 0;
      double speed = 0;
      int aqiValue = 0;
      String skycon = "";
      final skycons = resultHourly!.skycon;
      if (skycons != null && i < skycons.length) {
        weatherType = WeatherUtils.convertWeatherType(skycons[i].value);
        skycon = skycons[i].value ?? "";
      }
      final winds = resultHourly!.wind;
      if (winds != null && i < winds.length) {
        windDirection = winds[i].direction ?? 0;
        speed = winds[i].speed ?? 0;
      }
      final aqis = resultHourly!.airQuality?.aqi;
      if (aqis != null && i < aqis.length) {
        aqiValue = aqis[i].value?.chn ?? 0;
      }
      _hourData.add(HourData(showTime, temperature, weatherType, windDirection,
          speed, aqiValue, skycon));
    }
    weatherPrint("获取到小时数据为: $_hourData");
  }

  @override
  Widget build(BuildContext context) {
    return BlurRectWidget(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: CustomPaint(
          painter: _HourPainter(_hourData),
          size: Size(_hourData.length * 50.toDouble(), 200),
        ),
      ),
    );
  }
}

class _HourPainter extends CustomPainter {
  final List<HourData> _hourData;
  double itemWidth = 0;
  double itemHeight = 80;
  double circleRadius = 2;
  double temTextSize = 14;
  double temTextMarginBottom = 5;
  double showTimeMarginTop = 5;
  double iconHeight = 25;
  double iconMargin = 10;
  int? maxTem;
  int? minTem;
  final Map<int, HourData> _weatherTypes = {};
  final List<Offset> _bgOffset = [];

  final Path _path = Path();
  final Paint _paint = Paint();
  final Path _bgPath = Path();
  final Paint _bgPaint = Paint();

  _HourPainter(this._hourData);

  void setMinMax() {
    if (_hourData.isEmpty) return;
    if (maxTem == null || minTem == null) {
      minTem = maxTem = _hourData[0].temperature;
      for (final element in _hourData) {
        if (element.temperature > maxTem!) maxTem = element.temperature;
        if (element.temperature < minTem!) minTem = element.temperature;
      }
    }
  }

  void initWeatherType() {
    if (_hourData.isEmpty) return;
    if (_weatherTypes.isEmpty) {
      HourData lastHourData = _hourData[0];
      _weatherTypes[0] = lastHourData;
      for (var i = 0; i < _hourData.length; i++) {
        final element = _hourData[i];
        if (element.weatherType != lastHourData.weatherType) {
          _weatherTypes[i] = element;
          lastHourData = element;
        }
        if (i == _hourData.length - 1) {
          _weatherTypes[i] = element;
        }
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_hourData.isEmpty) return;
    setMinMax();
    initWeatherType();
    _paint.color = Colors.white;
    itemWidth = size.width / _hourData.length;
    final span = (maxTem! - minTem!);
    final gapHeight = span == 0 ? 1.0 : itemHeight / span;
    _path.reset();
    final startX = itemWidth / 2;
    final startY = temTextSize + temTextMarginBottom * 2;
    _bgOffset.clear();
    for (var i = 0; i < _hourData.length; i++) {
      final element = _hourData[i];
      final x = startX + i * itemWidth;
      final y =
          startY + itemHeight - (element.temperature - minTem!) * gapHeight;

      final tempPara = UiUtils.getParagraph(
          "${element.temperature}°", temTextSize,
          itemWidth: itemWidth);
      canvas.drawParagraph(tempPara,
          Offset(x - tempPara.width / 2, y - tempPara.height - temTextMarginBottom));

      final offset = Offset(x, y);
      if (i == 0) {
        _path.moveTo(x, y);
      } else {
        _path.lineTo(x, y);
        _paint.style = PaintingStyle.fill;
        canvas.drawCircle(offset, circleRadius, _paint);
      }
      _bgOffset.add(offset);

      final showTimePara = UiUtils.getParagraph(element.showTime, temTextSize,
          itemWidth: itemWidth);
      canvas.drawParagraph(
        showTimePara,
        Offset(
            x - showTimePara.width / 2,
            startY +
                itemHeight +
                showTimeMarginTop +
                iconHeight +
                iconMargin * 2),
      );
    }
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 2;
    _paint.strokeCap = StrokeCap.round;
    _paint.strokeJoin = StrokeJoin.round;
    canvas.drawPath(_path, _paint);
    _drawWeatherTypeBg(canvas, size);
  }

  void _drawWeatherTypeBg(Canvas canvas, Size size) {
    bool flag = true;
    int? lastIndex;
    final bottomY = temTextSize +
        temTextMarginBottom * 2 +
        itemHeight +
        iconHeight +
        iconMargin * 2;
    _bgPaint.style = PaintingStyle.fill;
    _weatherTypes.forEach((index, hourData) {
      if (lastIndex != null) {
        final offsets = _bgOffset.sublist(lastIndex!, index + 1);
        _bgPath.reset();
        for (var i = 0; i < offsets.length; i++) {
          final pt = offsets[i];
          if (i == 0) _bgPath.moveTo(pt.dx, bottomY);
          _bgPath.lineTo(pt.dx, pt.dy);
          if (i == offsets.length - 1) {
            _bgPath.lineTo(pt.dx, bottomY);
            _bgPath.close();
          }
        }
        final middleX = (offsets.first.dx + offsets.last.dx) / 2;
        final middleY =
            temTextSize + temTextMarginBottom * 2 + itemHeight + iconMargin;
        final image = weatherImages[hourData.weatherType];
        if (image != null) {
          canvas.save();
          final scale = iconHeight / image.height;
          canvas.scale(scale);
          final iconOffset = Offset(
              middleX / scale - image.width / 2 * scale, middleY / scale);
          canvas.drawImage(image, iconOffset, _paint);
          canvas.restore();
        }

        flag = !flag;
        final gradient = ui.Gradient.linear(
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
            const Color(0x00FFFFFF),
          ],
        );
        _bgPaint.shader = gradient;
        canvas.drawPath(_bgPath, _bgPaint);
      }
      lastIndex = index;
    });
  }

  @override
  bool shouldRepaint(_HourPainter oldDelegate) => false;
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
  String toString() =>
      'HourData{time:$showTime, temp:$temperature, aqi:$aqiValue}';
}
