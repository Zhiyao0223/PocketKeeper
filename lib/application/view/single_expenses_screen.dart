import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pocketkeeper/application/controller/single_expenses_controller.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/view/form_add_expenses_screen.dart';
import 'package:pocketkeeper/template/utils/spacing.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/text_style.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../theme/custom_theme.dart';
import '../../template/state_management/state_management.dart';

class SingleExpensesScreen extends StatefulWidget {
  final Expenses selectedExpense;
  const SingleExpensesScreen({super.key, required this.selectedExpense});

  @override
  State<SingleExpensesScreen> createState() {
    return _SingleExpensesScreenState();
  }
}

class _SingleExpensesScreenState extends State<SingleExpensesScreen> {
  late CustomTheme customTheme;
  late SingleExpensesController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller =
        FxControllerStore.put(SingleExpensesController(widget.selectedExpense));
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<SingleExpensesController>(
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
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.height * 0.02,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.03,
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
                          ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          // Navigate to edit screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormAddExpensesScreen(
                selectedExpense: controller.selectedExpense,
              ),
            ),
          ).then((value) {
            controller.fetchData();
          }),
        },
        child: Icon(Icons.edit, color: customTheme.white),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      toolbarHeight: kToolbarHeight + 1, // Make bottom border invisible
      title: FxText.labelLarge(
        'View Record',
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
        // Delete button
        IconButton(
          icon: Icon(Icons.delete_forever, color: customTheme.red),
          onPressed: () {
            // Show dialog to confirm delete
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: FxText.labelLarge(
                    'Delete Record',
                    color: customTheme.black,
                  ),
                  content: FxText.bodyMedium(
                    'Are you sure you want to delete this record?',
                    color: customTheme.black,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: FxText.bodyMedium(
                        'Cancel',
                        color: customTheme.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.deleteRecord();

                        // Delete record
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                      },
                      child: FxText.bodyMedium(
                        'Delete',
                        color: customTheme.red,
                      ),
                    ),
                  ],
                );
              },
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
                onPressed: () {},
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
                onPressed: () {},
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
                  backgroundColor: Color(
                      controller.selectedExpense.category.target!.iconColor),
                  child: Icon(
                    IconData(
                      controller.selectedExpense.category.target!.iconHex,
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
                  textAlign: TextAlign.end,
                  style: FxTextStyle.displaySmall(
                    color: customTheme.white,
                  ),
                  readOnly: true,
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
                  cursorColor: customTheme.black,
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
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              style: FxTextStyle.bodyMedium(xMuted: true),
              keyboardType: TextInputType.text,
              readOnly: true,
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
              cursorColor: customTheme.black,
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
            child: TextFormField(
              style: FxTextStyle.bodyMedium(xMuted: true),
              readOnly: true,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                isDense: true,
                filled: true,
                fillColor: customTheme.white,
                hintText: "Select date here",
                hintStyle: FxTextStyle.bodyMedium(xMuted: true),
                isCollapsed: true,
                border: InputBorder.none,
                contentPadding: FxSpacing.all(10),
              ),
              maxLines: 1,
              controller: controller.dateController,
              cursorColor: customTheme.black,
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
              ),
              maxLines: 1,
              controller: controller.timeController,
              cursorColor: customTheme.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
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
                  ),
                  maxLines: 1,
                  controller: controller.imageController,
                ),
              ),
            ),
          ],
        ),

        // Image preview
        if (controller.selectedExpense.image != null)
          InkWell(
            onTap: () {
              // Show image in full screen
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: customTheme.white,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            // Define the max height and width
                            final maxHeight = constraints.maxHeight * 0.5;
                            final maxWidth = constraints.maxWidth * 0.8;

                            // Calculate the width and height maintaining the image aspect ratio
                            double containerWidth = maxWidth;
                            double containerHeight =
                                containerWidth / controller.imageAspectRatio;

                            if (containerHeight > maxHeight) {
                              containerHeight = maxHeight;
                              containerWidth =
                                  containerHeight * controller.imageAspectRatio;
                            }

                            return Container(
                              color: Colors.transparent,
                              width: containerWidth,
                              height: containerHeight,
                              child: PhotoView(
                                enableRotation: false,
                                enablePanAlways: false,
                                minScale: PhotoViewComputedScale.contained,
                                imageProvider: MemoryImage(
                                    controller.selectedExpense.image!),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Image.memory(
              controller.selectedExpense.image!,
              fit: BoxFit.cover,
              height: 200,
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
                hintText: "Select a account",
                contentPadding: FxSpacing.all(10),
                hintStyle: FxTextStyle.bodyMedium(xMuted: true),
                isCollapsed: true,
                border: InputBorder.none,
              ),
              maxLines: 1,
              controller: controller.accountController,
              cursorColor: customTheme.black,
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
              ),
              maxLines: 1,
              controller: controller.categoryController,
              cursorColor: customTheme.black,
            ),
          ),
        ),
      ],
    );
  }
}
