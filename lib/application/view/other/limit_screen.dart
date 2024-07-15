import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/other/limit_controller.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/expense_limit.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:pocketkeeper/widget/semi_progress_indicator.dart';
import '../../../template/state_management/state_management.dart';

class LimitScreen extends StatefulWidget {
  const LimitScreen({super.key});

  @override
  State<LimitScreen> createState() {
    return _LimitScreenState();
  }
}

class _LimitScreenState extends State<LimitScreen>
    with SingleTickerProviderStateMixin {
  late CustomTheme customTheme;
  late LimitController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(LimitController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<LimitController>(
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
      appBar: buildCommonAppBar(
        headerTitle: "Category Limits",
        context: context,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        color: customTheme.lightPurple,
        child: Column(
          children: [
            _buildSemiCircleChart(),
            _buildBudgetOverview(),
            _buildBudgetList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetOverview() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBudgetStat(controller.getTotalBudget(), 'Total Budgets'),
                _buildBudgetStat(controller.getTotalSpent(), 'Total Spent'),
                _buildBudgetStat(
                    '${controller.remainingDays} days', 'End of Month'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: customTheme.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              // Show dialog to create budget
              _buildCreateEditLimitDialog();
            },
            child: FxText.bodyMedium(
              'Create Budget',
              color: customTheme.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetStat(String value, String label) {
    return Column(
      children: [
        FxText.labelMedium(
          value,
          color: customTheme.white,
        ),
        FxText.bodySmall(
          label,
          color: customTheme.white,
          xMuted: true,
          fontSize: 12,
        ),
      ],
    );
  }

  Widget _buildBudgetList() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: customTheme.white.withOpacity(0.87),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            if (controller.categoryLimitsAndTotalSpent.isEmpty ||
                controller.expenseLimits.isEmpty)
              Center(
                child: FxText.bodyMedium(
                  'No budget created yet',
                  color: customTheme.black,
                  xMuted: true,
                ),
              )
            else
              Expanded(
                child: ListView(
                  children: [
                    for (int i = 0;
                        i < controller.categoryLimitsAndTotalSpent.length;
                        i++)
                      _buildBudgetItem(
                        controller.categoryLimitsAndTotalSpent.keys
                            .elementAt(i),
                        controller.categoryLimitsAndTotalSpent.values
                            .elementAt(i),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetItem(
    int categoryId,
    Map<double, double> budget,
  ) {
    final ExpenseLimit limit = controller.expenseLimits.firstWhere(
      (element) => element.category.target!.id == categoryId,
    );

    final double amount = budget.keys.first;
    final double totalSpent = amount - budget.values.first;
    final double availableBalance = budget.values.first;
    final double percentage = (availableBalance > 0)
        ? controller.convertToNumericPercentage(availableBalance / amount)
        : 1;

    return ListTile(
      onTap: () {
        // Show dialog to edit budget
        _buildBudgetDialog(
          limit: limit,
          limitAmount: amount,
          totalSpent: totalSpent,
        );
      },
      leading: CircleAvatar(
        backgroundColor: customTheme.lightPurple,
        child: Icon(
          IconData(
            limit.category.target!.iconHex,
            fontFamily: 'MaterialIcons',
          ),
          color: customTheme.white,
        ),
      ),
      title: FxText.labelLarge(
        limit.category.target!.categoryName,
      ),
      subtitle: LinearProgressIndicator(value: percentage),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FxText.labelSmall(
            amount.removeExtraDecimal(),
            fontSize: 10,
            color: customTheme.black,
          ),
          FxText.bodySmall(
            'Left ${availableBalance.removeExtraDecimal()}',
            fontSize: 8,
            color: customTheme.black,
            xMuted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSemiCircleChart() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 165,
      child: CustomPaint(
        painter: SemiCircleProgressPainter(
          progress: controller.chartProgress,
          color: customTheme.lime,
          backgroundColor: customTheme.white.withOpacity(0.87),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            FxText.bodyMedium(
              'Amount you can spend',
              color: customTheme.white,
              xMuted: true,
            ),
            FxText.labelMedium(
              controller.availableBalance.toInt().toCommaSeparated(),
              fontSize: 40,
              color: customTheme.lime,
              fontWeight: 600,
            ),
          ],
        ),
      ),
    );
  }

  /*
  Show dialog for view
  */
  Future<void> _buildBudgetDialog({
    required ExpenseLimit limit,
    required double limitAmount,
    required double totalSpent,
  }) async {
    // Change to negative
    totalSpent = (totalSpent != 0) ? totalSpent * -1 : 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: customTheme.lightGrey,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: customTheme.colorPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      IconData(
                        limit.category.target!.iconHex,
                        fontFamily: 'MaterialIcons',
                      ),
                      size: 24,
                      color: customTheme.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  FxText.labelLarge(limit.category.target!.categoryName),
                  const Spacer(),
                  FxText.labelLarge(totalSpent.removeExtraDecimal()),
                ],
              ),
              const SizedBox(height: 20),
              _buildInfoRow('Budget Amount', limitAmount.removeExtraDecimal()),
              _buildInfoRow(
                'Created Date',
                limit.createdDate.toDateString(dateFormat: "MMM dd yyyy"),
              ),
              _buildInfoRow(
                'Created Time',
                limit.createdDate.toDateString(dateFormat: "hh:mm a"),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildActionButton(Icons.edit, () {
                        // Show dialog to edit budget
                        _buildCreateEditLimitDialog(selectedLimit: limit);
                      }),
                      const SizedBox(width: 20),
                      _buildActionButton(Icons.delete, () {
                        // Confirm delete
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
                                    controller.deleteBudget(limit);

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
                      }),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customTheme.colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: FxText.bodyMedium(
                      'Close',
                      color: customTheme.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Show dialog for create/edit
  Future<void> _buildCreateEditLimitDialog({
    ExpenseLimit? selectedLimit,
  }) async {
    // Check if editing
    bool isEditing = selectedLimit != null;

    controller.selectedCategory = (isEditing)
        ? selectedLimit.category.target!
        : controller.expenseCategories.first;
    controller.amountController.text =
        (isEditing) ? selectedLimit.amount.removeExtraDecimal() : "0";
    controller.categoryNameController.text = (isEditing)
        ? selectedLimit.category.target!.categoryName
        : controller.selectedCategory.categoryName;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: customTheme.lightGrey,
              title: FxText.labelLarge(
                isEditing ? 'Edit Budget' : 'Create Budget',
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Category dropdown if created
                      if (isEditing)
                        TextFormField(
                          controller: controller.categoryNameController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            hintText: 'Enter amount',
                          ),
                        )
                      else
                        DropdownButtonFormField(
                          value: controller.selectedCategory.id,
                          items: controller.expenseCategories
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category.id,
                                  child: Text(category.categoryName),
                                ),
                              )
                              .toList(),
                          onChanged: (int? value) {
                            controller.selectedCategory = controller
                                .expenseCategories
                                .firstWhere((element) => element.id == value);

                            setState(() {
                              controller.updateSuggestion();
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            hintText: 'Select category',
                          ),
                          dropdownColor: customTheme.lightGrey,
                          menuMaxHeight: 265,
                        ),
                      const SizedBox(height: 20),

                      // Category limit amount
                      TextFormField(
                        controller: controller.amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          hintText: 'Enter amount',
                        ),
                        validator: controller.validateAmount,
                      ),
                      // Suggestions
                      const SizedBox(height: 10),
                      FxText.bodySmall(
                        'Suggestion: ${MemberCache.appSetting.currencyIndicator}${controller.suggestedAmount.removeExtraDecimal()}',
                        color: customTheme.black,
                        xMuted: true,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: const FxText.bodyMedium('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customTheme.colorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: FxText.bodyMedium(
                    isEditing ? 'Save' : 'Create',
                    color: customTheme.white,
                  ),
                  onPressed: () {
                    controller.createBudget(isEditing);

                    if (isEditing) {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Sub widget for view dialog
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FxText.bodySmall(label),
          FxText.labelSmall(value),
        ],
      ),
    );
  }

  // Sub widget for view dialog
  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Icon(
        icon,
        color: customTheme.black,
      ),
    );
  }
}
