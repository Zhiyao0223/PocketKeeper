import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/form_add_expenses_controller.dart';
import 'package:pocketkeeper/application/view/qr_code_scanner_screen.dart';
import 'package:pocketkeeper/template/utils/spacing.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/text_style.dart';
import 'package:pocketkeeper/utils/validators/string_validator.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../theme/custom_theme.dart';
import '../../template/state_management/state_management.dart';

class FormAddExpensesScreen extends StatefulWidget {
  const FormAddExpensesScreen({super.key});

  @override
  State<FormAddExpensesScreen> createState() {
    return _FormAddExpensesState();
  }
}

class _FormAddExpensesState extends State<FormAddExpensesScreen>
    with TickerProviderStateMixin {
  late CustomTheme customTheme;
  late OutlineInputBorder outlineInputBorder;

  late FormAddExpensesController controller;

  // Focus Node
  final FocusNode amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();
    outlineInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
        color: customTheme.colorPrimary.withOpacity(0.2),
        width: 2,
      ),
    );

    controller = FxControllerStore.put(FormAddExpensesController(this));
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
      backgroundColor: customTheme.lightPurple,
      appBar: AppBar(
        title: FxText.labelLarge(
          'Add New Record',
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
          // QR Code Scanner
          IconButton(
            icon: Icon(Icons.qr_code_scanner, color: customTheme.white),
            onPressed: () {
              // Go to QR page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const QrCodeScannerScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTopSection(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: customTheme.white.withOpacity(0.9),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SlideTransition(
                          position: controller.amountAnimation
                              .returnAnimationOffset(),
                          child: TextFormField(
                            focusNode: amountFocusNode,
                            style: FxTextStyle.bodyMedium(),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              isDense: true,
                              filled: true,
                              fillColor: customTheme.white,
                              hintText: "Amount",
                              enabledBorder: outlineInputBorder,
                              focusedBorder: outlineInputBorder,
                              border: outlineInputBorder,
                              prefixIcon: Icon(
                                Icons.person,
                                color: amountFocusNode.hasFocus
                                    ? customTheme.colorPrimary
                                    : customTheme.black,
                              ),
                              contentPadding: FxSpacing.all(16),
                              hintStyle: FxTextStyle.bodyMedium(xMuted: true),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCustomNumericKeyboard(context),
        child: const Text('123'),
      ),
    );
  }

  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
                    backgroundColor:
                        Color(controller.selectedCategory.iconColor),
                    child: Icon(
                      IconData(
                        controller.selectedCategory.iconHex,
                        fontFamily: 'MaterialIcons',
                      ),
                      color: customTheme.white,
                    ),
                  ),
                ),
                FxText.displaySmall(
                  validateEmptyString(controller.amountController.text)
                      ? '0'
                      : controller.amountController.text,
                  color: customTheme.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomNumericKeyboard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeyboardButton(context, '1'),
                  _buildKeyboardButton(context, '2'),
                  _buildKeyboardButton(context, '3'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeyboardButton(context, '4'),
                  _buildKeyboardButton(context, '5'),
                  _buildKeyboardButton(context, '6'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeyboardButton(context, '7'),
                  _buildKeyboardButton(context, '8'),
                  _buildKeyboardButton(context, '9'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeyboardButton(context, '.'),
                  _buildKeyboardButton(context, '0'),
                  _buildKeyboardButton(context, '<-'), // Backspace
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKeyboardButton(BuildContext context, String label) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context, label);
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.fastfood),
                title: const Text('Food'),
                onTap: () {
                  Navigator.pop(context, 'Food');
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions_bus),
                title: const Text('Transport'),
                onTap: () {
                  Navigator.pop(context, 'Transport');
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Shopping'),
                onTap: () {
                  Navigator.pop(context, 'Shopping');
                },
              ),
              // Add more categories as needed
            ],
          ),
        );
      },
    );
  }
}
