import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ToastUtils {
  static snap(BuildContext context, String msg,
      {duration = const Duration(
          milliseconds: 600), SnackBarAction action, Color color}) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: duration,
      action: action,
      backgroundColor: color ?? Theme
          .of(context)
          .primaryColor,
    ));
  }

  static show(String msg, BuildContext context,
      {int duration = 1,
        int gravity = 2,
        Color backgroundColor = const Color(0xAA000000),
        Color textColor = Colors.white,
        double backgroundRadius = 20,
        Border border}) {
    Toast.show(msg, context, duration: duration,
        backgroundColor: backgroundColor,
        textColor: textColor,
        backgroundRadius: backgroundRadius,
        border: border);
  }
}
