import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'dart:ui' as ui;

import 'package:flutter_dynamic_weather/app/utils/image_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';

class WeatherCloudBg extends StatefulWidget {
  final WeatherType weatherType;

  WeatherCloudBg({Key key, this.weatherType}) : super(key: key);

  @override
  _WeatherCloudBgState createState() => _WeatherCloudBgState();
}

class _WeatherCloudBgState extends State<WeatherCloudBg> {
  List<ui.Image> _images = [];

  Future<void> fetchImages() async {
    weatherPrint("开始获取云层图片");
    var image1 = await ImageUtils.getImage('assets/images/cloud.png');
    var image2 = await ImageUtils.getImage('assets/images/cloud.png');
    _images.add(image1);
    _images.add(image2);
    weatherPrint("获取云层图片成功： ${_images?.length}");
    setState(() {

    });
  }

  @override
  void initState() {
    fetchImages();
    super.initState();
  }

  Widget _buildWidget() {
    weatherPrint("开始构建云层: ${_images?.length}");
    if (_images != null && _images.isNotEmpty) {
      return CustomPaint(
        painter: BgPainter(_images, widget.weatherType),
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

class BgPainter extends CustomPainter {
  var _paint = Paint();
  final List<ui.Image> images;
  final WeatherType weatherType;

  BgPainter(this.images, this.weatherType);

  @override
  void paint(Canvas canvas, Size size) {
    weatherPrint("开始绘制云层${images?.length}");
    if (images != null && images.isNotEmpty) {
      switch(weatherType) {
        case WeatherType.sunny:
          drawSunny(canvas, size);
          break;
        case WeatherType.cloudy:
          drawCloudy(canvas, size);
          break;
        case WeatherType.overcast:
          drawOvercast(canvas, size);
          break;
        case WeatherType.lightRainy:
          drawLightRainy(canvas, size);
          break;
        case WeatherType.middleRainy:
          drawMiddleRainy(canvas, size);
          break;
        case WeatherType.heavyRainy:
        case WeatherType.thunder:
          drawHeavyRainy(canvas, size);
          break;
        case WeatherType.hazy:
          drawHazy(canvas, size);
          break;
        case WeatherType.foggy:
          drawFoggy(canvas, size);
          break;
        case WeatherType.lightSnow:
          drawLightSnow(canvas, size);
          break;
        case WeatherType.middleSnow:
          drawMiddleSnow(canvas, size);
          break;
        case WeatherType.heavySnow:
          drawHeavySnow(canvas, size);
          break;
        case WeatherType.dusty:
          drawDusty(canvas, size);
          break;
        default:
          break;
      }
    }
  }

  void drawSunny(Canvas canvas, Size size) {
    ui.Image image = images[0];
    canvas.save();
    final scale = 0.3;
    var imageWidth = image.width * scale;
    var imageHeight = image.height * scale;
    ui.Offset offset1 = ui.Offset(-100 / scale, 0);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.restore();
  }

  void drawCloudy(Canvas canvas, Size size) {
    ui.Image image = images[1];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 0.9, 0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.4;
    ui.Offset offset1 = ui.Offset(0, 0);
    ui.Offset offset2 = ui.Offset(-280 / scale, -60 / scale);
    ui.Offset offset3 = ui.Offset(-380 / scale, 110 / scale);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.drawImage(image, offset3, _paint);
    canvas.restore();
  }

  void drawOvercast(Canvas canvas, Size size) {
    ui.Image image = images[1];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 0.7, 0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.4;
    ui.Offset offset1 = ui.Offset(-380 / scale, 0);
    ui.Offset offset2 = ui.Offset(0, -60 / scale);
    ui.Offset offset3 = ui.Offset(0, 110 / scale);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.drawImage(image, offset3, _paint);
    canvas.restore();
  }

  void drawLightRainy(Canvas canvas, Size size) {
    ui.Image image = images[1];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.45, 0, 0, 0, 0,
      0, 0.52, 0, 0, 0,
      0, 0, 0.6, 0, 0,
      0, 0, 0, 1, 0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.4;
    ui.Offset offset1 = ui.Offset(-380 / scale, 0);
    ui.Offset offset2 = ui.Offset(0, -60 / scale);
    ui.Offset offset3 = ui.Offset(0, 110 / scale);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.drawImage(image, offset3, _paint);
    canvas.restore();
  }

  void drawHazy(Canvas canvas, Size size) {
    ui.Image image = images[1];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.67, 0, 0, 0, 0,
      0, 0.67, 0, 0, 0,
      0, 0, 0.67, 0, 0,
      0, 0, 0, 1, 0,
    ]);
    _paint.colorFilter = identity;
    final scale = 1.0;
    ui.Offset offset1 = ui.Offset(-image.width.toDouble() * 0.5, -100);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.restore();
  }

  void drawFoggy(Canvas canvas, Size size) {
    ui.Image image = images[1];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.75, 0, 0, 0, 0,
      0, 0.77, 0, 0, 0,
      0, 0, 0.82, 0, 0,
      0, 0, 0, 1, 0,
    ]);
    _paint.colorFilter = identity;
    final scale = 1.0;
    ui.Offset offset1 = ui.Offset(-image.width.toDouble() * 0.5, -100);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.restore();
  }

