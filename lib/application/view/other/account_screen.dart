import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/other/account_controller.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/view/other/add_account_screen.dart';
import 'package:pocketkeeper/application/view/single_expenses_screen.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../../template/state_management/state_management.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() {
    return _AccountScreenState();
  }
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  late CustomTheme customTheme;
  late AccountController controller;

  late TabController accountTabController;
  late TabController recordTabController;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(AccountController());
    accountTabController = TabController(
      length: ExpenseCache.accounts.length,
      vsync: this,
    );

    recordTabController = TabController(
      length: 3,
      vsync: this,
    );
    recordTabController.animation?.addListener(() {
      int tabControllerIndex =
          recordTabController.index + recordTabController.offset.round();

      if (tabControllerIndex != controller.selectedRecordIndex) {
        controller.selectedRecordIndex = tabControllerIndex;
        controller.fetchData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<AccountController>(
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
        headerTitle: 'Accounts',
        context: context,
        trailingIcon: Icons.add,
        onTrailingIconPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAccountScreen(),
            ),
          ).then((value) {
            controller.fetchData();
          });
        },
      ),
      body: Container(
        color: customTheme.lightPurple,
        child: Column(
          children: [
            _buildBalanceCard(),
            _buildRecordTabBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordTabBar() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: customTheme.white.withOpacity(0.87),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(15),
        child: DefaultTabController(
          length: 3,
          initialIndex: controller.selectedRecordIndex,
          child: Column(
            children: [
              TabBar(
                enableFeedback: true,
                isScrollable: true,
                automaticIndicatorColorAdjustment: true,
                labelColor: customTheme.black,
                unselectedLabelColor: customTheme.lightBlack,
                indicatorColor: customTheme.colorPrimary,
                controller: recordTabController,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Expenses'),
                  Tab(text: 'Receives'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: recordTabController,
                  children: [
                    _buildTransactionList(2),
                    _buildTransactionList(0),
                    _buildTransactionList(1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.23,
      margin: const EdgeInsets.only(bottom: 16),
      child: Swiper(
        indicatorLayout: PageIndicatorLayout.COLOR,
        pagination: SwiperPagination(
          margin: const EdgeInsets.only(top: 16),
          builder: DotSwiperPaginationBuilder(
            color: customTheme.white,
            activeColor: customTheme.lightBlack,
          ),
        ),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: customTheme.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const FxText.bodyMedium(
                        'Balance',
                        xMuted: true,
                      ),
                      PopupMenuButton<int>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (int result) {
                          // Edit
                          if (result == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddAccountScreen(
                                  selectedAccount: controller.accounts[index],
                                ),
                              ),
                            ).then((value) {
                              controller.fetchData();
                            });
                          }
                          // Delete
                          else if (result == 1) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: FxText.labelLarge(
                                    'Delete Account',
                                    color: customTheme.black,
                                  ),
                                  content: FxText.bodyMedium(
                                    'Are you sure you want to delete this account?',
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
                                        Navigator.of(context).pop();
                                        controller.deleteAccount();
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
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<int>>[
                          const PopupMenuItem<int>(
                            value: 0,
                            child: FxText.bodyMedium(
                              'Edit',
                              xMuted: true,
                            ),
                          ),
                          // Disable delete for cash
                          if (controller.accounts.length > 1)
                            const PopupMenuItem<int>(
                              value: 1,
                              child: FxText.bodyMedium(
                                'Delete',
                                xMuted: true,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  FxText.labelLarge(
                    '${controller.currencyIndicator} ${(controller.accountBalances[index] < 0 ? controller.accountBalances[index] * -1 : controller.accountBalances[index])}',
                    fontSize: 24,
                    color: (controller.accountBalances[index] < 0)
                        ? customTheme.red
                        : customTheme.green,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        IconData(
                          controller.accounts[index].accountIconHex,
                          fontFamily: 'MaterialIcons',
                        ),
                        size: 24,
                        color: customTheme.grey,
                      ),
                      const SizedBox(width: 8),
                      FxText.titleSmall(
                        controller.accounts[index].accountName,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: controller.accounts.length,
        viewportFraction: 0.85,
        scale: 1,
        onIndexChanged: (index) {
          controller.setCurrentAccount(index);
        },
      ),
    );
  }

  Widget _buildTransactionList(int type) {
    List<Expenses> records =
        controller.accountExpenses[controller.selectedAccountIndex] ?? [];

    // Continue filter based on type
    if (type == 0) {
      records = records.where((element) => element.expensesType == 0).toList();
    } else if (type == 1) {
      records = records.where((element) => element.expensesType == 1).toList();
    }

    // If empty
    if (records.isEmpty) {
      return Center(
        child: FxText.bodySmall(
          'No record found',
          color: customTheme.black,
          xMuted: true,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        return _buildTransactionItem(singleExpense: records[index]);
      },
    );
  }

  Widget _buildTransactionItem({required Expenses singleExpense}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleExpensesScreen(
                  selectedExpense: singleExpense,
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
                          singleExpense.category.target!.iconHex,
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
                          singleExpense.category.target!.categoryName,
                          color: customTheme.black,
                        ),
                        FxText.bodySmall(
                          // Cut description if more than 20 characters
                          singleExpense.description.length > 20
                              ? '${singleExpense.description.substring(0, 20)}...'
                              : singleExpense.description,
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
                      singleExpense.expensesDate
                          .toDateString(dateFormat: "dd MMM yyyy"),
                      fontSize: 10,
                      color: customTheme.black,
                    ),
                    FxText.labelLarge(
                      '${singleExpense.expensesType == 0 ? '-' : ''}${singleExpense.amount.removeExtraDecimal()}',
                      color: singleExpense.expensesType == 0
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
