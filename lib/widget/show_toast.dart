import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({String? customMessage}) {
  Timer? toastTimer;

  Fluttertoast.showToast(
    msg: customMessage ?? "This feature is still under development.",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1, // Duration for iOS
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 16.0,
  );

  toastTimer = Timer(
    const Duration(seconds: 3),
    () {
      // Cancel the timer
      toastTimer?.cancel();
    },
  );
}
