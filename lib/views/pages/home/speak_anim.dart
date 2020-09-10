import 'dart:math';

import 'package:flutter/material.dart';

class SpeakAnim extends StatefulWidget {
  @override
  _SpeakAnimState createState() => _SpeakAnimState();
}

class _SpeakAnimState extends State<SpeakAnim>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: Duration(seconds: 6));
    animation = Tween<double>(begin: 0, end: 30).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat();
    super.initState();
  }

  @override
  void deactivate() {
    _controller.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: SpeakPainter(animation.value),
        size: Size(25, 15),
      ),
    );
  }
}

class SpeakPainter extends CustomPainter {

  final double itemWidth = 3;
  Paint _paint = Paint();
  final double value;

  SpeakPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;
    _paint.color = Colors.white;
    _paint.style = PaintingStyle.fill;
    _paint.isAntiAlias = true;
    double startX = -width;
    int count = width ~/ itemWidth;
    for (int i = 0; i < count; i++) {
      double x = startX + itemWidth * 2 * i + value;
      double y = (sin(x) + 1) * height / 3 + height / 3;
      canvas.drawRRect(RRect.fromLTRBAndCorners(x, height - y, x + itemWidth, height, topLeft: Radius.circular(4), topRight: Radius.circular(4)), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
