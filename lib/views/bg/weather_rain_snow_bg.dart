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
  int count = 0;
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
      weatherPrint(
          "开始雨参数初始化 ${_rainSnows.length}， weatherType: ${widget.weatherType}, isRainy: ${WeatherUtil.isRainy(widget.weatherType)}");
      if (WeatherUtil.isSnowRain(widget.weatherType)) {
        if (widget.weatherType == WeatherType.lightRainy) {
          count = 50;
          baseSpeed = 80;
        } else if (widget.weatherType == WeatherType.middleRainy) {
          count = 80;
          baseSpeed = 80;
        } else if (widget.weatherType == WeatherType.heavyRainy) {
          count = 160;
          baseSpeed = 80;
        } else if (widget.weatherType == WeatherType.lightSnow) {
          count = 30;
        } else if (widget.weatherType == WeatherType.middleSnow) {
          count = 100;
        } else if (widget.weatherType == WeatherType.heavySnow) {
          count = 200;
        }
        for (int i = 0; i < count; i++) {
          var rainSnow = RainSnowParams(width, height, widget.weatherType);
          rainSnow.init();
          _rainSnows.add(rainSnow);
        }
        weatherPrint("初始化雨参数成功 ${_rainSnows.length}");
        setState(() {});
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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    weatherPrint(
        "开始绘制雨层 image:${_state._images?.length}, rains:${_state._rainSnows?.length}");
    if (_state._images != null && _state._images.length > 1) {
      ui.Image image = _state._images[0];
      if (_state._rainSnows != null && _state._rainSnows.isNotEmpty) {
        _state._rainSnows.forEach((element) {
          move(element);
          ui.Offset offset = ui.Offset(element.x, element.y);
          canvas.save();
          canvas.scale(element.scale, element.scale);
          var identity = ColorFilter.matrix(<double>[
            1, 0, 0, 0, 0,
            0, 1, 0, 0, 0,
            0, 0, 1, 0, 0,
            0, 0, 0, element.alpha, 0,
          ]);
          _paint.colorFilter = identity;
          canvas.drawImage(image, offset, _paint);
          canvas.restore();
        });
      }
    }
  }

  void move(RainSnowParams params) {
    params.y = params.y + params.speed;
    if (WeatherUtil.isSnow(_state.widget.weatherType)) {
      double offsetX = sin(params.y / (300 + 50 * params.alpha)) * (1 + 0.5 * params.alpha);
      params.x += offsetX;
    }
    if (params.y > 800 / params.scale) {
      params.y = 0;
      if (WeatherUtil.isRainy(_state.widget.weatherType) &&
          _state._images.isNotEmpty &&
          _state._images[0] != null) {
        params.y = -_state._images[0].height.toDouble();
      }
      params.reset();
    }
  }

  void drawSnow(Canvas canvas, Size size) {
    weatherPrint(
        "开始绘制雪层 image:${_state._images?.length}, rains:${_state._rainSnows?.length}");
    if (_state._images != null && _state._images.length > 1) {
      ui.Image image = _state._images[1];
      if (_state._rainSnows != null && _state._rainSnows.isNotEmpty) {
        _state._rainSnows.forEach((element) {
          move(element);
          ui.Offset offset = ui.Offset(element.x, element.y);
          canvas.save();
          canvas.scale(element.scale, element.scale);
          var identity = ColorFilter.matrix(<double>[
            1, 0, 0, 0, 0,
            0, 1, 0, 0, 0,
            0, 0, 1, 0, 0,
            0, 0, 0, element.alpha, 0,
          ]);
          _paint.colorFilter = identity;
          canvas.drawImage(image, offset, _paint);
          canvas.restore();
        });
      }
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
  double scale;
  double width;
  double height;
  double alpha;
  WeatherType weatherType;

  RainSnowParams(this.width, this.height, this.weatherType);

  void init() {
// 雨 0.1 雪 0.5
    reset();
    y = Random().nextInt(height ~/ scale).toDouble();
  }

  void reset() {
    double initScale = 0.1;
    double gapScale = 0.2;
    double initSpeed = 40;
    double gapSpeed = 40;
    if (weatherType == WeatherType.lightRainy) {
      initScale = 1.05;
      gapScale = 0.1;
      initSpeed = 15;
      gapSpeed = 10;
    } else if (weatherType == WeatherType.middleRainy) {
      initScale = 1.07;
      gapScale = 0.12;
      initSpeed = 20;
      gapSpeed = 20;
    } else if (weatherType == WeatherType.heavyRainy) {
      initScale = 1.09;
      gapScale = 0.15;
      initSpeed = 22;
      gapSpeed = 20;
    } else if (weatherType == WeatherType.lightSnow) {
      initScale = 0.45;
      gapScale = 0.05;
      initSpeed = 2;
      gapSpeed = 3;
    } else if (weatherType == WeatherType.middleSnow) {
      initScale = 0.4;
      gapScale = 0.15;
      initSpeed = 3;
      gapSpeed = 6;
    } else if (weatherType == WeatherType.heavySnow) {
      initScale = 0.45;
      gapScale = 0.2;
      initSpeed = 4;
      gapSpeed = 7;
    }
    double random = Random().nextDouble();
    this.scale = initScale + gapScale * random;
    this.speed = initSpeed + gapSpeed * (1 - random);
    this.alpha = 0.1 + 0.9 * random;
    x = Random().nextInt(width * 1.2 ~/ scale).toDouble() - width * 0.1 ~/ scale;
  }
}
