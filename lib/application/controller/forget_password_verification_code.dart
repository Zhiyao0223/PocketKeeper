import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/service/api_service.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';
import 'package:pocketkeeper/utils/validators/validator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

import '../../template/state_management/controller.dart';

class FPVerificationCodeController extends FxController {
  bool isDataFetched = false, hasError = false;
  late int verificationCode;

  // Timer
  Timer? _timer;
  int startTimer = 60;

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

    // Start timer
    startTimerCountdown();

    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;

    update();
  }

  void startTimerCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (startTimer == 0) {
        _timer?.cancel();
      } else {
        startTimer--;
      }
      update();
    });
  }

  Future<void> resendVerificationCode() async {
    // Reset timer
    startTimer = 60;
    startTimerCountdown();

    // Generate new verification code
    verificationCode = await getVerificationCode(inputEmail);

    // Show toast
    showToast(
        customMessage: (verificationCode > 999)
            ? "New verification code sent to your email"
            : "Failed to send new verification code");

    update();
  }

  // Get verification code
  Future<int> getVerificationCode(String email) async {
    // Variables
    const String filename = "get_verification_code.php";
    Map<String, dynamic> requestBody = {
      "email": email,
      "process": "get_code",
    };

    Map<String, dynamic> responseJson = await ApiService.post(
      filename: filename,
      body: requestBody,
    );

    // Check if success
    if (responseJson["status"] != 200) {
      // Show toast if email not exist
      if (responseJson["status"] == 501) {
        showToast(customMessage: "Email not exist");
      }
      return -1;
    }

    return responseJson['body']['verification_code'];
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
