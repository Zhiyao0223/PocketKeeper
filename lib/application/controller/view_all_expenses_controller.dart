import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/model/money_account.dart';

import '../../template/state_management/controller.dart';

class ViewAllExpensesController extends FxController {
  TickerProvider vsync;

  bool isDataFetched = false, isShowFilter = false;
  int selectedTabIndex = 0;

  List<Expenses> expenses = [], incomes = [];
  List<DateTime> groupDate = [];
  Map<DateTime, List<Expenses>> groupedData = {};

  // Search bar
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();

  // Tab
  late TabController tabController;

  // Contructor
  ViewAllExpensesController(this.vsync) {
    // Initialize tab controller
    tabController = TabController(length: 2, vsync: vsync);

    // Give expenses sample data
    expenses = [
      Expenses(
        tmpExpensesId: 1,
        tmpCategory: Category(
          tmpCategoryId: 1,
          tmpCategoryName: "Food",
          tmpIcon: Icons.fastfood,
        ),
        tmpAmount: 1000,
        tmpExpensesDate: DateTime(2024, 6, 25),
        tmpDescription: "Lunch",
        tmpAccount: Accounts(
          accountId: 1,
          accountName: "Cash",
          accountIcon: Icons.account_balance_wallet,
        ),
      ),
      Expenses(
        tmpExpensesId: 2,
        tmpCategory: Category(
          tmpCategoryId: 2,
          tmpCategoryName: "Transport",
          tmpIcon: Icons.directions_bus,
        ),
        tmpAmount: 2000,
        tmpExpensesDate: DateTime(2024, 6, 26),
        tmpAccount: Accounts(
          accountId: 2,
          accountName: "Bank",
          accountIcon: Icons.account_balance,
        ),
      ),
      Expenses(
        tmpExpensesId: 3,
        tmpCategory: Category(
          tmpCategoryId: 3,
          tmpCategoryName: "Shopping",
          tmpIcon: Icons.shopping_cart,
        ),
        tmpAmount: 3000,
        tmpExpensesDate: DateTime(2024, 6, 24),
        tmpAccount: Accounts(
          accountId: 3,
          accountName: "Credit Card",
          accountIcon: Icons.credit_card,
        ),
      ),
      Expenses(
        tmpExpensesId: 4,
        tmpCategory: Category(
          tmpCategoryId: 4,
          tmpCategoryName: "Entertainment",
          tmpIcon: Icons.movie,
        ),
        tmpAmount: 4000,
        tmpExpensesDate: DateTime(2023, 12, 25),
        tmpAccount: Accounts(
          accountId: 4,
          accountName: "Cash",
          accountIcon: Icons.account_balance_wallet,
        ),
      ),
      Expenses(
        tmpExpensesId: 5,
        tmpCategory: Category(
          tmpCategoryId: 5,
          tmpCategoryName: "Health",
          tmpIcon: Icons.local_hospital,
        ),
        tmpAmount: 5000,
        tmpExpensesDate: DateTime.now(),
        tmpAccount: Accounts(
          accountId: 5,
          accountName: "Bank",
          accountIcon: Icons.account_balance,
        ),
      ),
      Expenses(
        tmpExpensesId: 6,
        tmpCategory: Category(
          tmpCategoryId: 6,
          tmpCategoryName: "Education",
          tmpIcon: Icons.school,
        ),
        tmpAmount: 6000,
        tmpExpensesDate: DateTime.now(),
        tmpAccount: Accounts(
          accountId: 6,
          accountName: "Credit Card",
          accountIcon: Icons.credit_card,
        ),
      ),
      Expenses(
        tmpExpensesId: 7,
        tmpCategory: Category(
          tmpCategoryId: 7,
          tmpCategoryName: "Others",
          tmpIcon: Icons.category,
        ),
        tmpAmount: 7000,
        tmpExpensesDate: DateTime.now(),
        tmpAccount: Accounts(
          accountId: 7,
          accountName: "Cash",
          accountIcon: Icons.account_balance_wallet,
        ),
      ),
      Expenses(
        tmpExpensesId: 8,
        tmpCategory: Category(
          tmpCategoryId: 8,
          tmpCategoryName: "Salary",
          tmpIcon: Icons.monetization_on,
        ),
        tmpAmount: 8000,
        tmpExpensesDate: DateTime.now(),
        tmpAccount: Accounts(
          accountId: 8,
          accountName: "Bank",
          accountIcon: Icons.account_balance,
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  void dispose() {
    tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void fetchData() async {
    // // Add listener to detect tab changes
    // tabController.addListener(() {
    //   if (tabController.indexIsChanging) {
    //     // This event is fired when the tab is changed by swiping
    //     isIncome = tabController.index == 1;
    //     update();
    //   }
    // });

    // Group expenses by date
    groupedData = {};

    for (dynamic element in expenses) {
      DateTime dateOnly = DateTime(
        element.expensesDate.year,
        element.expensesDate.month,
        element.expensesDate.day,
      );

      if (!groupedData.containsKey(dateOnly)) {
        groupedData[dateOnly] = [];
      }
      groupedData[dateOnly]!.add(element);
    }

    // Sort the groups by date in descending order
    groupedData.keys.toList().sort((a, b) => b.compareTo(a));

    // Convert key to list
    groupDate = groupedData.keys.toList();

    isDataFetched = true;

    update();
  }

  @override
  String getTag() {
    return "ViewAllExpensesController";
  }
}
