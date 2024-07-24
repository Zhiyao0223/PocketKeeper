import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/service/account_service.dart';
import 'package:pocketkeeper/application/service/category_service.dart';
import 'package:pocketkeeper/application/service/expense_service.dart';
import 'package:pocketkeeper/application/service/gemini_service.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';
import 'package:pocketkeeper/utils/custom_function.dart';
import 'package:pocketkeeper/utils/validators/string_validator.dart';

import '../../template/state_management/controller.dart';

class FormAddExpensesController extends FxController {
  bool isDataFetched = false, isEditing = false, isFromOCR = false;

  // Disable this to prevent overuse API
  bool isGeminiEnable = false;

  int selectedExpensesType = 0; // 0 = Expense, 1 = Income
  List<Accounts> accounts = [];
  late Accounts selectedAccount;

  List<Category> incomeCategories = [], expenseCategories = [];
  late Category selectedCategory;
  Expenses? selectedExpenseForEdit;

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

  late GeminiService geminiService;

  // Contructor
  FormAddExpensesController(
    this.ticker, {
    this.selectedExpenseForEdit,
    this.isFromOCR = false,
  }) {
    remarkAnimation = CustomAnimation(ticker: ticker);
    dateAnimation = CustomAnimation(ticker: ticker);
    timeAnimation = CustomAnimation(ticker: ticker);

    if (selectedExpenseForEdit != null && !isFromOCR) isEditing = true;
  }

  @override
  void initState() {
    super.initState();

    geminiService = GeminiService(false);
    isGeminiEnable = MemberCache.isGeminiTunedModelEnable;

    // Fetch data
    fetchData();
  }

  void fetchData() async {
    // Fetch accounts
    accounts = AccountService().getAllActiveAccounts();
    selectedAccount = accounts[0];

    // Fetch categories
    incomeCategories = CategoryService().getIncomeCategories();
    expenseCategories = CategoryService().getExpenseCategories();

    // If editing data
    if (isEditing) {
      Expenses tmpExpense = selectedExpenseForEdit!;

      amountController.text = tmpExpense.amount.removeExtraDecimal();
      remarkController.text = tmpExpense.description;

      selectedDate = tmpExpense.expensesDate;
      dateController.text =
          tmpExpense.expensesDate.toDateString(dateFormat: "dd MMM, yyyy");

      // Convert to 12 hour format
      timeController.text =
          tmpExpense.expensesDate.toDateString(dateFormat: "hh:mm a");

      selectedExpensesType = tmpExpense.expensesType;

      // Set category
      selectedCategory = tmpExpense.category.target!;
      categoryController.text = tmpExpense.category.target!.categoryName;

      // Set image
      if (tmpExpense.image != null) {
        selectedImage = await loadUint8ListAsXFile(tmpExpense.image!);
        imageController.text = selectedImage!.name;
      }
    }
    // If from OCR
    else if (isFromOCR) {
      // Set image
      selectedImage =
          await loadUint8ListAsXFile(selectedExpenseForEdit!.image!);
      imageController.text = selectedImage!.name;

      // Set amount
      amountController.text =
          selectedExpenseForEdit!.amount.removeExtraDecimal();

      // Set remark
      remarkController.text = selectedExpenseForEdit!.description;

      // Set date
      selectedDate = selectedExpenseForEdit!.expensesDate;
      dateController.text = selectedExpenseForEdit!.expensesDate
          .toDateString(dateFormat: "dd MMM, yyyy");

      // Set time
      timeController.text = selectedExpenseForEdit!.expensesDate
          .toDateString(dateFormat: "hh:mm a");

      // Auto detect category from remark
      autoDetectCategory();

      // Set default selected category
      selectedCategory = (selectedExpensesType == 0)
          ? expenseCategories[0]
          : incomeCategories[0];
      categoryController.text = selectedCategory.categoryName;
    } else {
      // Initialize date to current date and time
      DateTime now = DateTime.now();
      dateController.text = now.toDateString(dateFormat: "dd MMM, yyyy");
      timeController.text = now.toDateString(dateFormat: "hh:mm a");

      // Set default selected category
      selectedCategory = (selectedExpensesType == 0)
          ? expenseCategories[0]
          : incomeCategories[0];
      categoryController.text = selectedCategory.categoryName;
    }

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

    dateController.text = date.toDateString(dateFormat: "dd MMM, yyyy");
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
    timeController.text = selectedDate.toDateString(dateFormat: "hh:mm a");
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
  Future<bool> submitForm() async {
    if (formKey.currentState!.validate()) {
      // Save data to objectbox
      Expenses expense = Expenses(
        tmpAmount: double.parse(amountController.text),
        tmpDescription: remarkController.text,
        tmpExpensesDate: selectedDate,
        tmpExpensesType: selectedExpensesType,
      );
      expense.setCategory(selectedCategory);
      expense.setAccount(selectedAccount);

      if (selectedImage != null) {
        await expense.setImage(selectedImage!);
      }

      // Update if editing
      if (isEditing) {
        expense.id = selectedExpenseForEdit!.id;
        ExpenseService().put(expense);

        // Update cache
        int listIndex = 0;
        if (selectedExpensesType == 0) {
          listIndex = ExpenseCache.expenses
              .indexWhere((element) => element.id == expense.id);

          if (listIndex != -1) ExpenseCache.expenses[listIndex] = expense;
        } else {
          listIndex = ExpenseCache.incomes
              .indexWhere((element) => element.id == expense.id);

          if (listIndex != -1) ExpenseCache.incomes[listIndex] = expense;
        }

        return true;
      }

      ExpenseService().add(expense);

      // Add to cache (Check if it is expense or income)
      if (selectedExpensesType == 0) {
        ExpenseCache.expenses.add(expense);
      } else {
        ExpenseCache.incomes.add(expense);
      }

      return true;
    }
    return false;
  }

  // Auto detect category
  void autoDetectCategory() async {
    // Check if gemini enabled or remark is empty
    if (!isGeminiEnable || validateEmptyString(remarkController.text)) {
      return;
    }

    String categoryString =
        await geminiService.predictCategory(remarkController.text);

    // Detect error in prediction by checking if categoryString is empty or lengthy
    if (categoryString.isEmpty || categoryString.contains("Error")) {
      return;
    }

    Category? category = CategoryService().getCategoryByName(
      categoryString,
      selectedExpensesType == 0,
    );

    // Set to other category if not found
    if (category != null) {
      setCategory(category);
    } else {
      setCategory((CategoryService()
          .getCategoryByName("Others", selectedExpensesType == 0))!);
    }
    update();
  }

  @override
  String getTag() {
    return "FormAddExpensesController";
  }
}
