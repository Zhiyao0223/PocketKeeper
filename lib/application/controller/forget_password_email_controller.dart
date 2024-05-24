import 'package:flutter/material.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';

import '../../template/state_management/controller.dart';

class FPEmailController extends FxController {
  bool isDataFetched = false;

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

    /// Remove this later ///
    emailController.text = "test@gmail.com";

    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;

    update();
  }

  Future<int> onButtonClick() async {
    // TODO: Implement forget password
    return 1000;
  }

  String? validateEmail(String? value) {
    // TODO: Implement register click
    return null;
  }

  @override
  String getTag() {
    return "FPEmailController";
  }
}
