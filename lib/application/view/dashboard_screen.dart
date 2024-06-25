import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/dashboard_controller.dart';
import 'package:pocketkeeper/application/member_constant.dart';
import 'package:pocketkeeper/application/view/notification_screen.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:pocketkeeper/widget/circular_progress_indicator_icon.dart';
import 'package:pocketkeeper/widget/multi_section_progress_indicator.dart';
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

  Widget _buildBody() {
    // Check if all data loaded
    if (!controller.isDataFetched) {
      return buildCircularLoadingIndicator();
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                title: const FxText.titleMedium('Dashboard'),
                centerTitle: true,
                backgroundColor: customTheme.white,
                scrolledUnderElevation: 0,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
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
                              child: FxText.labelSmall(
                                controller.notificationCount.toString(),
                                style: TextStyle(
                                  color: customTheme.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
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
                          Icons.check_circle,
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
                      const SizedBox(height: 20),
                      _buildAccountSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FxText.titleMedium(
          'Hi, ${MemberConstant.user.name}',
          color: customTheme.white,
          fontWeight: 700,
        ),
        FxText.titleSmall(
          controller.greeting,
          color: customTheme.white,
          fontSize: 14,
          // xMuted: true,
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
                            '${controller.currencyIndicator}${controller.remainingBalance.toWholeNumber()}',
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
                      ProgressSection(
                        name: 'Food',
                        value: 0.3,
                      ),
                      ProgressSection(
                        name: 'Shopping',
                        value: 0.6,
                      ), // Food
                      ProgressSection(
                        name: 'Bill Payment',
                        value: 0.1,
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
                FxText.bodySmall('Saving On Goal', color: customTheme.white),
              ],
            ),
            VerticalDivider(
              color: customTheme.white,
              thickness: 2,
            ),
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            'Revenue Last Week',
                            color: customTheme.white,
                          ),
                          FxText.labelLarge(
                            '${controller.currencyIndicator}${controller.revenueLastWeek.toWholeNumber()}',
                            color: customTheme.white,
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
                  const SizedBox(height: 10),
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
                            controller.topCategoryLastWeek.categoryName,
                            color: customTheme.white,
                          ),
                          FxText.labelLarge(
                            '${controller.currencyIndicator}${controller.topCategoryAmountLastWeek.toWholeNumber()}',
                            color: customTheme.white,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FxText.titleMedium(
              'Account',
              color: customTheme.black,
            ),
            Icon(
              Icons.account_balance_wallet,
              color: customTheme.black,
              size: 24,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: customTheme.white.withOpacity(0.87),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.bodySmall(
                    'Total Balance',
                    color: customTheme.black,
                  ),
                  FxText.titleMedium(
                    '${controller.currencyIndicator}${controller.totalExpenses.removeExtraDecimal()}',
                    color: customTheme.black,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                color: customTheme.black,
                thickness: 2,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.bodySmall(
                    'Total Income',
                    color: customTheme.black,
                  ),
                  FxText.titleMedium(
                    '${controller.currencyIndicator}${controller.totalExpenses.removeExtraDecimal()}',
                    color: customTheme.black,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                color: customTheme.black,
                thickness: 2,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.bodySmall(
                    'Total Expenses',
                    color: customTheme.black,
                  ),
                  FxText.titleMedium(
                    '${controller.currencyIndicator}${controller.totalExpenses.removeExtraDecimal()}',
                    color: customTheme.black,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
