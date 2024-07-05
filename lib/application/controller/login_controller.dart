import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/user.dart';
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
    emailController = TextEditingController(text: "xiaowu0223@gmail.com");
    passwordController = TextEditingController(text: "test@123");

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

  // Google Sign In
  Future<bool> onGoogleAccountLoginClick() async {
    User? user = await Authentication.signInWithGoogle(context: context);

    if (user != null && user.email != null) {
      // Check for database if user exist, if no auto register user and redirect to home page
      Map<String, dynamic> apiResponse = await checkUserExist(user.email!);

      // If user exist, proceed to store user data and redirect to home page
      if (apiResponse["status"] == 200 && apiResponse["body"] != "-1") {
        MemberCache.appSetting.isGoogleSignIn = true;

        Users tmpuser = Users(
          tmpId: int.parse(apiResponse["body"]["user_id"]),
          tmpName: apiResponse["body"]["username"],
          tmpEmail: apiResponse["body"]["email"],
          tmpStatus: int.parse(apiResponse["body"]["status"]),
          tmpCreatedDate: apiResponse["body"]["created_date"],
          tmpUpdatedDate: apiResponse["body"]["updated_date"],
        );
        await onSuccessLogin(tmpuser);

        return true;
      }

      // If user does not exist, auto register user and redirect to home page
      Users tmpUser = Users(
        tmpName: user.displayName ?? "User",
        tmpEmail: user.email ?? "",
        tmpPassword: "",
      );
      String socialImgUrl = user.photoURL ?? "";

      return await autoRegisterOnFirstSocialLogin(
        tmpUser: tmpUser,
        socialImgUrl: socialImgUrl,
      );
    } else {
      showToast(
        customMessage: "Error occurred using Google Sign In. Try again.",
      );
    }
    return false;
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

  Future<bool> autoRegisterOnFirstSocialLogin({
    required Users tmpUser,
    required String socialImgUrl,
  }) async {
    // Variables
    const String filename = "register.php";
    Map<String, dynamic> requestBody = {
      "username": tmpUser.name,
      "email": tmpUser.email,
      "password": tmpUser.password,
      "image_url": socialImgUrl,
      "process": "social_register",
    };

    Map<String, dynamic> responseJson = await ApiService.post(
      filename: filename,
      body: requestBody,
    );

    // Store share preferences if is valid user
    if (responseJson["status"] == 200) {
      Users tmpuser = Users(
        tmpId: int.parse(responseJson["body"]["user_id"]),
        tmpName: responseJson["body"]["username"],
        tmpEmail: responseJson["body"]["email"],
        tmpStatus: int.parse(responseJson["body"]["status"]),
        tmpCreatedDate: responseJson["body"]["created_date"],
        tmpUpdatedDate: responseJson["body"]["updated_date"],
      );

      await onSuccessLogin(tmpuser);

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

  /*
  Access API to validate credential
  */
  Future<bool> validateCredential({
    required String email,
    required String password,
  }) async {
    // Variables
    try {
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
        Users tmpuser = Users(
          tmpId: int.parse(responseJson["body"]["user_id"]),
          tmpName: responseJson["body"]["username"],
          tmpEmail: responseJson["body"]["email"],
          tmpStatus: int.parse(responseJson["body"]["status"]),
          tmpCreatedDate: responseJson["body"]["created_date"],
          tmpUpdatedDate: responseJson["body"]["updated_date"],
        );

        await onSuccessLogin(tmpuser);

        return true;
      }
    } on SocketException catch (e) {
      log(e.toString());
      showToast(customMessage: "No internet connection.");
    } on HttpException catch (e) {
      log(e.toString());
      showToast(customMessage: "Unknown Error occurred.");
    } on FormatException catch (e) {
      log(e.toString());
      showToast(customMessage: "Technical Error occurred.");
    } catch (e) {
      showToast(customMessage: "Unknown Error occurred.");
    }

    return false;
  }

  Future<void> onSuccessLogin(Users user) async {
    // Indicate success login
    showToast(customMessage: "Login successful!");

    // Store user id for future access
    MemberCache.user = user;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_id", user.id.toString());
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
