import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/utils/image_utils.dart';
import 'dart:ui' as ui;

import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';

class WeatherRainSnowBg extends StatefulWidget {
  final WeatherType weatherType;

  WeatherRainSnowBg({Key key, this.weatherType}) : super(key: key);

  @override
  _WeatherRainSnowBgState createState() => _WeatherRainSnowBgState();
}

class _WeatherRainSnowBgState extends State<WeatherRainSnowBg>
    with SingleTickerProviderStateMixin {
  List<ui.Image> _images = [];
  AnimationController _controller;
  List<RainSnowParams> _rainSnows = [];
  double width = 0;
  double height = 0;
  double scale = 0.0;
  int count = 0;
  double speed = 0;
  double baseSpeed = 5;

  Future<void> fetchImages() async {
    weatherPrint("开始获取雨雪图片");
    var image1 = await ImageUtils.getImage('assets/images/rain1.png');
    var image2 = await ImageUtils.getImage('assets/images/snow1.png');
    _images.add(image1);
    _images.add(image2);
    weatherPrint("获取雨雪图片成功： ${_images?.length}");
    setState(() {});
  }

  Future<void> initParams() async {
    if (width != 0 && height != 0 && _rainSnows.isEmpty) {
      weatherPrint("开始雨参数初始化 ${_rainSnows.length}， weatherType: ${widget
          .weatherType}, isRainy: ${WeatherUtil.isRainy(widget.weatherType)}");
      if (WeatherUtil.isSnowRain(widget.weatherType)) {
        if (widget.weatherType == WeatherType.lightRainy) {
          scale = 0.1;
          count = 50;
          speed = 10;
          baseSpeed = 80;
        } else if (widget.weatherType == WeatherType.middleRainy) {
          scale = 0.1;
          count = 100;
          speed = 20;
          baseSpeed = 80;
        }  else if (widget.weatherType == WeatherType.heavyRainy) {
          scale = 0.1;
          count = 200;
          speed = 40;
          baseSpeed = 80;
        } else if (widget.weatherType == WeatherType.lightSnow) {
          scale = 0.5;
          count = 30;
          speed = 10;
        } else if (widget.weatherType == WeatherType.middleSnow) {
          scale = 0.5;
          count = 100;
          speed = 15;
        }  else if (widget.weatherType == WeatherType.heavySnow) {
          scale = 0.6;
          count = 200;
          speed = 15;
        }
        for (int i = 0; i < count; i++) {
          double x = Random().nextInt(width ~/ scale).toDouble();
          double y = Random().nextInt(height ~/ scale).toDouble();
          _rainSnows.add(RainSnowParams(x, y, baseSpeed + Random().nextInt(speed.toInt()).toDouble()));
        }
        weatherPrint("初始化雨参数成功 ${_rainSnows.length}");
        setState(() {

        });
      }
    }
  }



  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(minutes: 1), vsync: this);
    CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });
    _controller.forward();
    fetchImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    initParams();
    return CustomPaint(
      painter: RainSnowPainter(this),
    );
  }
}

class RainSnowPainter extends CustomPainter {
  var _paint = Paint();
  _WeatherRainSnowBgState _state;

  RainSnowPainter(this._state);

  @override
  void paint(Canvas canvas, Size size) {
    if (WeatherUtil.isSnow(_state.widget.weatherType)) {
      drawSnow(canvas, size);
    } else if (WeatherUtil.isRainy(_state.widget.weatherType)) {
      drawRain(canvas, size);
    }
  }

  void drawRain(Canvas canvas, Size size) {
    weatherPrint("开始绘制雨层 image:${_state._images?.length}, rains:${_state._rainSnows?.length}");
    if (_state._images != null && _state._images.length > 1) {
      ui.Image image = _state._images[0];
      canvas.save();
      canvas.scale(_state.scale, _state.scale);
      if (_state._rainSnows != null && _state._rainSnows.isNotEmpty) {
        _state._rainSnows.forEach((element) {
          move(element);
          ui.Offset offset = ui.Offset(element.x, element.y);
          canvas.drawImage(image, offset, _paint);
        });
      }
      canvas.restore();
    }
  }

  void move(RainSnowParams params) {
    params.y = params.y + params.speed;
    if (params.y > 800 / _state.scale) {
      params.y = 0;
      if (WeatherUtil.isRainy(_state.widget.weatherType) && _state._images.isNotEmpty && _state._images[0] != null) {
        params.y = -_state._images[0].height.toDouble();
      }
    }
  }

  void drawSnow(Canvas canvas, Size size) {
    weatherPrint("开始绘制雪层 image:${_state._images?.length}, rains:${_state._rainSnows?.length}");
    if (_state._images != null && _state._images.length > 1) {
      ui.Image image = _state._images[1];
      canvas.save();
      canvas.scale(_state.scale, _state.scale);
      if (_state._rainSnows != null && _state._rainSnows.isNotEmpty) {
        _state._rainSnows.forEach((element) {
          move(element);
          ui.Offset offset = ui.Offset(element.x, element.y);
          canvas.drawImage(image, offset, _paint);
        });
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class RainSnowParams {
  double x;
  double y;
  double speed;

  RainSnowParams(this.x, this.y, this.speed);
}
