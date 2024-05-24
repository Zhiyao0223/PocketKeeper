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
