import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/model/user.dart';
import 'package:pocketkeeper/application/service/api_service.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';
import 'package:pocketkeeper/utils/validators/custom_validator.dart';
import 'package:pocketkeeper/utils/validators/string_validator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

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

  // Validate Username
  String? validateUsername(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "Username cannot be empty";
    } else if (RegExp(r'^(?=(?:.*[a-zA-Z]){6})[a-zA-Z0-9_ -]{6,100}$')
        .hasMatch(text)) {
      return null;
    } else {
      return "Username must be between 6 - 100 alphanumeric characters. With 6 alphabet characters.";
    }
  }

  String? validateEmail(String? value) {
    return validateEmailAddress(value) ? null : "Invalid email address";
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
    if (equalString(
      firstString: value,
      secondString: passwordController.text,
    )) {
      return "Password does not match with confirm password";
    }
    return null;
  }

  void togglePasswordVisibility() {
    enablePasswordVisibility = !enablePasswordVisibility;
    update();
  }

  // Execute registration process
  Future<bool> onRegisterClick() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Initialize user object
    Users tmpUser = Users(
      tmpName: usernameController.text,
      tmpEmail: emailController.text,
      tmpPassword: passwordController.text,
    );
    // Variables
    const String filename = "register.php";
    Map<String, dynamic> requestBody = {
      "username": tmpUser.name,
      "email": tmpUser.email,
      "password": tmpUser.password,
      "process": "register",
    };

    Map<String, dynamic> responseJson = await ApiService.post(
      filename: filename,
      body: requestBody,
    );

    // Store share preferences if is valid user
    if (responseJson["status"] == 200) {
      // Indicate success login
      showToast(customMessage: "Registration successful!");

      // Store user id for future access
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString(
      //     "user_id", responseJson["body"]["user_id"].toString());

      return true;
    }
    // Indicate error message
    showToast(customMessage: responseJson["message"]);
    return false;
  }

  @override
  String getTag() {
    return "RegisterController";
  }
}
