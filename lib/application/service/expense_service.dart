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

  List<Expenses> getExpensesByAccountId(int accountId, {int? month}) {
    if (month == null) {
      return getAllActiveRecords()
          .where((Expenses expense) =>
              expense.account.target!.id == accountId && expense.status == 0)
          .toList();
    }

    return getAllActiveRecords()
        .where((Expenses expense) =>
            expense.account.target!.id == accountId &&
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

  // Get the total expenses in the month
  double getTotalExpensesInMonth(int month) {
    final List<Expenses> expenses = getAllActiveExpenses();
    double totalExpenses = 0.0;

    for (final Expenses expense in expenses) {
      // Only consider expenses in the same month
      if (expense.expensesDate.month != month) {
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
