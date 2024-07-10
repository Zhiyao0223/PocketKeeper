import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/other/goal_controller.dart';
import 'package:pocketkeeper/application/model/expense_goal.dart';
import 'package:pocketkeeper/application/model/goal_saving_record.dart';
import 'package:pocketkeeper/application/view/other/add_goal_screen.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../../template/state_management/state_management.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() {
    return _GoalScreenState();
  }
}

class _GoalScreenState extends State<GoalScreen>
    with SingleTickerProviderStateMixin {
  late CustomTheme customTheme;
  late GoalController controller;

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(GoalController());
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<GoalController>(
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
        headerTitle: "Goals",
        context: context,
        trailingIcon: Icons.add,
        onTrailingIconPressed: () async {
          // Add new goal
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddGoalScreen(),
            ),
          ).then((value) {
            // Refresh data
            controller.fetchData();
          });
        },
      ),
      body: Container(
        color: customTheme.lightPurple,
        child: Column(
          children: [
            _buildSummaryWidget(),
            const SizedBox(height: 16),
            // If empty
            if (controller.activeGoals.isEmpty &&
                controller.completedGoals.isEmpty)
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: customTheme.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/no_record_found.png',
                        width: 150,
                      ),
                      const SizedBox(height: 10),
                      FxText.bodySmall(
                        'No goal found',
                        color: customTheme.black,
                        xMuted: true,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: customTheme.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.only(
                      bottom: 8.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    children: [
                      // Active goals
                      if (controller.activeGoals.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FxText.labelLarge(
                                'ACTIVE GOALS',
                                color: customTheme.black,
                                xMuted: true,
                                fontWeight: 800,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  // Show info about active goals
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const FxText.labelLarge(
                                          'Active Goals',
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            FxText.bodySmall(
                                              'Active goals are the goals that you are currently working on.'
                                              'You can add a new goal by clicking the + icon on the top right corner. '
                                              'Every month, extra money will be saved to help you reach your goal faster.',
                                              color: customTheme.black,
                                              textAlign: TextAlign.justify,
                                            ),
                                          ],
                                        ),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        actions: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  customTheme.colorPrimary,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: FxText.bodyMedium(
                                              'OK',
                                              color: customTheme.white,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  color: customTheme.black,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        for (ExpenseGoal goal in controller.activeGoals)
                          _buildGoalCard(
                            goal: goal,
                            lastContributionRecord:
                                controller.lastGoalSaving.firstWhere(
                              (element) => element.goal.targetId == goal.goalId,
                            ),
                          ),
                      ],

                      // Completed goals
                      if (controller.completedGoals.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: FxText.labelLarge(
                            'COMPLETED GOALS',
                            color: customTheme.black,
                            xMuted: true,
                            fontWeight: 800,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        for (ExpenseGoal goal in controller.completedGoals)
                          _buildGoalCard(
                            goal: goal,
                            reachedGoal: true,
                          ),
                      ]
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FxText.bodySmall(
                'Total Saved',
                xMuted: true,
                color: customTheme.white,
              ),
              FxText.labelLarge(
                "${controller.currencySymbol}${controller.totalSaved.toCommaSeparated()}",
                fontSize: 18,
                color: customTheme.white,
              ),
            ],
          ),
          Column(
            children: [
              FxText.bodySmall(
                'This Month',
                xMuted: true,
                color: customTheme.white,
              ),
              FxText.labelLarge(
                "${controller.currencySymbol}${controller.savingThisMonth.toCommaSeparated()} (${controller.percentageThisMonth}%)",
                fontSize: 18,
                color: customTheme.lime,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required ExpenseGoal goal,
    GoalSavingRecord? lastContributionRecord,
    bool reachedGoal = false,
  }) {
    final remainingBalance = goal.targetAmount - goal.currentAmount;

    return GestureDetector(
      onTap: () {
        // Show dialog for view
        _buildGoalDialog(
          goal: goal,
          remainingBalance: remainingBalance,
          lastContributionRecord: lastContributionRecord,
          reachedGoal: reachedGoal,
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and date (last updated date or due date)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        IconData(goal.iconHex, fontFamily: 'MaterialIcons'),
                        color: customTheme.black,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      FxText.labelLarge(goal.description),
                    ],
                  ),
                  FxText.labelMedium(
                    goal.dueDate?.toDateString(dateFormat: 'MMM dd, yyyy') ??
                        goal.updatedDate
                            .toDateString(dateFormat: 'MMM dd, yyyy'),
                    xMuted: true,
                    fontWeight: 800,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Current amount and progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.labelLarge(
                    '${controller.currencySymbol}${goal.currentAmount.toCommaSeparated()}',
                    color:
                        (reachedGoal) ? customTheme.green : customTheme.orange,
                    fontWeight: 800,
                  ),
                  if (reachedGoal)
                    Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: customTheme.colorPrimary,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        FxText.labelLarge(
                          'REACHED',
                          color: customTheme.colorPrimary,
                        ),
                      ],
                    )
                  else ...[
                    Row(
                      children: [
                        FxText.bodySmall(
                          '${controller.currencySymbol}${remainingBalance.toCommaSeparated()} left of ',
                          xMuted: true,
                        ),
                        FxText.bodySmall(
                          '${controller.currencySymbol}${goal.targetAmount.toCommaSeparated()}',
                          fontWeight: 800,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              // Linear progress bar
              LinearProgressIndicator(
                value: goal.currentAmount / goal.targetAmount,
                backgroundColor: customTheme.lightGrey,
                valueColor: AlwaysStoppedAnimation<Color>(
                  (reachedGoal) ? customTheme.green : customTheme.orange,
                ),
              ),
              const SizedBox(height: 8),
              // Last contribution amount and suggested amount
              // Only show if not reached goal or has value
              if (!reachedGoal && lastContributionRecord != null)
                // eg. $125 this month ($150 suggested)
                Row(
                  children: [
                    FxText.bodySmall(
                      'Save ${controller.currencySymbol}${lastContributionRecord.amount.toStringAsFixed(0)} on ${lastContributionRecord.savingDate.month.getMonthString()} ',
                      xMuted: true,
                    ),
                    // If suggested amount is available
                    if (goal.suggestedAmount != 0)
                      FxText.bodySmall(
                        '(${controller.currencySymbol}${goal.suggestedAmount.toWholeNumber()} suggested)',
                        xMuted: true,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  Show dialog for view
  */
  Future<void> _buildGoalDialog({
    required ExpenseGoal goal,
    required double remainingBalance,
    GoalSavingRecord? lastContributionRecord,
    required bool reachedGoal,
  }) async {
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
                        goal.iconHex,
                        fontFamily: 'MaterialIcons',
                      ),
                      size: 24,
                      color: customTheme.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  FxText.labelLarge(goal.description),
                  const Spacer(),
                  FxText.labelLarge(goal.currentAmount.removeExtraDecimal()),
                ],
              ),
              const SizedBox(height: 20),
              _buildInfoRow(
                'Target Amount',
                "${controller.currencySymbol}${goal.targetAmount.toCommaSeparated()}",
              ),
              _buildInfoRow(
                'Created Date',
                goal.createdDate.toDateString(dateFormat: "MMM dd yyyy"),
              ),
              _buildInfoRow(
                'Created Time',
                goal.createdDate.toDateString(dateFormat: "hh:mm a"),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildActionButton(Icons.edit, () async {
                        // Show dialog to edit budget
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddGoalScreen(
                              selectedGoal: goal,
                            ),
                          ),
                        ).then((_) {
                          // Refresh data
                          controller.fetchData();
                        });
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
                                    controller.deleteGoal(goal);

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
