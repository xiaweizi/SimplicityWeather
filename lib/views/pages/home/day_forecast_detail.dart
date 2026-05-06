import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/common_extension.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/time_util.dart';
import 'package:flutter_dynamic_weather/app/utils/ui_utils.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DayForecastDetail extends StatelessWidget {
  final List<DaysData> _data = [];

  DayForecastDetail({super.key, required WeatherModelResultDaily? resultDaily}) {
    final skycon = resultDaily?.skycon;
    if (resultDaily == null || skycon == null || skycon.isEmpty) return;
    for (var i = 0; i < skycon.length; i++) {
      final element = skycon[i];
      final rawDate = element.date;
      DateTime? date;
      if (rawDate != null && rawDate.isNotEmpty) {
        try {
          date = rawDate.dateTime;
        } catch (_) {}
      }
      final time1 = date == null ? "" : "${date.month}月${date.day}日";
      final time = TimeUtil.getWeatherDayDesc(rawDate);
      int dayTemp = 0;
      int nightTemp = 0;
      WeatherType dayType = WeatherType.sunny;
      WeatherType nightType = WeatherType.sunny;
      String? daySkycon;
      String? nightSkycon;
      double windSpeed = 0;
      double windDirection = 0;
      final temps = resultDaily.temperature;
      if (temps != null && i < temps.length) {
        dayTemp = temps[i].max ?? 0;
        nightTemp = temps[i].min ?? 0;
      }
      final daySky = resultDaily.skycon08h20h;
      if (daySky != null && i < daySky.length) {
        dayType = WeatherUtils.convertWeatherType(daySky[i].value);
        daySkycon = daySky[i].value;
      }
      final nightSky = resultDaily.skycon20h32h;
      if (nightSky != null && i < nightSky.length) {
        nightType = WeatherUtils.convertWeatherType(nightSky[i].value);
        nightSkycon = nightSky[i].value;
      }
      final winds = resultDaily.wind;
      if (winds != null && i < winds.length) {
        final avg = winds[i].avg;
        if (avg != null) {
          windSpeed = avg.speed ?? 0;
          windDirection = avg.direction ?? 0;
        }
      }
      _data.add(DaysData(time, time1, dayType, nightType, dayTemp, nightTemp,
          windSpeed, windDirection, daySkycon ?? '', nightSkycon ?? ''));
    }
    weatherPrint("daysData: $_data");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: CustomPaint(
        painter: DayPainter(_data),
        size: Size(_data.length * 100.toDouble(), 0.5.sh),
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
  double topLineStartY = 0, topLineEndY = 0;
  double bottomLineStartY = 0, bottomLineEndY = 0;
  double lineHeight = 0;
  double iconSize = 30;
  double itemWith = 100;

  final Paint _paint = Paint();
  final Path _topPath = Path();
  final Path _bottomPath = Path();

  void setMinMax() {
    for (final element in _data) {
      if (element.dayTemp > topMaxTemp) topMaxTemp = element.dayTemp;
      if (element.dayTemp < topMinTemp) topMinTemp = element.dayTemp;
      if (element.nightTemp > bottomMaxTemp) bottomMaxTemp = element.nightTemp;
      if (element.nightTemp < bottomMinTemp) bottomMinTemp = element.nightTemp;
    }
  }

  DayPainter(this._data) {
    setMinMax();
    lineHeight = (0.5.sh -
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
    final double startY = margin3;
    _topPath.reset();
    _bottomPath.reset();
    for (var i = 0; i < _data.length; i++) {
      final element = _data[i];
      final timePara = UiUtils.getParagraph(element.time, mainTextSize,
          itemWidth: itemWith);
      canvas.drawParagraph(
          timePara, Offset(startX - timePara.width / 2, startY));
      final time1Y = startY + margin1 + mainTextSize;
      final time1Para = UiUtils.getParagraph(element.time1, subTextSize,
          itemWidth: itemWith);
      canvas.drawParagraph(
          time1Para, Offset(startX - time1Para.width / 2, time1Y));

      final dayIconY = time1Y + margin3;
      final dayImage = weatherImages[element.dayType];
      if (dayImage != null) {
        final scale = iconSize / dayImage.width;
        final dayIconOffset =
            Offset(startX / scale - dayImage.width / 2, dayIconY / scale);
        canvas.save();
        canvas.scale(scale);
        canvas.drawImage(dayImage, dayIconOffset, _paint);
        canvas.restore();
      }

      final dayDescY = dayIconY + iconSize + margin2;
      final dayPara = UiUtils.getParagraph(
          WeatherUtils.convertDesc(element.daySkycon), mainTextSize,
          itemWidth: itemWith);
      canvas.drawParagraph(
          dayPara, Offset(startX - dayPara.width / 2, dayDescY));

      final nightIconY = bottomLineEndY + tempTextSize + margin2;
      final nightImage = weatherImages[element.nightType];
      if (nightImage != null) {
        final scale = iconSize / nightImage.width;
        final nightIconOffset = Offset(
            startX / scale - nightImage.width / 2, nightIconY / scale);
        canvas.save();
        canvas.scale(scale);
        canvas.drawImage(nightImage, nightIconOffset, _paint);
        canvas.restore();
      }

      final nightDescY = nightIconY + iconSize + margin2;
      final nightPara = UiUtils.getParagraph(
          WeatherUtils.convertDesc(element.nightSkycon), mainTextSize,
          itemWidth: itemWith);
      canvas.drawParagraph(
          nightPara, Offset(startX - nightPara.width / 2, nightDescY));

      _paint.color = Colors.white;
      final topOffset = Offset(startX, _getTopLineY(element.dayTemp));
      final bottomOffset = Offset(startX, _getBottomLineY(element.dayTemp));
      _paint.style = PaintingStyle.fill;
      canvas.drawCircle(topOffset, 3, _paint);
      canvas.drawCircle(bottomOffset, 3, _paint);

      final topTempPara = UiUtils.getParagraph(
          "${element.dayTemp}°", mainTextSize,
          itemWidth: itemWith);
      canvas.drawParagraph(
          topTempPara,
          Offset(topOffset.dx - topTempPara.width / 2,
              topOffset.dy - topTempPara.height - 5));
      final bottomTempPara = UiUtils.getParagraph(
          "${element.dayTemp}°", mainTextSize,
          itemWidth: itemWith);
      canvas.drawParagraph(
          bottomTempPara,
          Offset(bottomOffset.dx - bottomTempPara.width / 2,
              bottomOffset.dy + 5));

      if (i == 0) {
        _topPath.moveTo(topOffset.dx, topOffset.dy);
        _bottomPath.moveTo(bottomOffset.dx, bottomOffset.dy);
      } else {
        _topPath.lineTo(topOffset.dx, topOffset.dy);
        _bottomPath.lineTo(bottomOffset.dx, bottomOffset.dy);
      }
      startX += itemWith;
    }
    _paint.strokeWidth = 2;
    _paint.style = PaintingStyle.stroke;
    canvas.drawPath(_topPath, _paint);
    canvas.drawPath(_bottomPath, _paint);
  }

  double _getTopLineY(int temp) {
    if (temp == topMaxTemp) return topLineStartY;
    final range = topMaxTemp - topMinTemp;
    if (range == 0) return topLineStartY;
    return topLineStartY + (topMaxTemp - temp) / range * lineHeight;
  }

  double _getBottomLineY(int temp) {
    if (temp == bottomMaxTemp) return bottomLineStartY;
    final range = bottomMaxTemp - bottomMinTemp;
    if (range == 0) return bottomLineStartY;
    return bottomLineStartY + (bottomMaxTemp - temp) / range;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
    this.nightSkycon,
  );

  @override
  String toString() =>
      'DaysData{time:$time, time1:$time1, dayTemp:$dayTemp, nightTemp:$nightTemp}';
}
