import 'package:flutter/material.dart';

class CustomTheme {
  final Color card,
      cardDark,
      border,
      borderDark,
      disabledColor,
      onDisabled,
      colorPrimary,
      colorSecondary,
      colorInfo,
      colorWarning,
      colorSuccess,
      colorError,
      shadowColor,
      onInfo,
      onWarning,
      onSuccess,
      onError;

  final Color lightBlack,
      violet,
      indigo,
      occur,
      peach,
      skyBlue,
      darkGreen,
      red,
      purple,
      pink,
      brown,
      blue,
      green,
      yellow,
      orange,
      black,
      white;

  final Color iconReminder, iconPayment, iconReport, iconNotification, iconChat;

  CustomTheme({
    this.border = const Color(0xffeeeeee),
    this.borderDark = const Color(0xffe6e6e6),
    this.card = const Color(0xfff0f0f0),
    this.cardDark = const Color(0xfffefefe),
    this.disabledColor = const Color(0xffdcc7ff),
    this.onDisabled = const Color(0xffffffff),
    this.colorPrimary = const Color(0xff6666FF),
    this.colorSecondary = const Color(0xff6666FF),
    this.colorWarning = const Color(0xffffc837),
    this.colorInfo = const Color(0xffff784b),
    this.colorSuccess = const Color(0xff3cd278),
    this.shadowColor = const Color(0xff1f1f1f),
    this.onInfo = const Color(0xffffffff),
    this.onWarning = const Color(0xffffffff),
    this.onSuccess = const Color(0xffffffff),
    this.colorError = const Color(0xfff0323c),
    this.onError = const Color(0xffffffff),

    //Color
    this.lightBlack = const Color(0xffa7a7a7),
    this.indigo = const Color(0xff4B0082),
    this.violet = const Color(0xff9400D3),
    this.occur = const Color(0xffb38220),
    this.peach = const Color(0xffe09c5f),
    this.skyBlue = const Color(0xff639fdc),
    this.darkGreen = const Color(0xff226e79),
    this.red = const Color(0xfff8575e),
    this.purple = const Color(0xff6666FF),
    this.pink = const Color(0xffd17b88),
    this.brown = const Color(0xffbd631a),
    this.blue = const Color(0xff1a71bd),
    this.green = const Color(0xff068425),
    this.yellow = const Color(0xfffff44f),
    this.orange = const Color(0xffFFA500),
    this.black = const Color(0xff000000),
    this.white = const Color(0xffffffff),

    // Icon Color Scheme
    this.iconReminder = const Color(0xffFF0000),
    this.iconPayment = const Color(0xff6d65df),
    this.iconReport = const Color(0xff808080),
    this.iconNotification = const Color(0xffFFA500),
    this.iconChat = const Color(0xff0000FF),
  });

  // Light Theme
  static final CustomTheme lightCustomTheme = CustomTheme(
    card: const Color(0xfff6f6f6),
    cardDark: const Color(0xfff0f0f0),
    disabledColor: const Color(0xff636363),
    onDisabled: const Color(0xffffffff),
    colorInfo: const Color(0xffff784b),
    colorWarning: const Color(0xffffc837),
    colorSuccess: const Color(0xff3cd278),
    shadowColor: const Color(0xffd9d9d9),
    onInfo: const Color(0xffffffff),
    onSuccess: const Color(0xffffffff),
    onWarning: const Color(0xffffffff),
    colorError: const Color(0xfff0323c),
    onError: const Color(0xffffffff),
  );

  // Dark Theme
  static final CustomTheme darkCustomTheme = CustomTheme(
    card: const Color(0xff222327),
    cardDark: const Color(0xff101010),
    border: const Color(0xff303030),
    borderDark: const Color(0xff363636),
    disabledColor: const Color(0xffbababa),
    onDisabled: const Color(0xff000000),
    colorInfo: const Color(0xffff784b),
    colorWarning: const Color(0xffffc837),
    colorSuccess: const Color(0xff3cd278),
    shadowColor: const Color(0xff202020),
    onInfo: const Color(0xffffffff),
    onSuccess: const Color(0xffffffff),
    onWarning: const Color(0xffffffff),
    colorError: const Color(0xfff0323c),
    onError: const Color(0xffffffff),
  );
}
