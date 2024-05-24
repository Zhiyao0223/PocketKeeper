import 'package:flutter/material.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';

import '../../template/state_management/controller.dart';

class FPVerificationCodeController extends FxController {
  bool isDataFetched = false, enablePasswordVisibility = false;
  late int verificationCode;

  // Form key
  GlobalKey<FormState> formKey = GlobalKey();

  // Text field controller
  late TextEditingController emailController, passwordController;

  // Animation
  late TickerProvider ticker;
  late CustomAnimation emailAnimation, passwordAnimation;

  late String inputEmail;

  FPVerificationCodeController({
    required this.ticker,
    required this.inputEmail,
    required this.verificationCode,
  }) {
    emailAnimation = CustomAnimation(ticker: ticker);
    passwordAnimation = CustomAnimation(ticker: ticker);
  }

  @override
  void initState() {
    super.initState();

    // Initialize controller
    emailController = TextEditingController();
    passwordController = TextEditingController();

    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;

    update();
  }

  Future<bool> onButtonClick() async {
    // TODO: Implement forget password
    return true;
  }

  String? validateCode(String? value) {
    // TODO: Implement register click
    return null;
  }

  @override
  String getTag() {
    return "FGVerificationCodeController";
  }
}
