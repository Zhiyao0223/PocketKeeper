import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/service/notification_service.dart';

import '../../template/state_management/controller.dart';

class DashboardController extends FxController {
  bool isDataFetched = false;

  int notificationCount = 0;
  String greeting = "Good Morning !";
  String financialStatusMessage = "You are doing great !";

  // Progress Indicator
  late String currencyIndicator;
  late String currentMonthYear;
  late double totalExpenses, remainingBalance, monthlyBudget;
  late List<Map<String, String>> progressIndicatorData;

  // Saving goal section
  late double savingGoalProgress;
  late IconData savingGoalIcon;
  late double revenueLastWeek;
  late Category topCategoryLastWeek;
  late double topCategoryAmountLastWeek;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    // Get total notification count
    notificationCount = NotificationService().getUnreadNotificationCount();

    // Get greeting message and set month year
    final DateTime now = DateTime.now();
    if (now.hour >= 0 && now.hour < 12) {
      greeting = "Good Morning !";
    } else if (now.hour >= 12 && now.hour < 16) {
      greeting = "Good Afternoon !";
    } else {
      greeting = "Good Evening !";
    }

    currentMonthYear = DateFormat('MMMM yyyy').format(now);

    // Get currency indicator
    // TODO
    currencyIndicator = "\$";

    // Get financial status message
    // TODO
    financialStatusMessage = "30% Of Your Expenses, Looks Good.";

    // Get total expenses, remaining balance and monthly budget
    // TODO
    totalExpenses = 1187.40;
    remainingBalance = 312.60;
    monthlyBudget = 1500.00;

    // Get progress indicator data
    // TODO

    // Get saving goal progress
    // TODO
    savingGoalProgress = 0.5;

    // Get saving goal icon
    // TODO
    savingGoalIcon = Icons.account_balance;

    // Get revenue last week
    // TODO
    revenueLastWeek = 1200.00;

    // Get top category last week
    // TODO
    topCategoryLastWeek = Category(
      tmpCategoryId: 1,
      tmpCategoryName: "Food & Drinks",
      tmpIcon: const Icon(Icons.fastfood),
    );

    // Get top category amount last week
    // TODO
    topCategoryAmountLastWeek = 200.00;

    isDataFetched = true;

    update();
  }

  @override
  String getTag() {
    return "DashboardController";
  }
}
