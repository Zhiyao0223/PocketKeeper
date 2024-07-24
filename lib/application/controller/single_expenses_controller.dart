import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/service/expense_service.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/utils/custom_function.dart';

import '../../template/state_management/controller.dart';

class SingleExpensesController extends FxController {
  bool isDataFetched = false;

  int selectedExpensesType = 0; // 0 = Expense, 1 = Income
  late Expenses selectedExpense;

  TextEditingController amountController = TextEditingController(text: "0");
  TextEditingController remarkController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController accountController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  XFile? selectedImage;
  double imageAspectRatio = 1;

  SingleExpensesController(this.selectedExpense);

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  void dispose() {
    amountController.dispose();
    remarkController.dispose();
    dateController.dispose();
    timeController.dispose();
    imageController.dispose();
    categoryController.dispose();

    super.dispose();
  }

  void fetchData() async {
    // Recheck selectedExpenseType
    selectedExpensesType = selectedExpense.expensesType;

    // Compare with ExpenseCache to ensure up to date data
    if (selectedExpensesType == 0) {
      if (ExpenseCache.expenses.isNotEmpty) {
        selectedExpense = ExpenseCache.expenses
            .firstWhere((element) => element.id == selectedExpense.id);
      }
    } else {
      if (ExpenseCache.incomes.isNotEmpty) {
        selectedExpense = ExpenseCache.incomes
            .firstWhere((element) => element.id == selectedExpense.id);
      }
    }

    amountController.text = selectedExpense.amount.removeExtraDecimal();
    remarkController.text = selectedExpense.description;
    dateController.text =
        selectedExpense.expensesDate.toDateString(dateFormat: "dd MMM, yyyy");
    timeController.text =
        selectedExpense.expensesDate.toDateString(dateFormat: "hh:mm a");
    categoryController.text = selectedExpense.category.target!.categoryName;
    accountController.text = selectedExpense.account.target!.accountName;

    // Check if image available
    imageController.text = "No receipt attached";
    if (selectedExpense.image != null) {
      loadUint8ListAsXFile(selectedExpense.image!).then((value) {
        selectedImage = value;
        imageController.text = selectedImage!.name;
      });

      imageAspectRatio = await getImageAspectRatio();
    }

    isDataFetched = true;
    update();
  }

  void deleteRecord() {
    // Remove from objectbox
    ExpenseService().delete(selectedExpense.id);

    // Remove from cache
    if (selectedExpensesType == 0) {
      ExpenseCache.expenses
          .removeWhere((element) => element.id == selectedExpense.id);
    } else {
      ExpenseCache.incomes
          .removeWhere((element) => element.id == selectedExpense.id);
    }
  }

  Future<double> getImageAspectRatio() async {
    if (selectedImage == null) {
      return 1;
    }

    var decodedImage =
        await decodeImageFromList(await selectedImage!.readAsBytes());

    return decodedImage.height / decodedImage.width;
  }

  @override
  String getTag() {
    return "SingleExpensesController";
  }
}
