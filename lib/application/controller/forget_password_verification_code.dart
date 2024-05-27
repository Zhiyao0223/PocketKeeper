import 'package:flutter/material.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';
import 'package:pocketkeeper/utils/validators/validator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

import '../../template/state_management/controller.dart';

class FPVerificationCodeController extends FxController {
  bool isDataFetched = false, hasError = false;
  late int verificationCode;

  // Form key
  GlobalKey<FormState> formKey = GlobalKey();

  // Text field controller
  late TextEditingController firstCodeController,
      secondCodeController,
      thirdCodeController,
      fourthCodeController;

  // Animation
  late TickerProvider ticker;
  late CustomAnimation firstCodeAnimation,
      secondCodeAnimation,
      thirdCodeAnimation,
      fourthCodeAnimation;

  late String inputEmail;

  FPVerificationCodeController({
    required this.ticker,
    required this.inputEmail,
    required this.verificationCode,
  }) {
    firstCodeAnimation = CustomAnimation(ticker: ticker);
    secondCodeAnimation = CustomAnimation(ticker: ticker);
    thirdCodeAnimation = CustomAnimation(ticker: ticker);
    fourthCodeAnimation = CustomAnimation(ticker: ticker);
  }

  @override
  void initState() {
    super.initState();

    // Initialize controller
    firstCodeController = TextEditingController();
    secondCodeController = TextEditingController();
    thirdCodeController = TextEditingController();
    fourthCodeController = TextEditingController();

    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;

    update();
  }

  Future<bool> onButtonClick() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      hasError = true;
      return false;
    }
    hasError = false;

    // Get verification code
    int inputCode = int.parse(
      firstCodeController.text +
          secondCodeController.text +
          thirdCodeController.text +
          fourthCodeController.text,
    );

    if (verificationCode != inputCode) {
      showToast(customMessage: "Invalid verification code");
      return false;
    }

    return true;
  }

  String? validateCode(String? value) {
    // Check if empty and not numeric
    if (validateEmptyString(value) || !validateIsIntOnly(value ?? "")) {
      hasError = true;
    }

    return null;
  }

  @override
  String getTag() {
    return "FGVerificationCodeController";
  }
}
