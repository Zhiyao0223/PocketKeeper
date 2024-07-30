import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/app_constant.dart';
import 'package:pocketkeeper/application/controller/other/add_goal_controller.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/model/expense_goal.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/theme/text_style.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';
import '../../../template/state_management/state_management.dart';

class AddGoalScreen extends StatefulWidget {
  final ExpenseGoal? selectedGoal;
  const AddGoalScreen({super.key, this.selectedGoal});

  @override
  State<AddGoalScreen> createState() {
    return _AddGoalScreenState();
  }
}

class _AddGoalScreenState extends State<AddGoalScreen>
    with TickerProviderStateMixin {
  late CustomTheme customTheme;
  late AddGoalController controller;

  late TabController accountTabController;

  FocusNode nameUserNode = FocusNode();
  FocusNode targetAmountNode = FocusNode();
  FocusNode suggestedAmountNode = FocusNode();

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(AddGoalController(widget.selectedGoal));
    accountTabController = TabController(
      length: ExpenseCache.accounts.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    accountTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<AddGoalController>(
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

    return GestureDetector(
      onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: buildCommonAppBar(
          headerTitle:
              (controller.selectedGoal == null) ? "Add Goal" : "Edit Goal",
          context: context,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Goal name
                TextFormField(
                  focusNode: nameUserNode,
                  controller: controller.goalNameController,
                  maxLength: 30,
                  decoration: InputDecoration(
                    labelText: "Goal Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: controller.validateGoalName,
                ),
                const SizedBox(height: 16),

                // Target amount
                TextFormField(
                  focusNode: targetAmountNode,
                  controller: controller.targetAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Target Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: controller.validateTargetAmount,
                ),
                const SizedBox(height: 16),

                // Suggested amount
                TextFormField(
                  focusNode: suggestedAmountNode,
                  controller: controller.suggestedAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Suggested Amount (optional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: controller.validateSuggestedAmount,
                ),
                const SizedBox(height: 16),

                // Target date
                _buildDateField(),
                const SizedBox(height: 16),

                // Icon List
                const FxText.labelLarge(
                  "Icon",
                  fontSize: 16,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: customTheme.lightBlack,
                        width: 2,
                      ),
                    ),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: iconList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.selectedIconHex =
                                  iconList[index].codePoint;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller.selectedIconHex ==
                                      iconList[index].codePoint
                                  ? customTheme.lightPurple
                                  : customTheme.lightBlack.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              IconData(
                                iconList[index].codePoint,
                                fontFamily: 'MaterialIcons',
                              ),
                              color: controller.selectedIconHex ==
                                      iconList[index].codePoint
                                  ? customTheme.white
                                  : customTheme.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            controller.submitGoal().then((value) {
              if (value) {
                showToast(customMessage: "Goal saved successfully");

                if (widget.selectedGoal != null) {
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                } else {
                  Navigator.of(context).pop();
                }
                setState(() {});
              }
            });
          },
          child: const Icon(Icons.check),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    // With date picker
    return TextFormField(
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
            controller.targetDateController.text =
                date.toDateString(dateFormat: "dd MMM, yyyy");
          }
        });
      },
      style: FxTextStyle.bodyMedium(xMuted: true),
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        labelText: "Target Date (optional)",
        hintText: "Select date here",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: const Icon(
          Icons.arrow_forward_ios_outlined,
          size: 15,
        ),
      ),
      maxLines: 1,
      controller: controller.targetDateController,
      validator: controller.validateTargetDate,
      cursorColor: customTheme.black,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }
}
