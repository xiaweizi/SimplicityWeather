import 'dart:math';

import 'package:flutter/material.dart';

class WaveProgress extends StatefulWidget {
  final Size size;
  final Color fillColor;
  final double progress;

  const WaveProgress(this.size, this.fillColor, this.progress, {super.key});

  @override
  State<WaveProgress> createState() => WaveProgressState();
}

class WaveProgressState extends State<WaveProgress>
    with TickerProviderStateMixin {
  late AnimationController waveController;
  late AnimationController progressController;

  @override
  void initState() {
    super.initState();

    progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    progressController.animateTo(widget.progress);
    waveController.repeat();
  }

  @override
  void dispose() {
    waveController.dispose();
    progressController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WaveProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      progressController.animateTo(widget.progress / 100.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: AnimatedBuilder(
        animation: waveController,
        builder: (context, _) {
          return CustomPaint(
            painter: WaveProgressPainter(
                waveController, progressController, widget.fillColor),
          );
        },
      ),
    );
  }
}

class WaveProgressPainter extends CustomPainter {
  final Animation<double> _waveAnimation;
  final Animation<double> _progressAnimation;
  final Color fillColor;
  final Paint topPaint = Paint();
  final Paint bottomPaint = Paint();

  WaveProgressPainter(
      this._waveAnimation, this._progressAnimation, this.fillColor)
      : super(repaint: _waveAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    bottomPaint.color = fillColor.withOpacity(0.45);
    final double progress = _progressAnimation.value;
    double frequency = 3.2;
    double waveHeight = 4.0;
    final currentHeight = (1 - progress) * size.height;

    final path = Path();
    path.moveTo(0.0, currentHeight);
    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
          i,
          currentHeight +
              sin((i / size.width * 2 * pi * frequency) +
                      (_waveAnimation.value * 2 * pi) +
                      pi * 1) *
                  waveHeight);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    canvas.drawPath(path, bottomPaint);

    topPaint.color = fillColor;
    frequency = 1.8;
    waveHeight = 10.0;

    path.reset();
    path.moveTo(0.0, currentHeight);
    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
          i,
          currentHeight +
              sin((i / size.width * 2 * pi * frequency) +
                      (_waveAnimation.value * 2 * pi)) *
                  waveHeight);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    canvas.drawPath(path, topPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
