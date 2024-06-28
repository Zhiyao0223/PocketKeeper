import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/service/category_service.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';

import '../../template/state_management/controller.dart';

class FormAddExpensesController extends FxController {
  bool isDataFetched = false;

  int selectedExpensesType = 0; // 0 = Expense, 1 = Income
  List<Category> incomeCategories = [], expenseCategories = [];
  late Category selectedCategory;

  // Form
  late TickerProvider ticker;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController amountController = TextEditingController();

  late CustomAnimation amountAnimation;

  // Contructor
  FormAddExpensesController(this.ticker) {
    amountAnimation = CustomAnimation(ticker: ticker);
  }

  @override
  void initState() {
    super.initState();

    // Fetch data
    fetchData();
  }

  void fetchData() async {
    // Fetch categories
    incomeCategories = CategoryService().getIncomeCategories();
    expenseCategories = CategoryService().getExpenseCategories();

    // Set default selected category
    selectedCategory = (selectedExpensesType == 0)
        ? expenseCategories[0]
        : incomeCategories[0];

    isDataFetched = true;
    update();
  }

  // Validator
  String? validateAmount(String? text) {
    if (text == null || text.trim().isEmpty) {
      return "Amount cannot be empty";
    } else if (RegExp(r'^[0-9]+(\.[0-9]{1,2})?$').hasMatch(text) == false) {
      return "Invalid amount";
    }
    return null;
  }

  @override
  String getTag() {
    return "FormAddExpensesController";
  }
}
