import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void snap(BuildContext context, String msg,
      {Duration duration = const Duration(milliseconds: 600),
      SnackBarAction? action,
      Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: duration,
      action: action,
      backgroundColor: color ?? Theme.of(context).primaryColor,
    ));
  }

  static void show(String msg, BuildContext? context,
      {int duration = 1,
      int gravity = 2,
      Color backgroundColor = const Color(0xAA000000),
      Color textColor = Colors.white,
      double backgroundRadius = 20,
      Border? border}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: duration > 1 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 14,
    );
  }
}
