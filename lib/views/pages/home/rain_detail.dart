import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/ui_utils.dart';
import 'package:flutter_dynamic_weather/net/weather_api.dart';
import 'package:flutter_dynamic_weather/views/common/loading_view.dart';
import 'dart:ui' as ui;

const rainTitleSize = 16.0;
const rainTitleHeight = 60.0;

class RainDetailView extends StatefulWidget {
  final List<double> location;
  final String title;

  RainDetailView({Key key, this.location, this.title}) : super(key: key);

  @override
  _RainDetailViewState createState() => _RainDetailViewState();
}

class _RainDetailViewState extends State<RainDetailView> with SingleTickerProviderStateMixin {

  List<double> _precipitation;
  AnimationController _controller;
  double _ratio = 0.0;

  Future<void> fetchMinuteData() async {
    var res = await WeatherApi().loadMinuteData(widget.location[1].toString(), widget.location[0].toString());
    weatherPrint("$res");
    try {
      List<double> precipitation = List<double>.from(res["result"]["minutely"]["precipitation_2h"]);
      if (precipitation != null && precipitation.isNotEmpty) {
        setState(() {
          _precipitation = precipitation;
        });
        Future.delayed(Duration(milliseconds: 100)).then((value) => {
          _controller.forward()
        });
      }
    } catch (e) {
      weatherPrint(e.toString());
      setState(() {
        _precipitation = [];
      });
    }
  }

  @override
  void initState() {
    fetchMinuteData();
    _controller =
        AnimationController(duration: Duration(milliseconds: 250), vsync: this);
    CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.addListener(() {
      setState(() {
        _ratio = _controller.value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWidget() {
    if (_precipitation == null) {
      return StateView(weatherState: ViewState.loading,);
    } else if (_precipitation.isEmpty) {
      return StateView(weatherState: ViewState.error,);
    } else {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: rainTitleHeight,
              alignment: Alignment.center,
              child: Text(widget.title, style: TextStyle(fontSize: rainTitleSize, color: Colors.white, fontWeight: FontWeight.bold),),
            ),
            Expanded(
              child: CustomPaint(
                painter: RainPainter(_precipitation, _ratio),
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }
}


class RainPainter extends CustomPainter {

  Paint _paint = Paint();
  Paint _linePaint = Paint();
  Path _linePath = Path();
  final double _ratio;

  double _marginLeft = 30;
  double _marginRight = 30;
  double _marginBottom = 60;
  double _timeMarginTop = 10;
  double _textSize = 12;

  List<double> _data;


  RainPainter(List<double> data, this._ratio){
    if (data != null && data.isNotEmpty) {
      bool isEmpty = true;
      for(final item in data) {
        if (item != 0.0) {
          isEmpty = false;
        }
      }
      if (isEmpty == false) {
        _data = data;
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawLine(canvas, size);
    drawBg(canvas, size);
  }

  void drawLine(Canvas canvas, Size size) {
    if (_data != null && _data.isNotEmpty) {
      double width = size.width - _marginLeft - _marginRight;
      double height =  size.height - _marginBottom;
      double startX = _marginLeft;
      double itemWidth = width / 120;
      double itemHeight = height / 100;
      _linePath.reset();
      for (int i = 0; i < _data.length; i++) {
        double y = height - _data[i] * 100 * itemHeight * _ratio;
        double x = startX + i * itemWidth;
        if (i == 0) {
          _linePath.moveTo(x, y);
        } else {
          _linePath.lineTo(x, y);
        }
      }
      var gradient = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, height),
        <Color>[
          const Color(0xFFffffff),
          const Color(0x00FFFFFF)
        ],
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
  }

  void drawBg(Canvas canvas, Size size) {
    // 绘制背景 line
    double itemHeight = (size.height - _marginBottom) / 3;
    double bgLineWidth = size.width - _marginLeft - _marginRight;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 1;
    _paint.color = Colors.white.withAlpha(100);
    for (int i = 0; i < 4; i++) {
      var startOffset = Offset(_marginLeft, itemHeight * i);
      var endOffset = Offset(_marginLeft + bgLineWidth, itemHeight * i);
      canvas.drawLine(startOffset, endOffset, _paint);
    }

    // 绘制底部文字
    var hourY = size.height - _marginBottom + _timeMarginTop;
    var nowPara = UiUtils.getParagraph("现在", _textSize, itemWidth: bgLineWidth / 3);
    canvas.drawParagraph(nowPara, Offset(_marginLeft - nowPara.width / 2, hourY));
    var onePara = UiUtils.getParagraph("1小时后", _textSize, itemWidth: bgLineWidth / 3);
    canvas.drawParagraph(onePara, Offset(_marginLeft + bgLineWidth / 2 - onePara.width / 2, hourY));
    var twoPara = UiUtils.getParagraph("2小时后", _textSize, itemWidth: bgLineWidth / 3);
    canvas.drawParagraph(twoPara, Offset(_marginLeft + bgLineWidth - twoPara.width / 2, hourY));

    // 绘制左侧文字
    var bigPara = UiUtils.getParagraph("大", _textSize);
    canvas.drawParagraph(bigPara, Offset(_marginLeft / 2 - bigPara.width / 2, 0));
    var middlePara = UiUtils.getParagraph("中", _textSize);
    canvas.drawParagraph(middlePara, Offset(_marginLeft / 2 - middlePara.width / 2, itemHeight));
    var smallPara = UiUtils.getParagraph("小", _textSize);
    canvas.drawParagraph(smallPara, Offset(_marginLeft / 2 - smallPara.width / 2, itemHeight * 2));

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}
