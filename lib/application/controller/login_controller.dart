import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/service/api_service.dart';
import 'package:pocketkeeper/application/service/authentication.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';
import 'package:pocketkeeper/utils/validators/custom_validator.dart';
import 'package:pocketkeeper/utils/validators/string_validator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void fetchData() async {
    isDataFetched = true;

    update();
  }

  Future<bool> onLoginButtonClick() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return false;
    }

    return await validateCredential(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  // TODO
  Future<List<String>> onGoogleAccountLoginClick() async {
    User? user = await Authentication.signInWithGoogle(context: context);

    if (user != null && user.email != null) {
      // Check for database if user exist, if no go register page with prefilled data
      Map<String, dynamic> apiResponse = await checkUserExist(user.email!);
      if (apiResponse["status"] == 200) {
        return ["0"];
      }
    } else {
      showToast(
        customMessage: "Error occurred using Google Sign In. Try again.",
      );
    }
    return ["-1"];
  }

  Future<Map<String, dynamic>> checkUserExist(String tmpEmail) async {
    // Variables
    const String filename = "check_registered_email.php";
    Map<String, dynamic> requestBody = {
      "email": tmpEmail,
      "process": "check_user_exist",
    };

    Map<String, dynamic> responseJson = await ApiService.post(
      filename: filename,
      body: requestBody,
    );

    return responseJson;
  }

  void togglePasswordVisibility() {
    enablePasswordVisibility = !enablePasswordVisibility;
    update();
  }

  /*
  Access API to validate credential
  */
  Future<bool> validateCredential({
    required String email,
    required String password,
  }) async {
    // Variables
    const String filename = "login.php";
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "process": "login",
    };

    Map<String, dynamic> responseJson = await ApiService.post(
      filename: filename,
      body: requestBody,
    );

    // Store share preferences if is valid user
    if (responseJson["status"] == 200) {
      // Indicate success login
      showToast(customMessage: "Login successful!");

      // Store user id for future access
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_id", responseJson["body"]["user_id"]);

      return true;
    }

    return false;
  }

  //
  // Validation
  //

  String? validateEmail(String? value) {
    return validateEmailAddress(value) ? null : "Invalid email address";
  }

  String? validatePassword(String? value) {
    return validateEmptyString(value) ? "Please enter password" : null;
  }

  @override
  String getTag() {
    return "LoginController";
  }
}
