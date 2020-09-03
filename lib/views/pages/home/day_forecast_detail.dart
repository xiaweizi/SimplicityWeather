import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/time_util.dart';
import 'package:flutter_dynamic_weather/app/utils/ui_utils.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/app/res/common_extension.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

class DayForecastDetail extends StatelessWidget {
  List<DaysData> _data = [];

  DayForecastDetail({Key key, @required WeatherModelResultDaily resultDaily})
      : super(key: key) {
    if (resultDaily != null &&
        resultDaily.skycon != null &&
        resultDaily.skycon.isNotEmpty) {
      resultDaily.skycon.forEach((element) {
        int index = resultDaily.skycon.indexOf(element);
        String time;
        String time1;
        WeatherType dayType;
        WeatherType nightType;
        String daySkycon;
        String nightSkycon;
        int dayTemp;
        int nightTemp;
        double windSpeed;
        double windDirection;

        DateTime targetTime = element.date.dateTime;
        time1 = "${targetTime.month}月${targetTime.day}日";
        time = TimeUtil.getWeatherDayDesc(element.date);
        if (resultDaily.temperature != null &&
            index < resultDaily.temperature.length) {
          dayTemp = resultDaily.temperature[index].max;
          nightTemp = resultDaily.temperature[index].min;
        }
        if (resultDaily.skycon08h20h != null &&
            index < resultDaily.skycon08h20h.length) {
          dayType = WeatherUtil.convertWeatherType(
              resultDaily.skycon08h20h[index].value);
          daySkycon = resultDaily.skycon08h20h[index].value;
        }
        if (resultDaily.skycon20h32h != null &&
            index < resultDaily.skycon20h32h.length) {
          nightType = WeatherUtil.convertWeatherType(
              resultDaily.skycon20h32h[index].value);
          nightSkycon = resultDaily.skycon20h32h[index].value;
        }
        if (resultDaily.wind != null && index < resultDaily.wind.length) {
          var wind = resultDaily.wind[index];
          if (wind.avg != null) {
            windSpeed = wind.avg.speed;
            windDirection = wind.avg.direction;
          }
        }
        _data.add(DaysData(time, time1, dayType, nightType, dayTemp, nightTemp,
            windSpeed, windDirection, daySkycon, nightSkycon));
      });
    }
    weatherPrint("daysData: $_data");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: CustomPaint(
          painter: DayPainter(_data),
          size: Size(_data.length * 100.toDouble(), 0.5.hp),
        ),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class DayPainter extends CustomPainter {
  final List<DaysData> _data;
  int topMaxTemp = 0, topMinTemp = 100;
  int bottomMaxTemp = 0, bottomMinTemp = 100;
  double mainTextSize = 14;
  double subTextSize = 10;
  double margin1 = 20;
  double margin2 = 15;
  double margin3 = 30;
  double tempTextSize = 14;
  double topLineStartY, topLineEndY;
  double bottomLineStartY, bottomLineEndY;
  double lineHeight;
  double iconSize = 30;
  double itemWith = 100;

  Paint _paint = Paint();
  Path _topPath = Path();
  Path _bottomPath = Path();

  void setMinMax() {
    _data.forEach((element) {
      if (element.dayTemp > topMaxTemp) {
        topMaxTemp = element.dayTemp;
      }
      if (element.dayTemp < topMinTemp) {
        topMinTemp = element.dayTemp;
      }
      if (element.nightTemp > bottomMaxTemp) {
        bottomMaxTemp = element.nightTemp;
      }
      if (element.nightTemp < bottomMinTemp) {
        bottomMinTemp = element.nightTemp;
      }
    });
    weatherPrint("setMinMax1== min: $topMinTemp, max: $topMaxTemp");
    weatherPrint("setMinMax2== min: $bottomMinTemp, max: $bottomMaxTemp");
  }

  DayPainter(this._data) {
    setMinMax();
    lineHeight = (0.5.hp -
            mainTextSize * 3 -
            subTextSize * 2 -
            margin1 * 2 -
            margin2 * 4 -
            margin3 * 4 -
            tempTextSize * 2 -
            iconSize * 2) /
        2;
    topLineStartY = margin2 * 2 +
        margin3 * 2 +
        margin1 +
        mainTextSize * 2 +
        tempTextSize +
        subTextSize +
        iconSize;
    topLineEndY = topLineStartY + lineHeight;
    bottomLineStartY = topLineEndY + margin1;
    bottomLineEndY = bottomLineStartY + lineHeight;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double startX = itemWith / 2;
    double startY = margin3;
    _topPath.reset();
    _bottomPath.reset();
    _data.forEach((element) {
      int index = _data.indexOf(element);
      var timePara = UiUtils.getParagraph(element.time, mainTextSize, itemWidth: itemWith);
      canvas.drawParagraph(
          timePara, Offset(startX - timePara.width / 2, startY));
      double time1Y = startY + margin1 + mainTextSize;
      var time1Para = UiUtils.getParagraph(element.time1, subTextSize, itemWidth: itemWith);
      canvas.drawParagraph(
          time1Para, Offset(startX - time1Para.width / 2, time1Y));

      var dayIconY = time1Y + margin3;
      var dayImage = weatherImages[element.dayType];
      var scale = iconSize / dayImage.width;
      var dayIconOffset =
          Offset(startX / scale - dayImage.width / 2, dayIconY / scale);
      canvas.save();
      canvas.scale(scale);
      canvas.drawImage(dayImage, dayIconOffset, _paint);
      canvas.restore();

      var dayDescY = dayIconY + iconSize + margin2;
      var dayPara = UiUtils.getParagraph(
          WeatherUtil.convertDesc(element.daySkycon), mainTextSize, itemWidth: itemWith);
      canvas.drawParagraph(
          dayPara, Offset(startX - dayPara.width / 2, dayDescY));

      var nightIconY = bottomLineEndY + tempTextSize + margin2;
      var nightImage = weatherImages[element.dayType];
      var nightIconOffset =
          Offset(startX / scale - nightImage.width / 2, nightIconY / scale);
      canvas.save();
      canvas.scale(scale);
      canvas.drawImage(nightImage, nightIconOffset, _paint);
      canvas.restore();

      var nightDescY = nightIconY + iconSize + margin2;
      var nightPara = UiUtils.getParagraph(
          WeatherUtil.convertDesc(element.nightSkycon), mainTextSize, itemWidth: itemWith);
      canvas.drawParagraph(
          nightPara, Offset(startX - nightPara.width / 2, nightDescY));

//      canvas.drawCircle(Offset(startX, topLineStartY), 5, _paint);
//      canvas.drawCircle(Offset(startX, topLineEndY), 5, _paint);
//      canvas.drawCircle(Offset(startX, bottomLineStartY), 5, _paint);
//      canvas.drawCircle(Offset(startX, bottomLineEndY), 5, _paint);
      _paint.color = Colors.white;
      var topOffset = Offset(startX, getTopLineY(element.dayTemp));
      var bottomOffset = Offset(startX, getBottomLineY(element.dayTemp));
      _paint.style = PaintingStyle.fill;
      canvas.drawCircle(topOffset, 3, _paint);
      canvas.drawCircle(bottomOffset, 3, _paint);

      var topTempPara = UiUtils.getParagraph("${element.dayTemp}°", mainTextSize, itemWidth: itemWith);
      canvas.drawParagraph(
          topTempPara, Offset(topOffset.dx - topTempPara.width / 2, topOffset.dy - topTempPara.height - 5));
      var bottomTempPara = UiUtils.getParagraph("${element.dayTemp}°", mainTextSize, itemWidth: itemWith);
      canvas.drawParagraph(
          bottomTempPara, Offset(bottomOffset.dx - bottomTempPara.width / 2, bottomOffset.dy + 5));

      if (index == 0) {
        _topPath.moveTo(topOffset.dx, topOffset.dy);
        _bottomPath.moveTo(bottomOffset.dx, bottomOffset.dy);
      } else {
        _topPath.lineTo(topOffset.dx, topOffset.dy);
        _bottomPath.lineTo(bottomOffset.dx, bottomOffset.dy);
      }
      startX += itemWith;
    });
    _paint.strokeWidth = 2;
    _paint.style = PaintingStyle.stroke;
    canvas.drawPath(_topPath, _paint);
    canvas.drawPath(_bottomPath, _paint);
  }

  getTopLineY(int temp) {
    if (temp == topMaxTemp) {
      return topLineStartY;
    }
    return topLineStartY +
        (topMaxTemp - temp) / (topMaxTemp - topMinTemp) * lineHeight;
  }

  getBottomLineY(int temp) {
    if (temp == bottomMaxTemp) {
      return bottomLineStartY;
    }
    return bottomLineStartY +
        (bottomMaxTemp - temp) / (bottomMaxTemp - bottomMinTemp);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DaysData {
  String time;
  String time1;
  WeatherType dayType;
  WeatherType nightType;
  int dayTemp;
  int nightTemp;
  double windSpeed;
  double windDirection;
  String daySkycon;
  String nightSkycon;

  DaysData(
      this.time,
      this.time1,
      this.dayType,
      this.nightType,
      this.dayTemp,
      this.nightTemp,
      this.windSpeed,
      this.windDirection,
      this.daySkycon,
      this.nightSkycon);

  @override
  String toString() {
    return 'DaysData{time: $time, time1: $time1, dayType: $dayType, nightType: $nightType, dayTemp: $dayTemp, nightTemp: $nightTemp, windSpeed: $windSpeed, windDirection: $windDirection}';
  }
}
