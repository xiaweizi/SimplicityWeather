import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/ui_utils.dart';
import 'package:flutter_dynamic_weather/net/weather_api.dart';
import 'package:flutter_dynamic_weather/views/common/loading_view.dart';

const rainTitleSize = 16.0;
const rainTitleHeight = 60.0;

class RainDetailView extends StatefulWidget {
  final List<double>? location;
  final String? title;

  const RainDetailView({super.key, this.location, this.title});

  @override
  State<RainDetailView> createState() => _RainDetailViewState();
}

class _RainDetailViewState extends State<RainDetailView>
    with SingleTickerProviderStateMixin {
  List<double>? _precipitation;
  late AnimationController _controller;
  double _ratio = 0.0;

  Future<void> fetchMinuteData() async {
    final loc = widget.location;
    if (loc == null || loc.length < 2) {
      if (mounted) setState(() => _precipitation = []);
      return;
    }
    final res =
        await WeatherApi().loadMinuteData(loc[1].toString(), loc[0].toString());
    weatherPrint("$res");
    try {
      final list = (res["result"]["minutely"]["precipitation_2h"] as List)
          .cast<num>()
          .map((e) => e.toDouble())
          .toList();
      if (list.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          _precipitation = list;
        });
        Future.delayed(const Duration(milliseconds: 200))
            .then((_) => _controller.forward());
      }
    } catch (e) {
      weatherPrint(e.toString());
      if (!mounted) return;
      setState(() {
        _precipitation = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    _controller.addListener(() {
      if (!mounted) return;
      setState(() {
        _ratio = _controller.value;
      });
    });
    fetchMinuteData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWidget() {
    final p = _precipitation;
    if (p == null) return const StateView(weatherState: ViewState.loading);
    if (p.isEmpty) return const StateView(weatherState: ViewState.error);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: rainTitleHeight,
          alignment: Alignment.center,
          child: Text(widget.title ?? "",
              style: const TextStyle(
                fontSize: rainTitleSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ),
        Expanded(
          child: CustomPaint(painter: RainPainter(p, _ratio)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => _buildWidget();
}

class RainPainter extends CustomPainter {
  final Paint _paint = Paint();
  final Paint _linePaint = Paint();
  final Path _linePath = Path();
  final double _ratio;

  double _marginLeft = 30;
  double _marginRight = 30;
  double _marginBottom = 60;
  double _timeMarginTop = 10;
  double _textSize = 12;

  List<double>? _data;

  RainPainter(List<double> data, this._ratio) {
    if (data.isNotEmpty) {
      bool isEmpty = true;
      for (final item in data) {
        if (item != 0.0) isEmpty = false;
      }
      if (!isEmpty) _data = data;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawLine(canvas, size);
    _drawBg(canvas, size);
  }

  void _drawLine(Canvas canvas, Size size) {
    final data = _data;
    if (data == null || data.isEmpty) return;
    final width = size.width - _marginLeft - _marginRight;
    final height = size.height - _marginBottom;
    final startX = _marginLeft;
    final itemWidth = width / 120;
    final itemHeight = height / 100;
    _linePath.reset();
    for (int i = 0; i < data.length; i++) {
      final y = height - data[i] * 100 * itemHeight * _ratio;
      final x = startX + i * itemWidth;
      if (i == 0) {
        _linePath.moveTo(x, y);
      } else {
        _linePath.lineTo(x, y);
      }
    }
    final gradient = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(0, height),
      const <Color>[Color(0xFFffffff), Color(0x00FFFFFF)],
    );
    _linePaint.style = PaintingStyle.stroke;
    _linePaint.strokeWidth = 1;
    _linePaint.color = Colors.white;
    canvas.drawPath(_linePath, _linePaint);
    _linePath.lineTo(width + startX, height);
    _linePath.lineTo(startX, height);
    _linePath.close();
    _linePaint.style = PaintingStyle.fill;
    _linePaint.shader = gradient;
    canvas.drawPath(_linePath, _linePaint);
  }

  void _drawBg(Canvas canvas, Size size) {
    final itemHeight = (size.height - _marginBottom) / 3;
    final bgLineWidth = size.width - _marginLeft - _marginRight;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 1;
    _paint.color = Colors.white.withAlpha(100);
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(_marginLeft, itemHeight * i),
        Offset(_marginLeft + bgLineWidth, itemHeight * i),
        _paint,
      );
    }
    final hourY = size.height - _marginBottom + _timeMarginTop;
    final nowPara =
        UiUtils.getParagraph("现在", _textSize, itemWidth: bgLineWidth / 3);
    canvas.drawParagraph(
        nowPara, Offset(_marginLeft - nowPara.width / 2, hourY));
    final onePara =
        UiUtils.getParagraph("1小时后", _textSize, itemWidth: bgLineWidth / 3);
    canvas.drawParagraph(onePara,
        Offset(_marginLeft + bgLineWidth / 2 - onePara.width / 2, hourY));
    final twoPara =
        UiUtils.getParagraph("2小时后", _textSize, itemWidth: bgLineWidth / 3);
    canvas.drawParagraph(
        twoPara, Offset(_marginLeft + bgLineWidth - twoPara.width / 2, hourY));

    final bigPara = UiUtils.getParagraph("大", _textSize);
    canvas.drawParagraph(
        bigPara, Offset(_marginLeft / 2 - bigPara.width / 2, 0));
    final middlePara = UiUtils.getParagraph("中", _textSize);
    canvas.drawParagraph(middlePara,
        Offset(_marginLeft / 2 - middlePara.width / 2, itemHeight));
    final smallPara = UiUtils.getParagraph("小", _textSize);
    canvas.drawParagraph(smallPara,
        Offset(_marginLeft / 2 - smallPara.width / 2, itemHeight * 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
