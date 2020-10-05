import 'dart:math';

import 'package:flutter/material.dart';

class WaveProgress extends StatefulWidget {
  final Size size;
  final Color fillColor;
  final double progress;

  WaveProgress(this.size, this.fillColor, this.progress);

  @override
  WaveProgressState createState() => new WaveProgressState();
}

class WaveProgressState extends State<WaveProgress>
    with TickerProviderStateMixin {
  AnimationController waveController;
  AnimationController progressController;

  @override
  void initState() {
    super.initState();

    progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );

    waveController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
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
    return new Container(
        width: widget.size.width,
        height: widget.size.height,
        child: new AnimatedBuilder(
            animation: waveController,
            builder: (BuildContext context, Widget child) {
              return new CustomPaint(
                  painter: WaveProgressPainter(
                      waveController, progressController, widget.fillColor));
            }));
  }
}

class WaveProgressPainter extends CustomPainter {
  Animation<double> _waveAnimation;
  Animation<double> _progressAnimation;
  Color fillColor;
  Paint topPaint = new Paint();
  Paint bottomPaint = new Paint();

  WaveProgressPainter(
      this._waveAnimation, this._progressAnimation, this.fillColor)
      : super(repaint: _waveAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    bottomPaint.color = fillColor.withOpacity(0.45);
    double progress = _progressAnimation.value;
    double frequency = 3.2;
    double waveHeight = 4.0;
    double currentHeight = (1 - progress) * size.height;

    Path path = Path();
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
