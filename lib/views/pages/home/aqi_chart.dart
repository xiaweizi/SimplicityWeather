import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/ui_utils.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AqiChartView extends StatelessWidget {
  final WeatherModelEntity entity;

  const AqiChartView({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final width = (1.sw -
            DimenConstant.cardMarginStartEnd * 2 -
            DimenConstant.dayMiddleMargin) /
        2;
    final height = DimenConstant.aqiChartHeight;
    final aqiValue = entity.result?.realtime?.airQuality?.aqi?.chn;
    final aqiValueStr = aqiValue == null ? "0" : "$aqiValue";
    final aqiRatio = aqiValue == null ? 0.0 : aqiValue.toDouble() / 500;
    final humidityValue = entity.result?.realtime?.humidity ?? 0;
    final humidityStr = "${(humidityValue * 100).toInt()}%";

    return Row(
      children: [
        BlurRectWidget(
          child: SizedBox(
            width: width,
            height: height,
            child: CustomPaint(
              painter: AqiChartPainter(
                  aqiRatio,
                  aqiValueStr,
                  entity.result?.realtime?.airQuality?.description?.chn ??
                      ""),
            ),
          ),
        ),
        const SizedBox(width: DimenConstant.dayMiddleMargin),
        BlurRectWidget(
          child: SizedBox(
            width: width,
            height: height,
            child: CustomPaint(
              painter: AqiChartPainter(humidityValue, humidityStr, "体感"),
            ),
          ),
        ),
      ],
    );
  }
}

class AqiChartPainter extends CustomPainter {
  final Paint _paint = Paint();
  final Path _path = Path();
  final double ratio;
  final String value;
  final String desc;

  AqiChartPainter(this.ratio, this.value, this.desc);

  @override
  void paint(Canvas canvas, Size size) {
    weatherPrint("AqiChartPainter size:$size");
    final radius = size.height / 2 - 10;
    final centerOffset = Offset(size.width / 2, size.height / 2);
    _path.reset();
    _path.addArc(Rect.fromCircle(center: centerOffset, radius: radius),
        pi * 0.7, pi * 1.6);
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 4;
    _paint.strokeCap = StrokeCap.round;
    _paint.color = Colors.white38;
    canvas.drawPath(_path, _paint);
    _path.reset();
    _path.addArc(Rect.fromCircle(center: centerOffset, radius: radius),
        pi * 0.7, pi * 1.6 * ratio);
    _paint.color = Colors.white;
    canvas.drawPath(_path, _paint);
    final valuePara = UiUtils.getParagraph(value, 30);
    canvas.drawParagraph(
        valuePara,
        Offset(centerOffset.dx - valuePara.width / 2,
            centerOffset.dy - valuePara.height / 2));
    final descPara = UiUtils.getParagraph(desc, 15);
    canvas.drawParagraph(
        descPara,
        Offset(centerOffset.dx - valuePara.width / 2,
            centerOffset.dy + valuePara.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