  void drawDusty(Canvas canvas, Size size) {
    ui.Image image = images[1];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.62, 0, 0, 0, 0,
      0, 0.55, 0, 0, 0,
      0, 0, 0.45, 0, 0,
      0, 0, 0, 1, 0,
    ]);
    _paint.colorFilter = identity;
    final scale = 1.0;
    ui.Offset offset1 = ui.Offset(-image.width.toDouble() * 0.5, -100);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.restore();
  }

  void drawHeavyRainy(Canvas canvas, Size size) {
    ui.Image image = images[1];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.19, 0, 0, 0, 0,
      0, 0.2, 0, 0, 0,
      0, 0, 0.22, 0, 0,
      0, 0, 0, 1, 0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.4;
    ui.Offset offset1 = ui.Offset(-380 / scale, 0);
    ui.Offset offset2 = ui.Offset(0, -60 / scale);
    ui.Offset offset3 = ui.Offset(0, 110 / scale);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.drawImage(image, offset3, _paint);
    canvas.restore();
  }

  void drawMiddleRainy(Canvas canvas, Size size) {
    ui.Image image = images[1];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.16, 0, 0, 0, 0,
      0, 0.22, 0, 0, 0,
      0, 0, 0.31, 0, 0,
      0, 0, 0, 1, 0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.4;
    ui.Offset offset1 = ui.Offset(-380 / scale, 0);
    ui.Offset offset2 = ui.Offset(0, -60 / scale);
    ui.Offset offset3 = ui.Offset(0, 110 / scale);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.drawImage(image, offset3, _paint);
    canvas.restore();
  }

  void drawLightSnow(Canvas canvas, Size size) {
    ui.Image image = images[1];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.67, 0, 0, 0, 0,
      0, 0.75, 0, 0, 0,
      0, 0, 0.87, 0, 0,
      0, 0, 0, 1, 0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.4;
    ui.Offset offset1 = ui.Offset(-380 / scale, 0);
    ui.Offset offset2 = ui.Offset(0, -60 / scale);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.restore();
  }

  void drawMiddleSnow(Canvas canvas, Size size) {
    ui.Image image = images[1];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.7, 0, 0, 0, 0,
      0, 0.77, 0, 0, 0,
      0, 0, 0.87, 0, 0,
      0, 0, 0, 1, 0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.4;
    ui.Offset offset1 = ui.Offset(-380 / scale, 0);
    ui.Offset offset2 = ui.Offset(0, -60 / scale);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.restore();
  }

  void drawHeavySnow(Canvas canvas, Size size) {
    ui.Image image = images[1];
    canvas.save();
    const identity = ColorFilter.matrix(<double>[
      0.74, 0, 0, 0, 0,
      0, 0.74, 0, 0, 0,
      0, 0, 0.81, 0, 0,
      0, 0, 0, 1, 0,
    ]);
    _paint.colorFilter = identity;
    final scale = 0.4;
    ui.Offset offset1 = ui.Offset(-380 / scale, 0);
    ui.Offset offset2 = ui.Offset(0, -60 / scale);
    canvas.scale(scale, scale);
    canvas.drawImage(image, offset1, _paint);
    canvas.drawImage(image, offset2, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
