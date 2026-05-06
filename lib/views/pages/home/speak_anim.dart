import 'dart:math';

import 'package:flutter/material.dart';

class SpeakAnim extends StatefulWidget {
  const SpeakAnim({super.key});

  @override
  State<SpeakAnim> createState() => _SpeakAnimState();
}

class _SpeakAnimState extends State<SpeakAnim>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 6));
    animation = Tween<double>(begin: 0, end: 30).animate(_controller)
      ..addListener(() {
        if (mounted) setState(() {});
      });
    _controller.repeat();
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
    return CustomPaint(
      painter: SpeakPainter(animation.value),
      size: const Size(25, 15),
    );
  }
}

class SpeakPainter extends CustomPainter {
  final double itemWidth = 3;
  final Paint _paint = Paint();
  final double value;

  SpeakPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    _paint.color = Colors.white;
    _paint.style = PaintingStyle.fill;
    _paint.isAntiAlias = true;
    final startX = -width;
    final count = width ~/ itemWidth;
    for (int i = 0; i < count; i++) {
      final x = startX + itemWidth * 2 * i + value;
      final y = (sin(x) + 1) * height / 3 + height / 3;
      canvas.drawRRect(
        RRect.fromLTRBAndCorners(x, height - y, x + itemWidth, height,
            topLeft: const Radius.circular(4),
            topRight: const Radius.circular(4)),
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
