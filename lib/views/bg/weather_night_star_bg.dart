import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'dart:ui' as ui;

import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherNightStarBg extends StatefulWidget {
  final WeatherType weatherType;

  WeatherNightStarBg({Key key, this.weatherType}) : super(key: key);

  @override
  _WeatherNightStarBgState createState() => _WeatherNightStarBgState();
}

class _WeatherNightStarBgState extends State<WeatherNightStarBg>
    with SingleTickerProviderStateMixin {
  List<ui.Image> _images = [];
  AnimationController _controller;
  List<_StarParam> _starParams = [];
  List<_MeteorParam> _meteorParams = [];

  Future<void> fetchImages() async {
    weatherPrint("开始获取星星");
    initStarParams();
    setState(() {
      _controller.repeat();
    });
  }

  void initStarParams() {
    for (int i = 0; i < 100; i++) {
      var index = Random().nextInt(2);
      _StarParam _starParam = _StarParam(index);
      _starParam.init();
      _starParams.add(_starParam);
    }
    for (int i = 0; i < 4; i++) {
      _MeteorParam param = _MeteorParam();
      param.reset();
      _meteorParams.add(param);
    }
  }

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    _controller.addListener(() {
      setState(() {});
    });
    fetchImages();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWidget() {
    weatherPrint("开始构建星星: ${_images?.length}");
    if (_starParams != null &&
        _starParams.isNotEmpty &&
        widget.weatherType == WeatherType.sunnyNight) {
      return CustomPaint(
        painter: _StarPainter(_starParams, _meteorParams),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }
}

class _StarPainter extends CustomPainter {
  var _paint = Paint();
  var _meteorPaint = Paint();
  final List<_StarParam> _starParams;
  final List<_MeteorParam> _meteorParams;
  double _meteorWidth = 200;
  double _meteorHeight = 2;
  Radius _radius = Radius.circular(10);

  _StarPainter(this._starParams, this._meteorParams) {
    _paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 1);
    _paint.color = Colors.white;
    _paint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_starParams != null && _starParams.isNotEmpty) {
      for (var param in _starParams) {
        drawStar(param, canvas);
      }
    }
    if (_meteorParams != null && _meteorParams.isNotEmpty) {
      for (var param in _meteorParams) {
        drawMeteor(param, canvas);
      }
    }
  }

  void drawMeteor(_MeteorParam param, Canvas canvas) {
    canvas.save();
    var gradient = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(_meteorWidth, 0),
      <Color>[const Color(0xFFFFFFFF), const Color(0x00FFFFFF)],
    );
    _meteorPaint.shader = gradient;
    canvas.rotate(pi * param.radians);
    canvas.translate(param.translateX, tan(pi * 0.1) *_meteorWidth + param.translateY);
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(0, 0, _meteorWidth, _meteorHeight,
            topLeft: _radius,
            topRight: _radius,
            bottomRight: _radius,
            bottomLeft: _radius),
        _meteorPaint);
    param.move();
    canvas.restore();
  }

  void drawStar(_StarParam param, Canvas canvas) {
    if (param == null) {
      return;
    }
    canvas.save();
    var identity = ColorFilter.matrix(<double>[
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, param.alpha, 0,
    ]);
    _paint.colorFilter = identity;
    canvas.scale(param.scale);
    canvas.drawCircle(Offset(param.x, param.y), 3, _paint);
    canvas.restore();
    param.move();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _MeteorParam {
  double translateX;
  double translateY;
  double radians;
  void reset() {
    translateX = 1.0.wp + Random().nextDouble() * 20.0.wp;
    radians = -Random().nextDouble() * 0.07 - 0.05;
    translateY = Random().nextDouble() * 0.5.hp;
  }

  void move() {
    translateX -= 20;
    if (translateX <= -1.0.wp) {
      reset();
    }
  }

}

class _StarParam {
  double x;
  double y;
  double alpha = 0.0;
  double scale;
  bool reverse = false;
  int index;

  _StarParam(this.index);

  void reset() {
    alpha = 0;
    double baseScale = index == 0 ? 0.7 : 0.5;
    scale = Random().nextDouble() * 0.1 + baseScale;
    x = Random().nextDouble() * 1.wp / scale;
    y = Random().nextDouble() * 0.3.hp / scale;
    reverse = false;
  }

  void init() {
    alpha = Random().nextDouble();
    double baseScale = index == 0 ? 0.7 : 0.5;
    scale = Random().nextDouble() * 0.1 + baseScale;
    x = Random().nextDouble() * 1.wp / scale;
    y = Random().nextDouble() * 0.3.hp / scale;
    reverse = false;
  }

  void move() {
    if (reverse == true) {
      alpha -= 0.01;
      if (alpha < 0) {
        reset();
      }
    } else {
      alpha += 0.01;
      if (alpha > 1.2) {
        reverse = true;
      }
    }
  }
}