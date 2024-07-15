import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/template/state_management/controller.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

class DeveloperController extends FxController {
  bool isDataFetched = false;

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
      showToast(
        customMessage: (value) ? "Data cleared" : "Failed to clear data",
      );
      Navigator.of(context).pop();
      update();
    });
  }

  @override
  String getTag() {
    return "DeveloperController";
  }
}
