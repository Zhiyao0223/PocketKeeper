import 'package:flutter/material.dart';

import '../../template/state_management/controller.dart';

class OtherController extends FxController {
  bool isDataFetched = false;

  Map<String, Map<String, int>> categoriesHexColorData = {
    "Goals": {
      "color": Colors.teal.value,
      "categoryCode": Icons.star.codePoint,
    },
    "Limits": {
      "color": Colors.orange.value,
      "categoryCode": Icons.warning.codePoint,
    },
    // "Bills": {
    //   "color": Colors.lightBlue.value,
    //   "categoryCode": Icons.money.codePoint,
    // },
    "Accounts": {
      "color": Colors.purple.value,
      "categoryCode": Icons.account_balance.codePoint,
    },
  };

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;

    update();
  }

  @override
  String getTag() {
    return "OtherController";
  }
}
