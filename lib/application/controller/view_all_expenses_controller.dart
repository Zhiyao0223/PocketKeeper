import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense.dart';

import '../../template/state_management/controller.dart';

class ViewAllExpensesController extends FxController {
  bool isDataFetched = false, isShowFilter = false, isShowClearButton = false;
  int selectedTabIndex = 0;

  List<Expenses> records = [], filteredData = [];
  List<DateTime> groupDate = [];
  List<Category> categories = [], selectedCategory = [];
  Map<DateTime, double> totalAmount = {};
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
  }

  @override
  void dispose() {
    clearFilter();
    searchController.dispose();
    super.dispose();
  }

  // Fetch require data from cache
  void fetchData() {
    clearFilter();

    // Get category names from objectbox
    categories = (selectedTabIndex == 0)
        ? ExpenseCache.expenseCategories
        : ExpenseCache.incomeCategories;

    records = (selectedTabIndex == 0)
        ? [...ExpenseCache.expenses]
        : [...ExpenseCache.incomes];

    filterData();
  }

  // Reset filter
  void clearFilter() {
    searchQuery = "";
    isShowFilter = false;
    selectedCategory.clear();
    searchController.clear();
  }

  // Filter data based on search query and categories
  void filterData() {
    // Reset filtered data to same with records
    filteredData = [...records];

    // Filter data based on search query
    if (searchQuery.isNotEmpty) {
      // Remove not matching records
      filteredData.removeWhere((record) => !record.description
          .toLowerCase()
          .contains(searchQuery.toLowerCase()));
    }

    // Filter based on category
    if (selectedCategory.isNotEmpty) {
      // Remove element from filtered list if not in selected category (Check by name)
      filteredData.removeWhere((expense) {
        // Compare name
        return !selectedCategory.any((category) =>
            category.categoryName == expense.category.target!.categoryName);
      });
    }

    // Perform grouping and sorting
    _groupAndSortData();
  }

  // Group data based on date and sort them based on time
  void _groupAndSortData() async {
    groupedData.clear();
    totalAmount.clear();

    for (Expenses element in filteredData) {
      DateTime dateOnly = DateTime(
        element.expensesDate.year,
        element.expensesDate.month,
        element.expensesDate.day,
      );

      if (!groupedData.containsKey(dateOnly)) {
        groupedData[dateOnly] = [];
        totalAmount[dateOnly] = 0; // Initialize total expense and income
      }

      groupedData[dateOnly]!.add(element);

      // Calculate totals
      totalAmount[dateOnly] = totalAmount[dateOnly]! + element.amount;
    }

    // Convert keys to list and sort by date in descending order
    groupDate = groupedData.keys.toList()..sort((a, b) => b.compareTo(a));

    // Sort elements in each group by time in descending order
    for (DateTime date in groupDate) {
      groupedData[date]!
          .sort((a, b) => b.expensesDate.compareTo(a.expensesDate));
    }

    isDataFetched = true;
    update();
  }

  @override
  String getTag() {
    return "ViewAllExpensesController";
  }
}
