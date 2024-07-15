import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/dashboard_controller.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/view/notification_screen.dart';
import 'package:pocketkeeper/application/view/single_expenses_screen.dart';
import 'package:pocketkeeper/application/view/view_all_expenses_screen.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:pocketkeeper/widget/circular_progress_indicator_icon.dart';
import 'package:pocketkeeper/widget/multi_section_progress_indicator.dart';
import 'package:pocketkeeper/widget/will_pop_dialog.dart';
import '../../template/state_management/state_management.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  late CustomTheme customTheme;
  late DashboardController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(DashboardController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<DashboardController>(
      controller: controller,
      builder: (controllers) {
        return _buildBody();
      },
    );
  }

  @override
  void dispose() {
    FxControllerStore.delete(controller);
    super.dispose();
  }

  Widget _buildBody() {
    // Check if all data loaded
    if (!controller.isDataFetched) {
      return buildCircularLoadingIndicator();
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (_) => buildWillPopDialog(context),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(backgroundColor: customTheme.colorPrimary),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: customTheme.colorPrimary.withOpacity(0.9),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Section
                      _buildGreetingMessage(),
                      const SizedBox(height: 20),

                      // Progress Indicator section
                      _buildFinancialProgressIndicator(),

                      // Financial Status Message
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            (controller.remainingBalance < 0)
                                ? Icons.error
                                : Icons.check_circle,
                            color: customTheme.white,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          FxText.bodySmall(
                            controller.financialStatusMessage,
                            color: customTheme.white,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: customTheme.colorPrimary.withOpacity(0.9),
                  child: Container(
                    decoration: BoxDecoration(
                      color: customTheme.white.withOpacity(0.87),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildSavingsGoals(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Divider(
                            color: customTheme.white,
                            thickness: 2,
                          ),
                        ),
                        _buildAccountSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleMedium(
              'Hi, ${MemberCache.user!.name}',
              color: customTheme.white,
              fontWeight: 700,
            ),
            FxText.titleSmall(
              controller.greeting,
              color: customTheme.white,
              fontSize: 14,
            ),
          ],
        ),
        IconButton(
          iconSize: 24,
          color: customTheme.white,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            ).then((value) {
              controller.fetchData();
            });
          },
          icon: Stack(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Icon(Icons.notifications),
              ),
              // Only display if more than one notification
              if (controller.notificationCount > 0)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: customTheme.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const SizedBox(),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            // Month and total amount spend
            FxText.titleMedium(
              controller.currentMonthYear,
              color: customTheme.white,
            ),
            FxText.titleLarge(
              '${controller.currencyIndicator}${controller.totalExpenses.removeExtraDecimal()}',
              color: customTheme.white,
              fontWeight: 900,
              fontSize: 24,
            ),

            // Progress Indiciator
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
                bottom: MediaQuery.of(context).size.height * 0.01,
              ),
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: customTheme.white.withOpacity(0.87),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.bodySmall(
                            'Left to spend',
                            color: customTheme.black,
                          ),
                          FxText.titleMedium(
                            (controller.remainingBalance < 0)
                                ? '-${controller.currencyIndicator}${(controller.remainingBalance * -1).toWholeNumber()}'
                                : '${controller.currencyIndicator}${controller.remainingBalance.toWholeNumber()}',
                            fontWeight: 900,
                            color: customTheme.black,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FxText.bodySmall(
                            'Monthly Budget',
                            color: customTheme.black,
                          ),
                          FxText.titleMedium(
                            '${controller.currencyIndicator}${controller.monthlyBudget.toWholeNumber()}',
                            fontWeight: 900,
                            color: customTheme.black,
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Progress Indicator
                  MultiSectionProgressBar(
                    sections: [
                      // If empty
                      if (controller.progressIndicatorData.isEmpty)
                        ProgressSection(
                          name: 'No record',
                          value: 1,
                        ),

                      for (MapEntry<String, double> entry
                          in controller.progressIndicatorData.entries)
                        ProgressSection(
                          name: entry.key,
                          value: entry.value,
                        ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildSavingsGoals() {
    return Container(
      decoration: BoxDecoration(
        color: customTheme.colorPrimary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressWithIcon(
                  icon: controller.savingGoalIcon,
                  progressValue: controller.savingGoalProgress,
                ),
                const SizedBox(height: 10),
                FxText.bodySmall(
                  (controller.savingGoalProgress != -1)
                      ? 'Saving On Goal'
                      : 'No Saving Goal',
                  color: customTheme.white,
                  fontSize: 10,
                ),
              ],
            ),
            VerticalDivider(
              color: customTheme.white,
              thickness: 2,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Revenue this month
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: customTheme.white,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.bodySmall(
                            'Revenue This Month',
                            color: customTheme.white,
                            fontSize: 10,
                          ),
                          FxText.labelLarge(
                            '${controller.currencyIndicator}${controller.revenueThisMonth.toWholeNumber()}',
                            color: customTheme.lime,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: customTheme.white,
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      Icon(
                        IconData(
                          controller.topCategoryThisMonth.iconHex,
                          fontFamily: 'MaterialIcons',
                        ),
                        color: customTheme.white,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.bodySmall(
                            controller.topCategoryThisMonth.categoryName,
                            color: customTheme.white,
                            fontSize: 10,
                          ),
                          FxText.labelLarge(
                            '${controller.currencyIndicator}${controller.topCategoryAmountLastWeek.toWholeNumber()}',
                            color: customTheme.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FxText.labelLarge(
              'Transaction details',
              color: customTheme.black,
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Build all account box
        for (Accounts tmpAccount in controller.walletAccounts)
          _buildAccountBox(account: tmpAccount),
      ],
    );
  }

  Widget _buildAccountBox({required Accounts account}) {
    return Container(
      decoration: BoxDecoration(
        color: customTheme.white.withOpacity(0.87),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    IconData(
                      account.accountIconHex,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: customTheme.black,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  FxText.labelMedium(
                    account.accountName,
                    color: customTheme.black,
                    fontSize: 14,
                  ),
                ],
              ),
              if (controller.expensesList[account.id]!.isNotEmpty)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewAllExpensesScreen(
                          filterAccountId: account.id,
                        ),
                      ),
                    ).then((value) {
                      controller.fetchData();
                    });
                  },
                  child: FxText.labelSmall(
                    'View all >',
                    color: customTheme.colorPrimary,
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Divider(
              color: customTheme.grey.withOpacity(0.3),
              thickness: 1.5,
            ),
          ),
          _buildExpensesBox(account.id),
        ],
      ),
    );
  }

  Widget _buildExpensesBox(int accountId) {
    return Column(
      children: [
        // If no record found
        if (controller.expensesList[accountId]!.isEmpty)
          Center(
            child: FxText.bodySmall(
              'No record found',
              color: customTheme.black,
              xMuted: true,
            ),
          ),
        for (Expenses tmpExpenses in controller.expensesList[accountId]!)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleExpensesScreen(
                    selectedExpense: tmpExpenses,
                  ),
                ),
              ).then((value) {
                controller.fetchData();
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: customTheme.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: customTheme.white,
                          border: Border.all(
                            color: customTheme.colorPrimary,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          IconData(
                            tmpExpenses.category.target!.iconHex,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: customTheme.colorPrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FxText.labelSmall(
                            tmpExpenses.category.target!.categoryName,
                            color: customTheme.black,
                          ),
                          FxText.bodySmall(
                            // Cut description if more than 20 characters
                            tmpExpenses.description.length > 20
                                ? '${tmpExpenses.description.substring(0, 20)}...'
                                : tmpExpenses.description,
                            color: customTheme.black,
                            xMuted: true,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FxText.bodySmall(
                        tmpExpenses.expensesDate
                            .toDateString(dateFormat: "dd MMM yyyy"),
                        fontSize: 10,
                        color: customTheme.black,
                      ),
                      FxText.labelLarge(
                        '${tmpExpenses.expensesType == 0 ? '-' : ''}${tmpExpenses.amount.removeExtraDecimal()}',
                        color: tmpExpenses.expensesType == 0
                            ? customTheme.red
                            : customTheme.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
