import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/service/account_service.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class ExpenseService extends ObjectboxService<Expenses> {
  ExpenseService() : super(MemberCache.objectBox!.store, Expenses);

  // Get all expenses / income that are not deleted
  List<Expenses> getAllActiveRecords() {
    final List<Expenses> expenses = getAll();
    return expenses.where((Expenses expense) => expense.status == 0).toList();
  }

  List<Expenses> getAllActiveIncomes() {
    final List<Expenses> expenses = getAll();
    return expenses
        .where((Expenses expense) =>
            expense.status == 0 && expense.expensesType == 1)
        .toList();
  }

  List<Expenses> getAllActiveExpenses() {
    final List<Expenses> expenses = getAll();
    return expenses
        .where((Expenses expense) =>
            expense.status == 0 && expense.expensesType == 0)
        .toList();
  }

  List<Expenses> getExpensesByAccountId(String accountName, {int? month}) {
    if (month == null) {
      return getAllActiveRecords()
          .where((Expenses expense) =>
              expense.account.target!.accountName == accountName &&
              expense.status == 0)
          .toList();
      // return getAllActiveRecords()
      //     .where((Expenses expense) =>
      //         expense.account.target!.id == accountId && expense.status == 0)
      //     .toList();
    }

    return getAllActiveRecords()
        .where((Expenses expense) =>
            expense.account.target!.accountName == accountName &&
            expense.status == 0 &&
            expense.expensesDate.month == month)
        .toList();
  }

  // Get the top 1 expenses category in the month
  Map<Category, double> getTopSpendCategory(int month) {
    Map<Category, double> categoryMap = getTotalExpensesByCategory(month);

    if (categoryMap.isEmpty) {
      return categoryMap;
    }

    final List<MapEntry<Category, double>> sortedEntries = categoryMap.entries
        .toList()
      ..sort((MapEntry<Category, double> a, MapEntry<Category, double> b) =>
          b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries.take(1));
  }

  // Get total expenses for each category in the month
  Map<Category, double> getTotalExpensesByCategory(int month) {
    final List<Expenses> expenses = getAllActiveExpenses();
    final Map<Category, double> categoryMap = <Category, double>{};

    for (final Expenses expense in expenses) {
      // Only consider expenses in the same month
      if (expense.expensesDate.month != month) {
        continue;
      }

      final Category category = expense.category.target!;
      if (categoryMap.containsKey(category)) {
        categoryMap[category] = categoryMap[category]! + expense.amount;
      } else {
        categoryMap[category] = expense.amount;
      }
    }

    return categoryMap;
  }

  // Get top 4 + others expenses category in the month (for pie chart)
  Map<Category, double> getTopSpendCategories(int month) {
    Map<Category, double> categoryMap = getTotalExpensesByCategory(month);

    if (categoryMap.isEmpty) {
      return categoryMap;
    }

    final List<MapEntry<Category, double>> sortedEntries = categoryMap.entries
        .toList()
      ..sort((MapEntry<Category, double> a, MapEntry<Category, double> b) =>
          b.value.compareTo(a.value));

    final Map<Category, double> topCategoryMap = <Category, double>{};
    for (final MapEntry<Category, double> entry in sortedEntries.take(4)) {
      topCategoryMap[entry.key] = entry.value;
    }

    // Remaining categories, add them into 'Others'
    double othersTotal = 0.0;
    for (final MapEntry<Category, double> entry in sortedEntries.skip(4)) {
      othersTotal += entry.value;
    }

    // Find "other" category from sorted entries
    Category others = Category(
      tmpCategoryName: "Others",
      tmpIconHex: Icons.settings.codePoint,
      tmpStatus: 0,
      tmpIconColor: Colors.grey,
    );
    topCategoryMap[others] = othersTotal;

    return topCategoryMap;
  }

  // Get total percentage of expenses in the month
  Map<String, double> getCategoryExpensesPercentageInMonth(
      int month, double totalExpenses) {
    Map<Category, double> categoryMap = getTotalExpensesByCategory(month);

    if (categoryMap.isEmpty) {
      return <String, double>{};
    }

    final List<MapEntry<Category, double>> sortedEntries = categoryMap.entries
        .toList()
      ..sort((MapEntry<Category, double> a, MapEntry<Category, double> b) =>
          b.value.compareTo(a.value));

    final Map<String, double> categoryPercentageMap = <String, double>{};
    for (final MapEntry<Category, double> entry in sortedEntries) {
      categoryPercentageMap[entry.key.categoryName] =
          double.parse((entry.value / totalExpenses).toStringAsFixed(2));
    }

    return categoryPercentageMap;
  }

  double getTotalIncomeInWeek(DateTime startDate, DateTime endDate) {
    final List<Expenses> expenses = getAllActiveIncomes();
    double totalIncome = 0.0;

    for (final Expenses expense in expenses) {
      // Only consider expenses in the same week
      if (expense.expensesDate.isBefore(startDate) ||
          expense.expensesDate.isAfter(endDate)) {
        continue;
      }

      totalIncome += expense.amount;
    }

    return totalIncome;
  }

  // Get total income in the month
  double getTotalIncomeInMonth(int month) {
    final List<Expenses> expenses = getAllActiveIncomes();
    double totalIncome = 0.0;

    for (final Expenses expense in expenses) {
      // Only consider expenses in the same month
      if (expense.expensesDate.month != month) {
        continue;
      }

      totalIncome += expense.amount;
    }

    return totalIncome;
  }

  double getTotalIncomeInYear(int year) {
    final List<Expenses> expenses = getAllActiveIncomes();
    double totalIncome = 0.0;

    for (final Expenses expense in expenses) {
      // Only consider expenses in the same year
      if (expense.expensesDate.year != year) {
        continue;
      }

      totalIncome += expense.amount;
    }

    return totalIncome;
  }

  // Get total expenses in the week
  double getTotalExpensesInWeek(DateTime startDate, DateTime endDate) {
    final List<Expenses> expenses = getAllActiveExpenses();
    double totalExpenses = 0.0;

    for (final Expenses expense in expenses) {
      // Only consider expenses in the same week
      if (expense.expensesDate.isBefore(startDate) ||
          expense.expensesDate.isAfter(endDate)) {
        continue;
      }

      totalExpenses += expense.amount;
    }

    return totalExpenses;
  }

  // Get the total expenses in the month
  double getTotalExpensesInMonth(int month, int year) {
    final List<Expenses> expenses = getAllActiveExpenses();
    double totalExpenses = 0.0;

    for (final Expenses expense in expenses) {
      // Only consider expenses in the same month
      if (expense.expensesDate.month != month ||
          expense.expensesDate.year != year) {
        continue;
      }

      totalExpenses += expense.amount;
    }

    return totalExpenses;
  }

  double getTotalExpensesInYear(int year) {
    final List<Expenses> expenses = getAllActiveExpenses();
    double totalExpenses = 0.0;

    for (final Expenses expense in expenses) {
      // Only consider expenses in the same year
      if (expense.expensesDate.year != year) {
        continue;
      }

      totalExpenses += expense.amount;
    }

    return totalExpenses;
  }

  // Get all account balances in the month
  List<double> getAccountBalancesInMonth({int? month}) {
    AccountService accService = AccountService();

    // If null month, use current month
    month ??= DateTime.now().month;

    final List<Expenses> expenses = getAllActiveRecords();

    // Generate list based on account total length
    final List<double> accountBalances = List<double>.filled(
      accService.getAllActiveAccounts().length,
      0.0,
    );

    // Add into account balances based on index
    for (final Expenses expense in expenses) {
      // Only consider expenses in the same month
      if (expense.expensesDate.month != month) {
        continue;
      }

      final int index = accService.getAllActiveAccounts().indexWhere(
          (Accounts account) => account.id == expense.account.target!.id);

      double amount =
          (expense.expensesType == 0) ? expense.amount * -1 : expense.amount;
      accountBalances[index] += amount;
    }

    return accountBalances;
  }

  // Get total records for each category
  Map<String, int> getTotalRecordsByCategory([int? month]) {
    month ??= DateTime.now().month;

    final List<Expenses> expenses = getAllActiveRecords();
    final Map<String, int> categoryMap = <String, int>{};

    for (final Expenses expense in expenses) {
      final Category category = expense.category.target!;

      // Only consider expenses in the same month OR if is income type
      if (expense.expensesDate.month != month || expense.expensesType == 1) {
        continue;
      } else if (categoryMap.containsKey(category.categoryName)) {
        categoryMap[category.categoryName] =
            categoryMap[category.categoryName]! + 1;
      } else {
        categoryMap[category.categoryName] = 1;
      }
    }

    return categoryMap;
  }

  // Get total expenses for each day in specific range
  Map<int, double> getTotalExpensesByDay(DateTime startDate, DateTime endDate) {
    final List<Expenses> expenses = getAllActiveExpenses();
    final Map<int, double> dayMap = <int, double>{};

    for (final Expenses expense in expenses) {
      // Only consider expenses in the same range
      if (expense.expensesDate.isBefore(startDate) ||
          expense.expensesDate.isAfter(endDate)) {
        continue;
      }

      final int day = expense.expensesDate.day;
      if (dayMap.containsKey(day)) {
        dayMap[day] = dayMap[day]! + expense.amount;
      } else {
        dayMap[day] = expense.amount;
      }
    }

    return dayMap;
  }

  // Get total income for each day in specific range
  Map<int, double> getTotalIncomeByDay(DateTime startDate, DateTime endDate) {
    final List<Expenses> expenses = getAllActiveIncomes();
    final Map<int, double> dayMap = <int, double>{};

    for (final Expenses expense in expenses) {
      // Only consider expenses in the same range
      if (expense.expensesDate.isBefore(startDate) ||
          expense.expensesDate.isAfter(endDate)) {
        continue;
      }

      final int day = expense.expensesDate.day;
      if (dayMap.containsKey(day)) {
        dayMap[day] = dayMap[day]! + expense.amount;
      } else {
        dayMap[day] = expense.amount;
      }
    }

    return dayMap;
  }

  // Get total expenses for each month in year
  Map<int, double> getTotalExpensesByMonth(int year) {
    Map<int, double> dayMap = <int, double>{};
    for (int i = 0; i < 12; i++) {
      dayMap[i + 1] = getTotalExpensesInMonth(i + 1, year);
    }

    return dayMap;
  }

  // Get total income for each month in year
  Map<int, double> getTotalIncomeByMonth(int year) {
    Map<int, double> dayMap = <int, double>{};
    for (int i = 0; i < 12; i++) {
      dayMap[i + 1] = getTotalIncomeInMonth(i + 1);
    }

    return dayMap;
  }

  void restoreBackup(Map<String, dynamic> data) {
    if (data['expense'] == null) {
      return;
    }

    final List<Expenses> expenses = data['expense']
        .map<Expenses>((dynamic entity) => Expenses.fromJson(entity))
        .toList();

    putMany(expenses);
  }
}
