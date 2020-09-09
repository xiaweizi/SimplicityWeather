import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'dart:ui' as ui;

import 'package:flutter_dynamic_weather/app/utils/image_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherThunderBg extends StatefulWidget {
  final WeatherType weatherType;

  WeatherThunderBg({Key key, this.weatherType}) : super(key: key);

  @override
  _WeatherCloudBgState createState() => _WeatherCloudBgState();
}

class _WeatherCloudBgState extends State<WeatherThunderBg> with SingleTickerProviderStateMixin{
  List<ui.Image> _images = [];
  AnimationController _controller;
  List<ThunderParams> _thunderParams = [];

  Future<void> fetchImages() async {
    weatherPrint("开始获取雷暴图片");
    var image1 = await ImageUtils.getImage('assets/images/lightning/lightning0.webp');
    var image2 = await ImageUtils.getImage('assets/images/lightning/lightning1.webp');
    var image3 = await ImageUtils.getImage('assets/images/lightning/lightning2.webp');
    var image4 = await ImageUtils.getImage('assets/images/lightning/lightning3.webp');
    var image5 = await ImageUtils.getImage('assets/images/lightning/lightning4.webp');
    _images.add(image1);
    _images.add(image2);
    _images.add(image3);
    _images.add(image4);
    _images.add(image5);
    weatherPrint("获取雷暴图片成功： ${_images?.length}");
    initThunderParams();
    setState(() {
      _controller.forward();
    });
  }

  @override
  void initState() {
    fetchImages();
    initAnim();
    super.initState();
  }

  void initAnim() {
    _controller = AnimationController(duration: Duration(seconds: 5), vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        Future.delayed(Duration(seconds: 2)).then((value) {
          initThunderParams();
          _controller.forward();
        });
      }
    });

    var _animation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 3),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.0, 0.3,
        curve: Curves.ease,
      ),
    ));

    var _animation1 = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 3),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.2, 0.5,
        curve: Curves.ease,
      ),
    ));

    var _animation2 = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 3),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.6, 0.9,
        curve: Curves.ease,
      ),
    ));

    _animation.addListener(() {
      if (_thunderParams != null && _thunderParams.isNotEmpty) {
        _thunderParams[0].alpha = _animation.value;
      }
      setState(() {

      });
    });

    _animation1.addListener(() {
      if (_thunderParams != null && _thunderParams.isNotEmpty) {
        _thunderParams[1].alpha = _animation1.value;
      }
      setState(() {

      });
    });

    _animation2.addListener(() {
      if (_thunderParams != null && _thunderParams.isNotEmpty) {
        _thunderParams[2].alpha = _animation2.value;
      }
      setState(() {

      });
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWidget() {
    weatherPrint("开始构建雷暴: ${_images?.length}");
    if (_thunderParams != null && _thunderParams.isNotEmpty && widget.weatherType == WeatherType.thunder) {
      return  CustomPaint(
        painter: ThunderPainter(_thunderParams),
      );
    } else {
      return Container();
    }
  }

  void initThunderParams() {
    _thunderParams.clear();
    var param1 = ThunderParams(_images[Random().nextInt(5)]);
    param1.reset();
    var param2 = ThunderParams(_images[Random().nextInt(5)]);
    param2.reset();
    var param3 = ThunderParams(_images[Random().nextInt(5)]);
    param3.reset();
    _thunderParams.add(param1);
    _thunderParams.add(param2);
    _thunderParams.add(param3);
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }
}

class ThunderPainter extends CustomPainter {
  var _paint = Paint();
  final List<ThunderParams> thunderParams;

  ThunderPainter(this.thunderParams);

  @override
  void paint(Canvas canvas, Size size) {
    if (thunderParams != null && thunderParams.isNotEmpty) {
      for (var param in thunderParams) {
        drawThunder(param, canvas, size);
      }
    }
  }
  
  void drawThunder(ThunderParams params, Canvas canvas, Size size) {
    if (params == null || params.image == null) {
      return;
    }
    canvas.save();
    var identity = ColorFilter.matrix(<double>[
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, params.alpha, 0,
    ]);
    _paint.colorFilter = identity;
    canvas.drawImage(params.image, Offset(params.x, params.y), _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ThunderParams {
  ui.Image image;
  double x;
  double y;
  double alpha;
  int get imgWidth => image.width;
  int get imgHeight => image.height;

  ThunderParams(this.image);

  void reset() {
    x = Random().nextDouble() * 0.5.wp -  1 / 3 * imgWidth;
    y = Random().nextDouble() * -0.05.hp;
    alpha = 0;
  }
}
