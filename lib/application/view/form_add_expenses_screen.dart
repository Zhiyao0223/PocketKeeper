import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketkeeper/application/controller/form_add_expenses_controller.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/view/navigation_screen.dart';
import 'package:pocketkeeper/application/view/receipt_scanner_screen.dart';
import 'package:pocketkeeper/template/utils/spacing.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/text_style.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../theme/custom_theme.dart';
import '../../template/state_management/state_management.dart';

class FormAddExpensesScreen extends StatefulWidget {
  final Expenses? selectedExpense;
  final bool isFromOCR;

  const FormAddExpensesScreen({
    super.key,
    this.selectedExpense,
    this.isFromOCR = false,
  });

  @override
  State<FormAddExpensesScreen> createState() {
    return _FormAddExpensesState();
  }
}

class _FormAddExpensesState extends State<FormAddExpensesScreen>
    with TickerProviderStateMixin {
  late CustomTheme customTheme;

  late FormAddExpensesController controller;

  // Focus Node
  final FocusNode remarkFocusNode = FocusNode();
  final FocusNode amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(FormAddExpensesController(
      this,
      selectedExpenseForEdit: widget.selectedExpense,
      isFromOCR: widget.isFromOCR,
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<FormAddExpensesController>(
      controller: controller,
      builder: (controllers) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    // Prevent load UI if data is not finish load
    if (!controller.isDataFetched) {
      // Display spinner while loading
      return buildCircularLoadingIndicator();
    }

    return Scaffold(
      appBar: _buildAppbar(),
      body: SafeArea(
        child: SizedBox.expand(
          child: Container(
            color: customTheme.lightPurple,
            child: Container(
              color: customTheme.white.withOpacity(0.8),
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  children: [
                    _buildTopSection(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Form(
                        key: controller.formKey,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.height * 0.02,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                          ),
                          decoration: BoxDecoration(
                            color: customTheme.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  _buildRemarkField(),
                                  const Divider(),
                                  _buildDateField(),
                                  const Divider(),
                                  _buildTimeField(),
                                  const Divider(),
                                  _buildCategoryField(),
                                  const Divider(),
                                  _buildAccountField(),
                                  const Divider(),
                                  _buildAttachImage(),
                                  const Divider(),
                                ],
                              ),
                              _buildSaveButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: (amountFocusNode.hasFocus)
          ? null
          : FloatingActionButton(
              onPressed: () => amountFocusNode.requestFocus(),
              child: FxText.bodyMedium('123', color: customTheme.white),
            ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      toolbarHeight: kToolbarHeight + 1, // Make bottom border invisible
      title: FxText.labelLarge(
        controller.isEditing ? 'Edit Record' : 'Add New Record',
        color: customTheme.white,
      ),
      centerTitle: true,
      backgroundColor: customTheme.lightPurple,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: customTheme.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        // QR Code Scanner (Only show in Add New Record)
        if (!controller.isEditing)
          IconButton(
            icon: Icon(Icons.qr_code_scanner, color: customTheme.white),
            onPressed: () {
              // Go to QR page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const ReceiptScannerScreen();
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildTopSection() {
    return Column(
      children: [
        // Expenses and Income Selector
        Container(
          color: customTheme.lightPurple,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (controller.selectedExpensesType != 0) {
                    setState(() {
                      controller.selectedExpensesType = 0;
                      controller.setCategory(controller.expenseCategories[0]);
                      controller.categoryController.text =
                          controller.expenseCategories[0].categoryName;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customTheme.white,
                ),
                child: Row(
                  children: [
                    if (controller.selectedExpensesType == 0)
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(Icons.check, color: customTheme.black),
                      ),
                    FxText.bodyMedium(
                      'Expense',
                      fontWeight:
                          (controller.selectedExpensesType == 0) ? 700 : 500,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.selectedExpensesType != 1) {
                    setState(() {
                      controller.selectedExpensesType = 1;
                      controller.selectedCategory =
                          controller.incomeCategories[0];
                      controller.categoryController.text =
                          controller.incomeCategories[0].categoryName;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customTheme.white,
                ),
                child: Row(
                  children: [
                    if (controller.selectedExpensesType == 1)
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(Icons.check, color: customTheme.black),
                      ),
                    FxText.bodyMedium(
                      'Income',
                      fontWeight:
                          (controller.selectedExpensesType == 1) ? 700 : 500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Icon
        Container(
          color: customTheme.lightPurple,
          padding: const EdgeInsets.only(right: 10.0),
          height: MediaQuery.of(context).size.height * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(controller.selectedCategory.iconColor),
                  child: Icon(
                    IconData(
                      controller.selectedCategory.iconHex,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: customTheme.white,
                  ),
                ),
              ),
              // Amount text field
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextFormField(
                  onTap: () {
                    amountFocusNode.requestFocus();

                    // Set cursor to end of text
                    controller.amountController.selection = TextSelection(
                      baseOffset: controller.amountController.text.length,
                      extentOffset: controller.amountController.text.length,
                    );
                  },
                  onChanged: (value) {
                    // Update to 0 if empty
                    if (value.isEmpty) {
                      setState(() {
                        controller.amountController.text = "0";
                      });
                    } else if (value.startsWith("0")) {
                      // Remove leading 0
                      setState(() {
                        controller.amountController.text = value.substring(1);
                      });
                    }
                  },
                  focusNode: amountFocusNode,
                  textAlign: TextAlign.end,
                  style: FxTextStyle.displaySmall(
                    color: customTheme.white,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    isDense: true,
                    filled: false,
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                  maxLines: 1,
                  controller: controller.amountController,
                  validator: controller.validateAmount,
                  cursorColor: customTheme.black,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRemarkField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.notes,
              color: customTheme.grey,
              size: 20,
            ),
            const SizedBox(width: 10.0),
            const FxText.bodyMedium('Remark '),
            const SizedBox(width: 10.0),
          ],
        ),
        Expanded(
          child: SizedBox(
            child: SlideTransition(
              position: controller.remarkAnimation.returnAnimationOffset(),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.start,
                focusNode: remarkFocusNode,
                style: FxTextStyle.bodyMedium(),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  isDense: true,
                  filled: true,
                  fillColor: customTheme.white,
                  hintText: "Write a note",
                  contentPadding: FxSpacing.all(10),
                  hintStyle: FxTextStyle.bodyMedium(xMuted: true),
                  isCollapsed: true,
                  border: InputBorder.none,
                ),
                maxLines: 1,
                controller: controller.remarkController,
                validator: controller.validateRemark,
                cursorColor: customTheme.black,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onEditingComplete: () {
                  // If amount empty, focus on amount field
                  if (controller.amountController.text == "0") {
                    amountFocusNode.requestFocus();
                  }

                  // Auto detect category based on remark
                  controller.autoDetectCategory();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    // With date picker
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: customTheme.grey,
              size: 20,
            ),
            const SizedBox(width: 10.0),
            const FxText.bodyMedium('Date'),
            const SizedBox(width: 20.0),
          ],
        ),
        Expanded(
          child: SizedBox(
            child: SlideTransition(
              position: controller.remarkAnimation.returnAnimationOffset(),
              child: TextFormField(
                onTap: () {
                  // Show date picker
                  showDatePickerDialog(
                    context: context,
                    selectedDate: controller.selectedDate,
                    minDate: DateTime(2000),
                    maxDate: DateTime(2100),
                    barrierLabel: 'Close',
                    currentDateDecoration: BoxDecoration(
                      // Underline border
                      border: Border(
                        bottom: BorderSide(
                          color: customTheme.colorPrimary,
                          width: 2,
                        ),
                      ),
                    ),
                    currentDateTextStyle: const TextStyle(),
                    daysOfTheWeekTextStyle: const TextStyle(),
                    disabledCellsTextStyle: const TextStyle(),
                    enabledCellsDecoration: const BoxDecoration(),
                    enabledCellsTextStyle: const TextStyle(),
                    initialPickerType: PickerType.days,
                    selectedCellDecoration: BoxDecoration(
                      color: customTheme.colorPrimary,
                      shape: BoxShape.circle,
                    ),
                    selectedCellTextStyle: TextStyle(
                      color: customTheme.white,
                    ),
                    leadingDateTextStyle: const TextStyle(),
                    centerLeadingDate: true,
                  ).then((date) {
                    if (date != null) {
                      controller.setSelectedDate(date);
                      controller.dateController.text =
                          date.toDateString(dateFormat: "dd MMM, yyyy");
                    }
                  });
                },
                style: FxTextStyle.bodyMedium(xMuted: true),
                readOnly: true,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  isDense: true,
                  filled: true,
                  fillColor: customTheme.white,
                  contentPadding: FxSpacing.all(10),
                  hintText: "Select date here",
                  hintStyle: FxTextStyle.bodyMedium(xMuted: true),
                  isCollapsed: true,
                  border: InputBorder.none,
                  suffixIcon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                  ),
                ),
                maxLines: 1,
                controller: controller.dateController,
                validator: controller.validateDate,
                cursorColor: customTheme.black,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    // With time picker
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.access_time,
              color: customTheme.grey,
              size: 20,
            ),
            const SizedBox(width: 10.0),
            const FxText.bodyMedium('Time'),
            const SizedBox(width: 10.0),
          ],
        ),
        Expanded(
          child: SizedBox(
            child: SlideTransition(
              position: controller.remarkAnimation.returnAnimationOffset(),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.start,
                style: FxTextStyle.bodyMedium(xMuted: true),
                readOnly: true,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  isDense: true,
                  filled: true,
                  fillColor: customTheme.white,
                  hintText: "Select time here",
                  contentPadding: FxSpacing.all(10),
                  hintStyle: FxTextStyle.bodyMedium(xMuted: true),
                  isCollapsed: true,
                  border: InputBorder.none,
                  suffixIcon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                  ),
                ),
                maxLines: 1,
                controller: controller.timeController,
                validator: controller.validateTime,
                cursorColor: customTheme.black,
                onTap: () {
                  // Show time picker
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          alwaysUse24HourFormat: false,
                        ),
                        child: child!,
                      );
                    },
                  ).then((time) {
                    if (time != null) {
                      controller.setSelectedTime(time);
                    }
                  });
                },
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.attach_file,
              color: customTheme.grey,
              size: 20,
            ),
            const SizedBox(width: 10.0),
            const SizedBox(child: FxText.bodyMedium('Receipts')),
            const SizedBox(width: 10.0),
          ],
        ),
        Expanded(
          child: SizedBox(
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              style: FxTextStyle.bodyMedium(xMuted: true),
              readOnly: true,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                isDense: true,
                filled: true,
                fillColor: customTheme.white,
                hintText: "(Optional)",
                contentPadding: FxSpacing.all(10),
                hintStyle: FxTextStyle.bodyMedium(xMuted: true),
                isCollapsed: true,
                border: InputBorder.none,
                suffixIcon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 15,
                ),
              ),
              maxLines: 1,
              controller: controller.imageController,
              onTap: () {
                // Show image picker
                ImagePicker().pickImage(source: ImageSource.gallery).then(
                  (image) {
                    if (image != null) {
                      controller.selectedImage = image;
                      controller.imageController.text = image.name;
                    }
                  },
                );
              },
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.category,
              color: customTheme.grey,
              size: 20,
            ),
            const SizedBox(width: 10.0),
            const FxText.bodyMedium('Category'),
            const SizedBox(width: 10.0),
          ],
        ),
        Expanded(
          child: SizedBox(
            child: SlideTransition(
              position: controller.remarkAnimation.returnAnimationOffset(),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.start,
                style: FxTextStyle.bodyMedium(xMuted: true),
                readOnly: true,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  isDense: true,
                  filled: true,
                  fillColor: customTheme.white,
                  hintText: "Select a category",
                  contentPadding: FxSpacing.all(10),
                  hintStyle: FxTextStyle.bodyMedium(xMuted: true),
                  isCollapsed: true,
                  border: InputBorder.none,
                  suffixIcon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                  ),
                ),
                maxLines: 1,
                controller: controller.categoryController,
                validator: controller.validateCategory,
                cursorColor: customTheme.black,
                onTap: () {
                  _showCategoryBottomSheet(context);
                },
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.account_balance_wallet,
              color: customTheme.grey,
              size: 20,
            ),
            const SizedBox(width: 10.0),
            const FxText.bodyMedium('Account'),
            const SizedBox(width: 5.0),
          ],
        ),
        Expanded(
          child: Theme(
            data: ThemeData(
              canvasColor: customTheme.white,
              focusColor: customTheme.colorPrimary,
            ),
            child: DropdownButtonFormField<String>(
              value: controller.selectedAccount.accountName,
              hint: const FxText.bodyMedium(
                'Select an account',
                xMuted: true,
              ),
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: customTheme.white,
                contentPadding: FxSpacing.all(10),
                border: InputBorder.none,
              ),
              items: controller.accounts.map((Accounts account) {
                return DropdownMenuItem<String>(
                  value: account.accountName,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        child: Icon(
                          IconData(
                            account.accountIconHex,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: customTheme.grey,
                          size: 16.0,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      FxText.bodyMedium(
                        account.accountName,
                        color: customTheme.black,
                      ),
                    ],
                  ),
                );
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return controller.accounts.map((Accounts account) {
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        child: Icon(
                          IconData(
                            account.accountIconHex,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: customTheme.grey,
                          size: 16.0,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      FxText.bodyMedium(
                        account.accountName,
                        color: customTheme.black,
                      ),
                    ],
                  );
                }).toList();
              },
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    controller.selectedAccount = controller.accounts.firstWhere(
                        (account) => account.accountName == newValue);
                  });
                }
              },
              icon: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          // Submit form
          await controller.submitForm().then((value) {
            // Close keyboard
            FocusManager.instance.primaryFocus?.unfocus();

            // Close screen
            if (value) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) {
                    return const NavigationScreen(
                      fromLogin: true,
                      navigationIndex: 0,
                    );
                  },
                ),
                (route) => false,
              );
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: customTheme.colorPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: FxText.bodyMedium(
          controller.isEditing ? 'Update' : 'Add',
          color: customTheme.white,
        ),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            itemExtent: 50.0,
            itemCount: (controller.selectedExpensesType == 0)
                ? controller.expenseCategories.length
                : controller.incomeCategories.length,
            itemBuilder: (BuildContext context, int index) {
              Color categoryColor = (controller.selectedExpensesType == 0)
                  ? controller.expenseCategories[index] ==
                          controller.selectedCategory
                      ? customTheme.colorPrimary.withOpacity(0.2)
                      : Colors.transparent
                  : controller.incomeCategories[index] ==
                          controller.selectedCategory
                      ? customTheme.colorPrimary.withOpacity(0.2)
                      : Colors.transparent;

              return ListTile(
                title: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: customTheme.border,
                        width: 1,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    color: categoryColor,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(
                          (controller.selectedExpensesType == 0)
                              ? controller.expenseCategories[index].iconColor
                              : controller.incomeCategories[index].iconColor,
                        ),
                        child: Icon(
                          IconData(
                            (controller.selectedExpensesType == 0)
                                ? controller.expenseCategories[index].iconHex
                                : controller.incomeCategories[index].iconHex,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: customTheme.white,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      FxText.bodyMedium(
                        (controller.selectedExpensesType == 0)
                            ? controller.expenseCategories[index].categoryName
                            : controller.incomeCategories[index].categoryName,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  if (controller.selectedExpensesType == 0) {
                    controller.setCategory(controller.expenseCategories[index]);
                  } else {
                    controller.setCategory(controller.incomeCategories[index]);
                  }
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
              );
            },
          ),
        );
      },
    );
  }
}
