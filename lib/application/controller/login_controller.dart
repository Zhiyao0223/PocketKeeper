import 'package:flutter/material.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';

import '../../template/state_management/controller.dart';

class LoginController extends FxController {
  bool isDataFetched = false, enablePasswordVisibility = false;

  // Form key
  GlobalKey<FormState> formKey = GlobalKey();

  // Text field controller
  late TextEditingController emailController, passwordController;

  // Animation
  late TickerProvider ticker;
  late CustomAnimation emailAnimation, passwordAnimation;

  LoginController(this.ticker) {
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

  void onForgetPasswordClick() {
    // TODO: Implement forget password
  }

  Future<bool> onLoginButtonClick() async {
    // TODO: Implement login button submit
    return true;
  }

  void onGoogleAccountLoginClick() {
    // TODO: Implement google account login
  }

  String? validateEmail(String? value) {
    // TODO: Implement register click
    return null;
  }

  void togglePasswordVisibility() {}

  String? validatePassword(String? value) {
    // TODO: Implement register click
    return null;
  }

  @override
  String getTag() {
    return "LoginController";
  }
}
