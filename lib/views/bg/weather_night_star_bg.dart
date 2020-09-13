import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'dart:ui' as ui;

import 'package:flutter_dynamic_weather/app/utils/image_utils.dart';
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

  Future<void> fetchImages() async {
    weatherPrint("开始获取星星");
    var image1 = await ImageUtils.getImage('assets/images/star1.webp');
    var image2 = await ImageUtils.getImage('assets/images/star2.webp');
    _images.add(image1);
    _images.add(image2);
    weatherPrint("获取星星图片成功： ${_images?.length}");
    initStarParams();
    setState(() {
      _controller.repeat();
    });
  }

  void initStarParams() {
    for (int i = 0; i < 100; i++) {
      var index = Random().nextInt(2);
      _StarParam _starParam = _StarParam(_images[Random().nextInt(2)], index);
      _starParam.init();
      _starParams.add(_starParam);
    }
  }

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    _controller.addListener(() {
      setState(() {

      });
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
    if (_starParams != null && _starParams.isNotEmpty &&
        widget.weatherType == WeatherType.sunnyNight) {
      return CustomPaint(
        painter: _StarPainter(_starParams),
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
  final List<_StarParam> starParams;

  _StarPainter(this.starParams);

  @override
  void paint(Canvas canvas, Size size) {
    if (starParams != null && starParams.isNotEmpty) {
      for (var param in starParams) {
        drawStar(param, canvas);
      }
    }
  }

  void drawStar(_StarParam param, Canvas canvas) {
    if (param == null || param.image == null) {
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
    canvas.drawImage(param.image, Offset(param.x, param.y), _paint);
    canvas.restore();
    param.move();
  }

    @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}

class _StarParam {
  ui.Image image;
  double x;
  double y;
  double alpha = 0.0;
  double scale;
  bool reverse = false;
  int index;

  _StarParam(this.image, this.index);

  void reset() {
    alpha = 0;
    double baseScale = index == 0 ? 0.1 : 0.3;
    scale = Random().nextDouble() * 0.1 + baseScale;
    x = Random().nextDouble() * 1.wp / scale;
    y = Random().nextDouble() * 0.3.hp / scale;
    reverse = false;
  }

  void init() {
    alpha = Random().nextDouble();
    double baseScale = index == 0 ? 0.1 : 0.3;
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
      if (alpha > 1) {
        reverse = true;
      }
    }
  }
}