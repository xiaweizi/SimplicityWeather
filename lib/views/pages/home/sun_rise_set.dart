import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/ui_utils.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_drawing/path_drawing.dart';
import 'dart:ui' as ui;

class SunSetRiseView extends StatelessWidget {
  final WeatherModelResultDailyAstro? model;

  const SunSetRiseView({super.key, this.model});

  Widget _buildWidget() {
    final m = model;
    final sunriseTime = m?.sunrise?.time;
    final sunsetTime = m?.sunset?.time;
    if (sunriseTime == null || sunsetTime == null) return const SizedBox.shrink();
    return Column(
      children: [
        SizedBox(
          height: 140,
          width: 1.sw - DimenConstant.mainMarginStartEnd * 2,
          child: CustomPaint(
            painter: SunSetRisePainter(sunriseTime, sunsetTime),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Text("日出 $sunriseTime",
                  style: const TextStyle(color: Colors.white)),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: Text("日落 $sunsetTime",
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }
}

class SunSetRisePainter extends CustomPainter {
  final String sunriseTime;
  final String sunsetTime;
  double ratio = 0;
  double marginTop = -40;
  double marginBottom = 20;
  double marginLeftRight = 20;

  final Paint _paint = Paint();
  final Path _path = Path();

  int getMinute(String time) {
    if (time.isNotEmpty) {
      final parts = time.split(":");
      if (parts.length < 2) return 0;
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      return hour * 60 + minute;
    }
    return 0;
  }

  SunSetRisePainter(this.sunriseTime, this.sunsetTime) {
    int sunriseMinute = getMinute(sunriseTime);
    int sunsetMinute = getMinute(sunsetTime);
    int nowMinute = DateTime.now().hour * 60 + DateTime.now().minute;
    int resultMinute = max(sunriseMinute, min(sunsetMinute, nowMinute));
    ratio = (resultMinute - sunriseMinute).toDouble() /
        (sunsetMinute - sunriseMinute);
    weatherPrint(
        "SunSetRisePainter || $sunriseMinute, $sunsetMinute, $nowMinute, ratio: $ratio");
  }

  @override
  void paint(Canvas canvas, Size size) {
    var height = size.height;
    var width = size.width;
    double startX = marginLeftRight;
    double startY = height - marginBottom;
    double endX = width - marginLeftRight;
    double endY = startY;
    _path.reset();
    _path.moveTo(startX, startY);
    _path.quadraticBezierTo(width / 2, marginTop, endX, endY);
    _paint.color = Colors.white;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 1.5;
    canvas.drawPath(
        dashPath(_path, dashArray: CircularIntervalList<double>([10, 5])),
        _paint);

    var metrics = _path.computeMetrics();
    var pm = metrics.elementAt(0);
    final tangent = pm.getTangentForOffset(pm.length * ratio);
    final sunOffset = tangent?.position ?? Offset.zero;
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, sunOffset.dx, height));
    canvas.drawPath(_path, _paint);
    canvas.restore();

    _paint.style = PaintingStyle.fill;
    _paint.color = Colors.yellow;
    canvas.drawCircle(sunOffset, 6, _paint);

    var now = DateTime.now();
    String nowTimeStr = "${now.hour}:${now.minute}";
    var nowTimePara = UiUtils.getParagraph(nowTimeStr, 14);
    canvas.drawParagraph(nowTimePara,
        Offset(sunOffset.dx - nowTimePara.width / 2, sunOffset.dy + 10));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
