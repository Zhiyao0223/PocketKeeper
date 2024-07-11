import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/model/expense_goal.dart';
import 'package:pocketkeeper/application/service/expense_goal_service.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/utils/converters/string.dart';
import 'package:pocketkeeper/utils/validators/custom_validator.dart';
import 'package:pocketkeeper/utils/validators/string_validator.dart';

import '../../../template/state_management/controller.dart';

class AddGoalController extends FxController {
  bool isDataFetched = false;

  ExpenseGoal? selectedGoal;
  DateTime selectedDate = DateTime.now();

  // Form
  TextEditingController goalNameController = TextEditingController();
  TextEditingController targetAmountController = TextEditingController();
  TextEditingController targetDateController = TextEditingController();
  TextEditingController suggestedAmountController = TextEditingController();
  int selectedIconHex = Icons.account_balance_wallet.codePoint;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AddGoalController(this.selectedGoal);

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  void dispose() {
    goalNameController.dispose();
    super.dispose();
  }

  void fetchData() async {
    if (selectedGoal != null) {
      goalNameController.text = selectedGoal!.description;
      targetAmountController.text =
          selectedGoal!.targetAmount.removeExtraDecimal();
      suggestedAmountController.text =
          selectedGoal!.suggestedAmount.removeExtraDecimal();

      selectedIconHex = selectedGoal!.iconHex;
      selectedDate = selectedGoal?.dueDate ?? DateTime.now();
      targetDateController.text =
          selectedDate.toDateString(dateFormat: "dd MMM, yyyy");
    }

    isDataFetched = true;
    update();
  }

  String? validateGoalName(String? value) {
    if (validateEmptyString(value)) {
      return "Goal name is required";
    } else if (ExpenseGoalService().isGoalNameExist(value!) &&
        selectedGoal == null) {
      return "Goal name already exist";
    }
    return null;
  }

  String? validateTargetAmount(String? value) {
    if (validateEmptyString(value)) {
      return "Target amount is required";
    } else if (!validateDouble(value!)) {
      return "Invalid target amount";
    }
    return null;
  }

  String? validateSuggestedAmount(String? value) {
    if (validateEmptyString(value)) {
      return null;
    } else if (!validateDouble(value!)) {
      return "Invalid suggested amount";
    }
    return null;
  }

  String? validateTargetDate(String? value) {
    // Allow empty as it is optional
    if (validateEmptyString(value)) {
      return null;
    }

    // Convert Datetime
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime? tmpDatetime = value!.tryParseDateTime("dd MMM, yyyy");

    if (tmpDatetime == null) {
      return "Invalid date";
    } else if (tmpDatetime.isBefore(today)) {
      return "Date must be in the future";
    }
    return null;
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    targetDateController.text =
        selectedDate.toDateString(dateFormat: "dd MMM, yyyy");
  }

  Future<bool> submitGoal() async {
    if (formKey.currentState!.validate()) {
      if (selectedGoal != null) {
        // Update account
        selectedGoal!.description = goalNameController.text;
        selectedGoal!.dueDate = selectedDate;
        selectedGoal!.iconHex = selectedIconHex;

        selectedGoal!.targetAmount =
            double.tryParse(targetAmountController.text) ?? 0;
        selectedGoal!.suggestedAmount =
            double.tryParse(suggestedAmountController.text) ?? 0;

        // Update cache
        ExpenseCache.expenseGoals
            .firstWhere((element) => element.goalId == selectedGoal!.goalId)
          ..description = selectedGoal!.description
          ..targetAmount = selectedGoal!.targetAmount
          ..dueDate = selectedGoal!.dueDate
          ..suggestedAmount = selectedGoal!.suggestedAmount
          ..iconHex = selectedGoal!.iconHex;
      } else {
        // Add new account
        selectedGoal = ExpenseGoal(
          tmpDescription: goalNameController.text,
          tmpIconHex: selectedIconHex,
          tmpTargetAmount: double.tryParse(targetAmountController.text) ?? 0,
          tmpSuggestedAmount:
              double.tryParse(suggestedAmountController.text) ?? 0,
          dueDate: selectedDate,
        );

        // Add to cache
        ExpenseCache.expenseGoals.add(selectedGoal!);
      }

      // Update database
      ExpenseGoalService().put(selectedGoal!);
      return true;
    }
    return false;
  }

  @override
  String getTag() {
    return "AddGoalController";
  }
}
