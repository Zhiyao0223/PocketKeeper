import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense_limit.dart';
import 'package:pocketkeeper/application/service/expense_limit_service.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/utils/custom_function.dart';
import 'package:pocketkeeper/utils/validators/string_validator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

import '../../../template/state_management/controller.dart';

class LimitController extends FxController {
  bool isDataFetched = false;

  late int remainingDays;
  double availableBalance = 0,
      totalSpent = 0,
      totalBudget = 0,
      chartProgress = 0,
      budgetAvailableForAllocation = 0,
      suggestedAmount = 0;

  List<Category> expenseCategories = [];
  List<ExpenseLimit> expenseLimits = [];

  // First value is total limit, second is total spent
  Map<int, Map<double, double>> categoryLimitsAndTotalSpent = {};

  // Form
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Category selectedCategory;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    // Reset values
    totalSpent = 0;
    totalBudget = 0;
    chartProgress = 0;
    budgetAvailableForAllocation = 0;
    categoryLimitsAndTotalSpent = {};

    expenseLimits = ExpenseCache.expenseLimits;

    expenseCategories = ExpenseCache.expenseCategories;
    selectedCategory = ExpenseCache.expenseCategories.first;
    updateSuggestion();

    categoryLimitsAndTotalSpent =
        ExpenseLimitService().getCategoryLimitsAndBalance();

    for (var value in categoryLimitsAndTotalSpent.values) {
      totalBudget += value.keys.first;
      availableBalance += value.values.first;
      totalSpent += value.keys.first - value.values.first;
    }

    remainingDays = getRemainingDayUntilNextMonth();
    chartProgress = totalSpent / totalBudget;
    budgetAvailableForAllocation =
        MemberCache.appSetting.monthlyLimit - totalBudget;

    // Give initial value to text controller
    amountController.text = "0";
    categoryNameController.text = selectedCategory.categoryName;

    isDataFetched = true;
    update();
  }

  String getTotalBudget() {
    return customFormatNumber(totalBudget.toInt());
  }

  String getTotalSpent() {
    return customFormatNumber(totalSpent.toInt());
  }

  /*
  Format number to k, M
  1000 => 1k
  1000000 => 1M
  */
  String customFormatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).removeExtraDecimal()} M';
    } else if (number >= 1000) {
      return '${(number / 1000).removeExtraDecimal()} K';
    } else {
      return number.toString();
    }
  }

  double convertToNumericPercentage(double number) {
    return (number >= 1) ? number / 100 : number;
  }

  String? validateAmount(String? value) {
    if (validateEmptyString(value)) {
      return "Please enter amount";
    }

    if (double.parse(value!) <= 0) {
      return "Amount must be greater than 0";
    }

    return null;
  }

  // Check new created budget if already exist (Compare category)
  bool checkIfCategoryAlreadyExist(bool isNewCreated) {
    return expenseLimits.any(
            (element) => element.category.targetId == selectedCategory.id) &&
        isNewCreated;
  }

  void createBudget(bool isEditing) {
    // Validate form
    if (!formKey.currentState!.validate() ||
        checkIfCategoryAlreadyExist(!isEditing)) {
      return;
    } else if (isEditing) {
      updateBudget();
      return;
    }

    // Create new budget
    ExpenseLimit newLimit = ExpenseLimit(
      tmpAmount: double.parse(amountController.text),
    );
    newLimit.category.target = selectedCategory;

    // Save to cache
    ExpenseCache.expenseLimits.add(newLimit);

    // Save to objectbox
    ExpenseLimitService().put(newLimit);

    showToast(customMessage: "Budget created successfully");
    fetchData();
  }

  void updateBudget() {
    // Get from cache
    ExpenseLimit selectedLimit = expenseLimits.firstWhere(
        (element) => element.category.targetId == selectedCategory.id);

    // Update from cache
    selectedLimit.amount = double.parse(amountController.text);
    ExpenseCache.expenseLimits
        .firstWhere((element) => element.id == selectedLimit.id)
        .amount = selectedLimit.amount;

    // Update from objectbox
    ExpenseLimitService().put(selectedLimit);

    showToast(customMessage: "Budget updated successfully");
    fetchData();
  }

  void deleteBudget(ExpenseLimit selectedLimit) {
    // Delete from cache
    ExpenseCache.expenseLimits
        .removeWhere((element) => element.id == selectedLimit.id);

    // Delete from objectbox
    ExpenseLimitService().delete(selectedLimit.id);

    showToast(customMessage: "Budget deleted successfully");
    fetchData();
  }

  void updateSuggestion() {
    switch (selectedCategory.categoryName) {
      case "Food":
        suggestedAmount = MemberCache.appSetting.monthlyLimit * 0.3;
        break;
      case "Grocery":
        suggestedAmount = MemberCache.appSetting.monthlyLimit * 0.15;
        break;
      case "Transport":
        suggestedAmount = MemberCache.appSetting.monthlyLimit * 0.1;
        break;
      case "Entertainment":
        suggestedAmount = MemberCache.appSetting.monthlyLimit * 0.2;
        break;
      case "Health":
        suggestedAmount = MemberCache.appSetting.monthlyLimit * 0.1;
        break;
      case "Education":
        suggestedAmount = MemberCache.appSetting.monthlyLimit * 0.05;
        break;
      case "Others":
        suggestedAmount = MemberCache.appSetting.monthlyLimit * 0.1;
        break;
      default:
        suggestedAmount = MemberCache.appSetting.monthlyLimit * 0.1;
    }
  }

  @override
  String getTag() {
    return "LimitController";
  }
}
