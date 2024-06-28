import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/service/expense_service.dart';
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

  // Account box section
  late List<Accounts> walletAccounts;
  Map<int, List<Expenses>> expensesList = {};

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
    currencyIndicator = MemberCache.appSetting.currencyIndicator;

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
      tmpCategoryName: "Food & Drinks",
      tmpIconHex: Icons.fastfood.codePoint,
    );

    // Get top category amount last week
    // TODO
    topCategoryAmountLastWeek = 200.00;

    // Get wallet accounts
    walletAccounts = ExpenseCache.accounts;

    // Get expenses list
    for (final Accounts account in walletAccounts) {
      expensesList[account.id] =
          ExpenseService().getExpensesByAccountId(account.id);

      // Sort expenses by date and sublist
      expensesList[account.id]!.sort((Expenses a, Expenses b) {
        return b.expensesDate.compareTo(a.expensesDate);
      });

      if (expensesList[account.id]!.length > 4) {
        expensesList[account.id] = expensesList[account.id]!.sublist(0, 4);
      }
    }

    isDataFetched = true;
    update();
  }

  @override
  String getTag() {
    return "DashboardController";
  }
}
