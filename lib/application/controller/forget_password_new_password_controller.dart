import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/service/api_service.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';
import 'package:pocketkeeper/utils/validators/validator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

import '../../template/state_management/controller.dart';

class FPNewPasswordController extends FxController {
  bool isDataFetched = false, enablePasswordVisibility = false;
  late String email;

  // Form key
  GlobalKey<FormState> formKey = GlobalKey();

  // Text field controller
  late TextEditingController passwordController, confirmPasswordController;

  // Animation
  late TickerProvider ticker;
  late CustomAnimation passwordAnimation, confirmPasswordAnimation;

  FPNewPasswordController({required this.ticker, required this.email}) {
    passwordAnimation = CustomAnimation(ticker: ticker);
    confirmPasswordAnimation = CustomAnimation(ticker: ticker);
  }

  @override
  void initState() {
    super.initState();

    // Initialize controller
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;

    update();
  }

  Future<bool> onSubmitButtonClick() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Variables
    const String filename = "reset_password.php";
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": passwordController.text,
      "process": "change_pass",
    };

    Map<String, dynamic> responseJson = await ApiService.post(
      filename: filename,
      body: requestBody,
    );

    // Store share preferences if is valid user
    if (responseJson["status"] == 200) {
      // Indicate success login
      showToast(customMessage: "Password change successful!");
      return true;
    }
    // Indicate error message
    showToast(customMessage: responseJson["message"]);
    return false;
  }

  void togglePasswordVisibility() {
    enablePasswordVisibility = !enablePasswordVisibility;
    update();
  }

  String? validatePassword(String? value) {
    switch (validatePasswords(password: value, isSetNewPassword: false)) {
      case -1:
        return "Password cannot be empty";
      case -2:
        return "Password must include at least one alphabet, number and special character";
      case -3:
        return "Password length must between 8 and 20";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (!equalString(
      firstString: value,
      secondString: passwordController.text,
    )) {
      return "Password does not match with confirm password";
    }
    return null;
  }

  @override
  String getTag() {
    return "FGNewPasswordController";
  }
}
