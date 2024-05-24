import 'package:flutter/material.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';

import '../../template/state_management/controller.dart';

class FPNewPasswordController extends FxController {
  bool isDataFetched = false, enablePasswordVisibility = false;

  // Form key
  GlobalKey<FormState> formKey = GlobalKey();

  // Text field controller
  late TextEditingController passwordController, confirmPasswordController;

  // Animation
  late TickerProvider ticker;
  late CustomAnimation passwordAnimation, confirmPasswordAnimation;

  FPNewPasswordController(this.ticker) {
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

  void onSubmitButtonClick() {
    // TODO: Implement forget password
  }
  void togglePasswordVisibility() {
    enablePasswordVisibility = !enablePasswordVisibility;
    update();
  }

  String? validatePassword(String? value) {
    // TODO: Implement register click
    return null;
  }

  String? validateConfirmPassword(String? value) {
    // TODO: Implement register click
    return null;
  }

  @override
  String getTag() {
    return "FGNewPasswordController";
  }
}
