import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toaster {
  static late FToast _fToast;

  // Call this once in your main.dart or root widget
  static void init(BuildContext context) {
    _fToast = FToast();
    _fToast.init(context);
  }

  static void show(String message, {bool isError = false}) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: isError ? Colors.red : Colors.black87,
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Tajawal', // <--- Your custom font here
          fontSize: 14,
        ),
      ),
    );

    _fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
