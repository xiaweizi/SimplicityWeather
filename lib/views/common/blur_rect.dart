import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';

class BlurRectWidget extends StatefulWidget {
  final Widget? child;
  final double? sigmaX;
  final double? sigmaY;
  final BorderRadius? borderRadius;
  final Color? color;

  const BlurRectWidget({
    super.key,
    this.child,
    this.sigmaX,
    this.sigmaY,
    this.borderRadius,
    this.color,
  });

  @override
  State<BlurRectWidget> createState() => _BlurRectWidgetState();
}

class _BlurRectWidgetState extends State<BlurRectWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius:
              widget.borderRadius ?? BorderRadius.circular(DimenConstant.cardRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.sigmaX ?? 5,
              sigmaY: widget.sigmaY ?? 5,
            ),
            child: Container(
              color: widget.color ?? Colors.black12,
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}
