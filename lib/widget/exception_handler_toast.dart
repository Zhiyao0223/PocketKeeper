import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExceptionHandler {
  // To track if a toast is currently showing
  static bool isToastShowing = false;
  static Timer? toastTimer;

  static void handleException(Object exception) {
    String errorMessage = "";

    log(exception.toString());

    if (isToastShowing) {
      // A toast is already showing, don't enqueue another one
      return;
    }
    try {
      if (exception is SocketException) {
        errorMessage =
            "[Error] - Unable to load due to slow or no internet connection. Please try again later.";
      } else if (exception is HttpException) {
        errorMessage =
            "[Error] - Unable to load due to server technical difficulties. Please try again later.";
      } else if (exception is FormatException) {
        errorMessage =
            "[Error] - Unable to load due to format technical difficulties. Please try again later.";
      } else {
        errorMessage =
            "[Error] - An unexpected error occurred. Please try again later.";
      }
    } catch (e) {
      errorMessage =
          "[Error] - An unexpected error occurred. Please try again later.";
    }

    showToastMessage(errorMessage);
  }

  static void showToastMessage(String errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1, // Duration for iOS
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    isToastShowing = true;
    toastTimer = Timer(
      const Duration(seconds: 3),
      () {
        isToastShowing = false;

        // Cancel the timer
        toastTimer?.cancel();
      },
    );
  }
}
