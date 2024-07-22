import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/user.dart';
import 'package:pocketkeeper/application/service/api_service.dart';
import 'package:pocketkeeper/application/service/user_service.dart';
import 'package:pocketkeeper/template/state_management/controller.dart';
import 'package:pocketkeeper/utils/validators/custom_validator.dart';
import 'package:pocketkeeper/utils/validators/string_validator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSettingFormController extends FxController {
  bool isDataFetched = false;

  /*
  Type
  1: Username
  2: Password
  3: Discord
  */
  late int selectedType;

  late Users currentUser;
  String appbarTitle = "Profile";

  // Form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Constructor
  ProfileSettingFormController(this.selectedType);

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void fetchData() async {
    currentUser = MemberCache.user!;

    switch (selectedType) {
      case 0:
        appbarTitle = "Change Username";
        break;
      case 1:
        appbarTitle = "Change Password";
        break;
      case 2:
        appbarTitle = "Link / Unlink Discord";
    }

    // Set default value
    nameController.text = currentUser.name;

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
      return "Username length must between 6-100.";
    }
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
      return "Passwords do not match";
    }
    return null;
  }

  Future<bool> submitChange() async {
    if (formKey.currentState!.validate()) {
      String key = "", value = "";

      switch (selectedType) {
        case 0:
          key = "username";
          value = nameController.text;
          currentUser.name = value;
          break;
        case 1:
          key = "password";
          value = passwordController.text;
          currentUser.password = value;
          break;
        default:
          return false;
      }

      MemberCache.user = currentUser;

      // Update objectbox
      UserService().updateLoginUser(currentUser);

      // Update db
      updateDatabase(key: key, value: value);
      return true;
    }
    return false;
  }

  Future<void> updateDatabase({
    required String key,
    required String value,
  }) async {
    // Prevent internet connection error
    try {
      const String filename = "update_profile_detail.php";
      Map<String, dynamic> requestBody = {
        "email": currentUser.email,
        "process": "update_profile",
        "key": key,
        "value": value,
      };

      Map<String, dynamic> responseJson = await ApiService.post(
        filename: filename,
        body: requestBody,
      );

      // Store share preferences if is valid user
      if (responseJson["status"] == 200) {
        log("Update profile successful!");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<int> linkDiscord() async {
    bool linkStatus = currentUser.discordId.isNotEmpty;

    // Prevent internet connection error
    try {
      const String filename = "link_discord.php";
      Map<String, dynamic> requestBody = {
        "email": currentUser.email,
        "process": (linkStatus) ? "unlink_discord" : "link_discord",
      };

      Map<String, dynamic> responseJson = await ApiService.post(
        filename: filename,
        body: requestBody,
      );

      // Store share preferences if is valid user
      if (responseJson["status"] == 200) {
        log("Link / unlink discord successful! Code: ${responseJson['body']['code']}");
        return responseJson['body']["code"];
      }
    } catch (e) {
      log(e.toString());
    }
    return -1;
  }

  Future<void> redirectDiscord() async {
    // DM bot
    // final Uri url = Uri.https('discord.com', '/users/$discordBotUID');

    // Invite bot to server
    final Uri url = Uri.parse(
        'https://discord.com/oauth2/authorize?client_id=1263008779000352829&permissions=8&integration_type=0&scope=bot');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // Handle the error
        showToast(customMessage: "Could not launch Discord URL");
      }
    } catch (e) {
      // Handle any exceptions
      log('Error launching URL: $e');
      showToast(
        customMessage: "Unknown error occured. Please manually open Discord.",
      );
    }
  }

  @override
  String getTag() {
    return "ProfileSettingFormController";
  }
}
