import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlurRectWidget extends StatefulWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  final BorderRadius borderRadius;
  final Color color;

  const BlurRectWidget({
    Key key,
    this.child,
    this.sigmaX,
    this.sigmaY,
    this.borderRadius,
    this.color
  }) : super(key: key);

  @override
  _BlurRectWidgetState createState() => _BlurRectWidgetState();
}

class _BlurRectWidgetState extends State<BlurRectWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: widget.borderRadius == null
                ? BorderRadius.circular(DimenConstant.cardRadius)
                : widget.borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: this.widget.sigmaX != null ? this.widget.sigmaX : 5,
                sigmaY: this.widget.sigmaY != null ? this.widget.sigmaY : 5,
              ),
              child: Container(
                color: this.widget.color == null ? Colors.black12 : this.widget.color,
                child: this.widget.child,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
