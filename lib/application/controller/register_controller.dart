import 'package:flutter/material.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';

import '../../template/state_management/controller.dart';

class RegisterController extends FxController {
  bool isDataFetched = false, enablePasswordVisibility = false;

  // Form key
  GlobalKey<FormState> formKey = GlobalKey();

  // Text field controller
  late TextEditingController usernameController,
      emailController,
      passwordController,
      confirmPasswordController;

  // Animation
  late TickerProvider ticker;
  late CustomAnimation userAnimation,
      emailAnimation,
      passwordAnimation,
      confirmPasswordAnimation;

  RegisterController(this.ticker) {
    userAnimation = CustomAnimation(ticker: ticker);
    emailAnimation = CustomAnimation(ticker: ticker);
    passwordAnimation = CustomAnimation(ticker: ticker);
    confirmPasswordAnimation = CustomAnimation(ticker: ticker);
  }

  @override
  void initState() {
    super.initState();

    // Initialize controller
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;

    update();
  }

  // Validatre Username
  String? validateUserName(String? text) {
    if (text == null) {
      return "Username cannot be empty";
    } else {
      if (text.trim().isEmpty) {
        return "Username cannot be empty";
      }
    }

    if (RegExp(r'^(?=(?:.*[a-zA-Z]){6})[a-zA-Z0-9_ -]{6,100}$')
        .hasMatch(text)) {
      return null;
    } else {
      return "Username must be between 6 - 100 alphanumeric characters. With 6 alphabet characters.";
    }
    //return Validator.validateName(text);
  }

  String? validateUsername(String? value) {
    // TODO: Implement register click
    return null;
  }

  String? validateEmail(String? value) {
    // TODO: Implement register click
    return null;
  }

  String? validatePassword(String? value) {
    // TODO: Implement register click
    return null;
  }

  String? validateConfirmPassword(String? value) {
    // TODO: Implement register click
    return null;
  }

  void togglePasswordVisibility() {
    enablePasswordVisibility = !enablePasswordVisibility;
    update();
  }

  void onRegisterClick() {
    // TODO: Implement register click
  }

  @override
  String getTag() {
    return "RegisterController";
  }
}
