import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/model/expense_goal.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/service/expense_goal_service.dart';
import 'package:pocketkeeper/application/service/expense_service.dart';
import 'package:pocketkeeper/application/service/notification_service.dart';

import '../../template/state_management/controller.dart';

class DashboardController extends FxController {
  bool isDataFetched = false;

  int notificationCount = 0, currentMonth = 1;
  String greeting = "Good Morning !";
  String financialStatusMessage = "You are doing great !";

  ExpenseService expenseService = ExpenseService();

  // Progress Indicator
  late String currencyIndicator;
  late String currentMonthYear;
  late double totalExpenses, remainingBalance, monthlyBudget;
  Map<String, double> progressIndicatorData = {};

  // Saving goal section
  late double savingGoalProgress;
  late IconData savingGoalIcon;
  late double revenueThisMonth;
  late Category topCategoryThisMonth;
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

    currentMonth = 6; // change to now.month
    currentMonthYear = DateFormat('MMMM yyyy').format(now);

    // Get currency indicator
    currencyIndicator = MemberCache.appSetting.currencyIndicator;

    // Get total expenses, remaining balance and monthly budget
    totalExpenses =
        expenseService.getTotalExpensesInMonth(currentMonth, now.year);

    monthlyBudget = MemberCache.appSetting.monthlyLimit;
    remainingBalance = monthlyBudget - totalExpenses;

    // Get financial status message
    if (remainingBalance < 0) {
      financialStatusMessage = "You have exceeded your budget.";
    } else if (remainingBalance < monthlyBudget * 0.3) {
      financialStatusMessage = "You are spending too much.";
    } else if (remainingBalance < monthlyBudget * 0.5) {
      financialStatusMessage = "50% Of Your Expenses, Looks Good.";
    } else if (remainingBalance < monthlyBudget * 0.7) {
      financialStatusMessage = "30% Of Your Expenses, Looks Good.";
    } else {
      financialStatusMessage = "You are doing great !";
    }

    // Get progress indicator data
    progressIndicatorData = expenseService.getCategoryExpensesPercentageInMonth(
        currentMonth, totalExpenses);

    // Get saving goal
    ExpenseGoal savingGoal = ExpenseGoalService().getHighPriorityGoal();
    savingGoalProgress = savingGoal.currentAmount / savingGoal.targetAmount;
    savingGoalIcon = IconData(savingGoal.iconHex, fontFamily: 'MaterialIcons');

    // Get revenue last week
    revenueThisMonth = expenseService.getTotalIncomeInMonth(currentMonth);

    // Get top category this month
    Map<Category, double> topCategoryData =
        expenseService.getTopSpendCategory(currentMonth);

    topCategoryThisMonth = topCategoryData.keys.first;
    topCategoryAmountLastWeek = topCategoryData.values.first;

    // Get wallet accounts
    walletAccounts = ExpenseCache.accounts;

    // Get expenses list
    for (final Accounts account in walletAccounts) {
      expensesList[account.id] =
          expenseService.getExpensesByAccountId(account.id);

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
