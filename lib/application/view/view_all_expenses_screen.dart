import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/view_all_expenses_controller.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/template/widgets/widgets.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/utils/validators/string_validator.dart';
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
    tabController.animation?.addListener(() {
      int tabControllerIndex =
          tabController.index + tabController.offset.round();

      if (tabControllerIndex != controller.selectedTabIndex) {
        controller.selectedTabIndex = tabControllerIndex;
        controller.fetchData();
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
    return GestureDetector(
      onVerticalDragDown: (details) => FocusScope.of(context).unfocus(),
      child: DefaultTabController(
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
                    title:
                        FxText.bodyMedium('History', color: customTheme.white),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.filter_alt_outlined,
                            color: customTheme.white),
                        onPressed: () => openFilterDialog(),
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
                      automaticIndicatorColorAdjustment: true,
                      indicatorColor: customTheme.white,
                      indicatorWeight: 2.0,
                    ),
                  ),
                ];
              },
              body: (!controller.isDataFetched)
                  ? buildCircularLoadingIndicator()
                  : Stack(
                      children: [
                        TabBarView(
                          controller: tabController,
                          children: [
                            _buildlTab(),
                            _buildlTab(isIncome: true),
                          ],
                        ),
                      ],
                    ),
            ),
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
                  controller.isShowClearButton = !validateEmptyString(value);
                  controller.searchQuery = value;
                  controller.filterData();
                },
                decoration: InputDecoration(
                  hintText: 'Search Description...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: (controller.isShowClearButton)
                      ? IconButton(
                          onPressed: () {
                            controller.isShowClearButton = false;
                            controller.fetchData();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          // Show message if no data found else show data
          (controller.filteredData.isEmpty)
              ? FxText.bodyMedium(
                  'No record found',
                  color: customTheme.grey,
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: controller.groupedData.length,
                    itemBuilder: (context, index) {
                      List<Expenses> expensesList =
                          controller.groupedData.values.toList()[index];

                      return Column(
                        children: [
                          _buildDateHeader(
                            controller.groupDate[index],
                            controller
                                .totalAmount[controller.groupDate[index]]!,
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
                      '${tmpExpenses.expensesType == 0 ? '-' : '+'}${tmpExpenses.amount.removeExtraDecimal()}',
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

  Widget _buildDateHeader(DateTime date, double total) {
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
          FxText.labelLarge(
            "${(controller.selectedTabIndex == 0) ? '-' : '+'}${total.removeExtraDecimal()}",
            color: customTheme.black,
          ),
        ],
      ),
    );
  }

  // Filter Menu
  // References: https://pub.dev/packages/filter_list
  void openFilterDialog() async {
    await FilterListDialog.display<Category>(
      context,
      listData: controller.categories,
      selectedListData: controller.selectedCategory,
      choiceChipLabel: (item) => item!.categoryName,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (item, query) {
        return item.categoryName.toLowerCase().contains(query.toLowerCase());
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
