import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/service/category_service.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';
import 'package:pocketkeeper/utils/validators/string_validator.dart';

import '../../template/state_management/controller.dart';

class FormAddExpensesController extends FxController {
  bool isDataFetched = false;

  int selectedExpensesType = 0; // 0 = Expense, 1 = Income
  List<Category> incomeCategories = [], expenseCategories = [];
  late Category selectedCategory;

  // Form
  late TickerProvider ticker;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController amountController = TextEditingController(text: "0");
  TextEditingController remarkController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  late CustomAnimation remarkAnimation;
  late CustomAnimation dateAnimation;
  late CustomAnimation timeAnimation;

  DateTime selectedDate = DateTime.now();
  XFile? selectedImage;

  // Contructor
  FormAddExpensesController(this.ticker) {
    remarkAnimation = CustomAnimation(ticker: ticker);
    dateAnimation = CustomAnimation(ticker: ticker);
    timeAnimation = CustomAnimation(ticker: ticker);
  }

  @override
  void initState() {
    super.initState();

    // Fetch data
    fetchData();
  }

  void fetchData() async {
    // Initialize date to current date and time
    DateTime now = DateTime.now();
    dateController.text = now.toDateString(dateFormat: "dd EEE, yyyy");
    timeController.text = now.toDateString(dateFormat: "hh:mm a");

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

  void setSelectedDate(DateTime date) {
    selectedDate = DateTime(
      date.year,
      date.month,
      date.day,
      selectedDate.hour,
      selectedDate.minute,
    );

    dateController.text = date.toDateString(dateFormat: "dd EEE, yyyy");
  }

  void setSelectedTime(TimeOfDay time) {
    selectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      time.hour,
      time.minute,
    );

    // Convert to 12 hour format
    timeController.text = TimeOfDay.fromDateTime(selectedDate).format(context);
  }

  void setCategory(Category category) {
    selectedCategory = category;
    categoryController.text = category.categoryName;
  }

  // Validator
  String? validateRemark(String? text) {
    if (validateEmptyString(text)) {
      return "Remark cannot be empty";
    }
    return null;
  }

  String? validateAmount(String? text) {
    if (validateEmptyString(text)) {
      return "Amount cannot be empty";
    } else if (RegExp(r'^[0-9]+(\.[0-9]{1,2})?$').hasMatch(text!) == false) {
      return "Invalid amount";
    }
    return null;
  }

  String? validateDate(String? text) {
    if (validateEmptyString(text)) {
      return "Date cannot be empty";
    }
    return null;
  }

  String? validateTime(String? text) {
    if (validateEmptyString(text)) {
      return "Time cannot be empty";
    }
    return null;
  }

  String? validateCategory(String? text) {
    if (validateEmptyString(text)) {
      return "Category cannot be empty";
    }
    return null;
  }

  // Form submit
  void submitForm() {
    if (formKey.currentState!.validate()) {
      // Save data
      // saveData();
    }
  }

  @override
  String getTag() {
    return "FormAddExpensesController";
  }
}
