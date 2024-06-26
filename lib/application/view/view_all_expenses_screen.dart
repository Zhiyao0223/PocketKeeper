import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/view_all_expenses_controller.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/template/widgets/widgets.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../theme/custom_theme.dart';
import '../../template/state_management/state_management.dart';

class ViewAllExpensesScreen extends StatefulWidget {
  final int filterAccountId;
  const ViewAllExpensesScreen({super.key, required this.filterAccountId});

  @override
  State<ViewAllExpensesScreen> createState() {
    return _ViewAllExpensesState();
  }
}

class _ViewAllExpensesState extends State<ViewAllExpensesScreen>
    with TickerProviderStateMixin {
  late CustomTheme customTheme;
  late ViewAllExpensesController controller;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(ViewAllExpensesController());

    tabController = TabController(length: 2, vsync: this);

    // Add listener to detect tab changes
    tabController.addListener(() {
      if (tabController.index != controller.selectedTabIndex) {
        controller.selectedTabIndex = tabController.index;
        controller.clearFilter();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ViewAllExpensesController>(
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

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      animationDuration: const Duration(milliseconds: 300),
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: customTheme.lightPurple,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: customTheme.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  floating: true,
                  pinned: true,
                  snap: false,
                  centerTitle: true,
                  title: FxText.bodyMedium('History', color: customTheme.white),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.filter_alt_outlined,
                          color: customTheme.white),
                      onPressed: () {
                        openFilterDialog();
                        // setState(() {
                        //   controller.isShowFilter = !controller.isShowFilter;

                        // });
                      },
                    ),
                  ],
                  bottom: TabBar(
                    controller: tabController,
                    tabs: [
                      Tab(
                        child: FxText.bodyMedium(
                          'Expenses',
                          fontWeight:
                              (controller.selectedTabIndex == 0) ? 600 : 500,
                          color: customTheme.white,
                        ),
                      ),
                      Tab(
                        child: FxText.bodyMedium(
                          'Income',
                          fontWeight:
                              (controller.selectedTabIndex == 1) ? 600 : 500,
                          color: customTheme.white,
                        ),
                      ),
                    ],
                    indicatorColor: customTheme.white,
                    indicatorWeight: 2.0,
                  ),
                ),
              ];
            },
            body: Stack(children: [
              // if (controller.isShowFilter) _buildFilterWidget(),
              TabBarView(
                controller: tabController,
                children: [
                  _buildlTab(),
                  _buildlTab(isIncome: true),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildlTab({bool isIncome = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: customTheme.white.withOpacity(0.87),
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: customTheme.grey.withOpacity(0.3),
                width: 1.0,
              ),
            ),
            margin: const EdgeInsets.only(bottom: 20.0),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: FxTextField(
                controller: controller.searchController,
                onChanged: (value) {
                  controller.searchQuery = value;
                  controller.filterData();
                },
                decoration: InputDecoration(
                  hintText: 'Search Description...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.clearFilter();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.groupedData.length,
              itemBuilder: (context, index) {
                List<Expenses> expensesList =
                    controller.groupedData.values.toList()[index];

                return Column(
                  children: [
                    _buildDateHeader(
                      controller.groupDate[index],
                      controller.totalAmount[controller.groupDate[index]]![0],
                      controller.totalAmount[controller.groupDate[index]]![1],
                    ),
                    _buildExpensesBox(expensesList),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesBox(List<Expenses> tmpExpensesList) {
    return Column(
      children: [
        for (Expenses tmpExpenses in tmpExpensesList)
          Container(
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
                        tmpExpenses.category.icon,
                        color: customTheme.colorPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.labelSmall(
                          tmpExpenses.category.categoryName,
                          color: customTheme.black,
                        ),
                        FxText.bodySmall(
                          tmpExpenses.description,
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
                          .toDateString(dateFormat: "hh:mm a"),
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
      ],
    );
  }

  Widget _buildDateHeader(DateTime date, double totalUsed, double totalEarned) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FxText.titleMedium(
            date.toDateString(dateFormat: 'dd'),
            color: customTheme.colorPrimary,
            fontWeight: 800,
          ),
          FxText.titleMedium(
            date.toDateString(dateFormat: '/'),
            color: customTheme.grey.withOpacity(0.4),
            fontWeight: 800,
          ),
          FxText.titleMedium(
            date.toDateString(dateFormat: 'MM'),
            color: customTheme.black,
            fontWeight: 700,
          ),
          const SizedBox(width: 8),
          FxText.titleSmall(
            date.toDateString(dateFormat: 'E'),
            xMuted: true,
          ),
          const Spacer(),
          FxText.labelLarge("+${totalEarned.removeExtraDecimal()}"),
          const SizedBox(width: 8),
          FxText.labelLarge(
            "-${totalUsed.removeExtraDecimal()}",
            color: customTheme.red,
          ),
        ],
      ),
    );
  }

  // Filter Menu
  // References: https://pub.dev/packages/filter_list
  void openFilterDialog() async {
    await FilterListDialog.display<String>(
      context,
      listData: controller.categoryNames,
      selectedListData: controller.selectedCategory,
      choiceChipLabel: (item) => item!,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (item, query) {
        return controller.categoryNames.contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        // Update selected category
        controller.selectedCategory = list ?? [];

        controller.filterData();
        Navigator.pop(context);
      },
      headlineText: 'Filter Category',
      hideSearchField: true,
    );
  }
}
