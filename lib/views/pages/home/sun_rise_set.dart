import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_drawing/path_drawing.dart';
import 'dart:ui' as ui;

class SunSetRiseView extends StatelessWidget {
  final WeatherModelResultDailyAstro model;

  const SunSetRiseView({
    Key key,
    this.model,
  }) : super(key: key);

  Widget _buildWidget() {
    if (model != null && model.sunrise != null && model.sunset != null) {
      return Column(
        children: [
          Container(
            height: 140,
            width: 1.wp - DimenConstant.mainMarginStartEnd * 2,
            child: CustomPaint(
              painter: SunSetRisePainter(model.sunrise.time, model.sunset.time),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "日出 ${model.sunrise.time}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Text(
                  "日落 ${model.sunset.time}",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }
}

class SunSetRisePainter extends CustomPainter {
  final String sunriseTime;
  final String sunsetTime;
  double ratio;
  double marginTop = -40;
  double marginBottom = 20;
  double marginLeftRight = 20;

  Paint _paint = Paint();
  Path _path = Path();

  int getMinute(String time) {
    if (time != null && time.isNotEmpty) {
      int hour = int.parse(time.split(":")[0]);
      int minute = int.parse(time.split(":")[1]);
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
    Offset sunOffset = pm.getTangentForOffset(pm.length * ratio).position;
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, sunOffset.dx, height));
    canvas.drawPath(_path, _paint);
    canvas.restore();

    _paint.style = PaintingStyle.fill;
    _paint.color = Colors.yellow;
    canvas.drawCircle(sunOffset, 6, _paint);

    var now = DateTime.now();
    String nowTimeStr = "${now.hour}:${now.minute}";
    var nowTimePara = getParagraph(nowTimeStr, 14);
    canvas.drawParagraph(nowTimePara,
        Offset(sunOffset.dx - nowTimePara.width / 2, sunOffset.dy + 10));
  }

  ui.Paragraph getParagraph(String text, double textSize,
      {Color color = Colors.white}) {
    var pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center, //居中
      fontSize: textSize, //大小
    ));
    pb.addText(text);
    pb.pushStyle(ui.TextStyle(color: color));
    var paragraph = pb.build()..layout(ui.ParagraphConstraints(width: 100));
    return paragraph;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
