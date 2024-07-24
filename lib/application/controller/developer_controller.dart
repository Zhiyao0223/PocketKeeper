import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/service/local_notification_service.dart';
import 'package:pocketkeeper/application/view/login_screen.dart';
import 'package:pocketkeeper/template/state_management/controller.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

class DeveloperController extends FxController {
  bool isDataFetched = false;

  LocalNotificationService localNotificationService =
      LocalNotificationService();

  // Constructor
  DeveloperController();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;
    update();
  }

  void getDummyData() {
    MemberCache.objectBox!.generateDummyData();
    showToast(customMessage: "Dummy data generated");
    update();
  }

  void clearData() {
    MemberCache.objectBox!.resetDatabase().then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    });
  }

  @override
  String getTag() {
    return "DeveloperController";
  }
}
