import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/service/category_service.dart';
import 'package:pocketkeeper/application/service/expense_service.dart';

import '../../template/state_management/controller.dart';

class ViewAllExpensesController extends FxController {
  bool isDataFetched = false, isShowFilter = false;
  int selectedTabIndex = 0;

  List<Expenses> expenses = [], filteredExpenses = [], filteredIncomes = [];
  List<DateTime> groupDate = [];
  List<String> categoryNames = [], selectedCategory = [];
  Map<DateTime, List<double>> totalAmount = {};
  Map<DateTime, List<Expenses>> groupedData = {};

  // Search bar
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();

  // Contructor
  ViewAllExpensesController();

  @override
  void initState() {
    super.initState();

    // Fetch data
    fetchData();

    clearFilter();
  }

  void fetchData() {
    // Get category names from objectbox
    if (selectedTabIndex == 0) {
      categoryNames = CategoryService()
          .getExpenseCategories()
          .map((e) => e.categoryName)
          .toSet()
          .toList();
    } else {
      categoryNames = CategoryService()
          .getIncomeCategories()
          .map((e) => e.categoryName)
          .toSet()
          .toList();
    }

    // Fetch expenses from objectbox
    expenses = ExpenseService().getExpenses();
  }

  @override
  void dispose() {
    clearFilter();
    searchController.dispose();
    super.dispose();
  }

  void groupAndSortData() async {
    // Reinitialize variables based on filter
    List<Expenses> tempExpenses = (selectedTabIndex == 0)
        ? filteredExpenses.isNotEmpty
            ? filteredExpenses
            : expenses.where((element) => element.expensesType == 0).toList()
        : filteredIncomes.isNotEmpty
            ? filteredIncomes
            : expenses.where((element) => element.expensesType == 1).toList();

    // Group expenses by date
    groupedData = {};

    for (Expenses element in tempExpenses) {
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

    // Calculate total amount for each group
    totalAmount = {};
    for (DateTime date in groupDate) {
      double tmpTotalExpense = 0, tmpTotalIncome = 0;
      for (Expenses element in groupedData[date]!) {
        if (element.expensesType == 0) {
          tmpTotalExpense += element.amount;
        } else {
          tmpTotalIncome += element.amount;
        }
      }
      totalAmount[date] = [tmpTotalExpense, tmpTotalIncome];
    }

    isDataFetched = true;

    update();
  }

  void filterData() {
    // Clear cache
    filteredExpenses.clear();
    filteredIncomes.clear();

    // Filter data based on search query
    if (searchQuery.isNotEmpty) {
      for (Expenses element in expenses) {
        if (element.description
            .toLowerCase()
            .contains(searchQuery.toLowerCase())) {
          if (element.expensesType == 0) {
            filteredExpenses.add(element);
          } else {
            filteredIncomes.add(element);
          }
        }
      }
    }

    // Filter based on category
    if (selectedCategory.isNotEmpty) {
      // Check if filter search
      if (filteredExpenses.isNotEmpty || filteredIncomes.isNotEmpty) {
        // Remove element from filtered list if not in selected category
        filteredExpenses.removeWhere((element) =>
            !selectedCategory.contains(element.category.categoryName));
        filteredIncomes.removeWhere((element) =>
            !selectedCategory.contains(element.category.categoryName));
      }
      // Loop over expenses and add to filtered list if in selected category
      else {
        for (Expenses element in expenses) {
          if (selectedCategory.contains(element.category.categoryName)) {
            if (element.expensesType == 0) {
              filteredExpenses.add(element);
            } else {
              filteredIncomes.add(element);
            }
          }
        }
      }
    }

    // Perform grouping and sorting
    groupAndSortData();
  }

  // Reset filter
  void clearFilter() {
    searchQuery = "";
    searchController.clear();
    isShowFilter = false;
    selectedCategory.clear();

    filterData();
  }

  @override
  String getTag() {
    return "ViewAllExpensesController";
  }
}
