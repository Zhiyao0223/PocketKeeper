import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/service/api_service.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';
import 'package:pocketkeeper/utils/validators/custom_validator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

import '../../template/state_management/controller.dart';

class FPEmailController extends FxController {
  bool isDataFetched = false;

  // Form key
  GlobalKey<FormState> formKey = GlobalKey();

  // Text field controller
  late TextEditingController emailController;

  // Animation
  late TickerProvider ticker;
  late CustomAnimation emailAnimation;

  FPEmailController(this.ticker) {
    emailAnimation = CustomAnimation(ticker: ticker);
  }

  @override
  void initState() {
    super.initState();

    // Initialize controller
    emailController = TextEditingController();

    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;

    update();
  }

  // Validate email and get verification code from backend
  Future<int> onButtonClick() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return -1;
    }

    return await getVerificationCode(emailController.text);
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

  String? validateEmail(String? value) {
    return validateEmailAddress(value) ? null : "Invalid email address";
  }

  @override
  String getTag() {
    return "FPEmailController";
  }
}
