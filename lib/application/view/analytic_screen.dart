import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/analytic_controller.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/view/financial_blog_screen.dart';
import 'package:pocketkeeper/application/view/view_all_expenses_screen.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:pocketkeeper/widget/indicator.dart';
import '../../template/state_management/state_management.dart';

class AnalyticScreen extends StatefulWidget {
  const AnalyticScreen({super.key});

  @override
  State<AnalyticScreen> createState() {
    return _AnalyticScreenState();
  }
}

class _AnalyticScreenState extends State<AnalyticScreen> {
  late CustomTheme customTheme;
  late AnalyticController controller;

  // Pie Chart
  final List<Color> pieChartColors = [
    Colors.blue[300]!,
    Colors.orange[300]!,
    Colors.purple[300]!,
    Colors.teal[300]!,
    Colors.red[300]!,
  ];

  // Line Graph
  late List<Color> gradientColors;
  bool showAvg = false;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(AnalyticController());

    gradientColors = [
      customTheme.lightPurple.withOpacity(0.4),
      customTheme.white,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<AnalyticController>(
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
      appBar: buildSafeAreaAppBar(appBarColor: customTheme.lightPurple),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildCommonAppBar(
                headerTitle: "Analytics",
                context: context,
                disableBackButton: true,
              ),

              // Purple Background and Pie Chart Section
              Stack(
                children: [
                  // Purple background
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        color: customTheme.lightPurple,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                    ),
                  ),

                  // Summary
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 16, right: 16),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: customTheme.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: customTheme.lightGrey,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Summary header and month filter
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const FxText.labelLarge(
                                  "Summary",
                                  fontSize: 18,
                                  fontWeight: 700,
                                ),
                                // Month filter
                                _buildSummaryMonthFilterButton(),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Pie Chart
                            _buildPieChart(),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // Categories and view all transactions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Category expenses and view all transactions
                    _buildCategorySection(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    // Line Graph
                    _buildLineGraph(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ],
                ),
              ),

              // Calendar
              // _buildCalendar(),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            ],
          ),
        ),
      ),
    );
  }

  // Same row wih summary title, to filter month for pie chart
  Widget _buildSummaryMonthFilterButton() {
    return DropdownButton2<String>(
      value: controller.pieChartSelectedMonth,
      isExpanded: false,
      iconStyleData: const IconStyleData(
        openMenuIcon: Icon(
          Icons.arrow_drop_down,
          size: 18,
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        elevation: 8,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.zero,
      ),
      menuItemStyleData: MenuItemStyleData(
        selectedMenuItemBuilder: (context, child) {
          return Row(
            children: [
              Container(child: child),
              const Icon(
                Icons.check,
                size: 16,
                color: Colors.black,
              ),
            ],
          );
        },
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
      ),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: customTheme.black,
      ),
      alignment: Alignment.centerRight,
      // Dropdown Button
      underline: Container(
        height: 33,
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: customTheme.lightGrey.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onChanged: (String? newValue) {
        if (newValue != null) {
          controller.setMonthFilterPieChart(newValue);
        }
      },
      items: controller.monthFilterList
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: FxText.bodySmall(
            value,
            xMuted: true,
            color: customTheme.black,
            fontWeight: 600,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPieChart() {
    bool isAllZero = true;
    int colorIndex = 0;
    List<PieChartSectionData> pieChartSectionData = [];
    controller.pieChartData.forEach((key, value) {
      pieChartSectionData.add(
        PieChartSectionData(
          color: pieChartColors[colorIndex],
          value: value,
          radius: 40,
          title: key.categoryName,
          showTitle: false,
        ),
      );

      colorIndex++;
      if (value != 0 && isAllZero) {
        isAllZero = false;
      }
    });

    return (isAllZero)
        ? const Center(
            child: FxText.bodyMedium(
              "No record found",
              xMuted: true,
            ),
          )
        : Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FxText.bodySmall(
                        "Amount",
                        fontWeight: 700,
                        xMuted: true,
                        color: customTheme.grey,
                      ),
                      const SizedBox(height: 8),
                      FxText.labelLarge(
                        "${controller.currencyIndicator}${controller.totalAmount.toCommaSeparated()}",
                        fontSize: 16,
                        xMuted: true,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: PieChart(
                      swapAnimationDuration: const Duration(milliseconds: 750),
                      swapAnimationCurve: Curves.easeInOutQuint,
                      PieChartData(
                        centerSpaceColor: Colors.transparent,
                        sectionsSpace: 5,
                        sections: pieChartSectionData,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Indicator
              Wrap(
                spacing: 16.0,
                runSpacing: 8.0,
                children: List.generate(pieChartSectionData.length, (index) {
                  return Indicator(
                    color: pieChartColors[index],
                    text: pieChartSectionData[index].title,
                    isSquare: false,
                    size: 16,
                    textColor: customTheme.black,
                  );
                }),
              ),
            ],
          );
  }

  Widget _buildCategorySection() {
    if (controller.categoryTotalTransactions.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: customTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: customTheme.lightGrey,
            blurRadius: 5.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          for (String categoryName in controller.categoryTotalTransactions.keys)
            _buildBudgetItem(categoryName),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              // Navigate to view all transaction
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const ViewAllExpensesScreen(filterAccountId: 0),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FxText.labelMedium(
                  "View all transactions",
                  color: customTheme.lightPurple,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: customTheme.lightPurple,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineGraph() {
    return Container(
      decoration: BoxDecoration(
        color: customTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: customTheme.lightGrey,
            blurRadius: 5.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Line graph header
          Column(
            children: [
              FxText.labelLarge(
                controller.lineGraphTitle,
                xMuted: true,
                fontWeight: 600,
              ),
              FxText.labelMedium(
                controller.lineGraphTotal,
                color: customTheme.red,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Line graph
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: LineChart(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutQuint,
              LineChartData(
                minY: controller.minY,
                maxY: controller.maxY,
                minX: controller.minX,
                maxX: controller.maxX,
                baselineY: 0,
                // Grid in graph
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 40,
                      interval: controller.yAxisInterval,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // Display the value of the graph
                        return FxText.bodySmall(
                          '\$${value.toStringAsFixed(0)}',
                          fontSize: 11,
                          xMuted: true,
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: controller.xAxisInterval,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        // Check filter
                        if (controller.selectedLineGraphFilter == 0) {
                          // Filter by week
                          return Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: FxText.bodySmall(
                              value.toInt().toWeekDayString(true),
                              xMuted: true,
                            ),
                          );
                        } else if (controller.selectedLineGraphFilter == 1) {
                          // Filter by month
                          return Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: FxText.bodySmall(
                              "${controller.now.month.toMonthString(true)} ${value.toInt()}",
                              xMuted: true,
                            ),
                          );
                        } else {
                          // Filter by year
                          return Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: FxText.bodySmall(
                              value.toInt().toMonthString(true),
                              xMuted: true,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                // On touch line
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      // On touch line
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final FlSpot spot = touchedSpot;
                        return LineTooltipItem(
                          '\$${spot.y.toStringAsFixed(2)}',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Expenses
                  LineChartBarData(
                    spots: controller.expenseslineGraphSpot,
                    isCurved: true,
                    color: customTheme.red,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    show: true,
                    dotData: const FlDotData(show: false),
                    // belowBarData: BarAreaData(
                    //   show: true,
                    //   gradient: LinearGradient(
                    //     colors: gradientColors,
                    //     begin: Alignment.topCenter,
                    //     end: Alignment.bottomCenter,
                    //     stops: const [0.1, 1],
                    //   ),
                    // ),
                  ),
                  // Incomes
                  LineChartBarData(
                    spots: controller.incomeLineGraphSpot,
                    isCurved: true,
                    color: customTheme.green,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    show: true,
                    dotData: const FlDotData(show: false),
                    // belowBarData: BarAreaData(
                    //   show: true,
                    //   gradient: LinearGradient(
                    //     colors: gradientColors,
                    //     begin: Alignment.topCenter,
                    //     end: Alignment.bottomCenter,
                    //     stops: const [0.1, 1],
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
          ),

          // Filter line graph
          _buildFilterLineGraph(),
          const SizedBox(height: 16),

          // Cash flow
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const FxText.labelLarge(
                "Cash flow",
                fontSize: 16,
                fontWeight: 600,
              ),
              FxText.labelMedium(
                controller.lineGraphTitle,
                xMuted: true,
                color: customTheme.grey,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Income
                  Row(
                    children: [
                      CircleAvatar(
                        maxRadius: 12,
                        backgroundColor: customTheme.green,
                        child: Icon(
                          Icons.arrow_upward,
                          color: customTheme.white,
                          size: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FxText.labelSmall(
                        "Income",
                        color: customTheme.black,
                        xMuted: true,
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  FxText.labelMedium(
                    "${controller.currencyIndicator}${controller.totalIncome.toCommaSeparated()}",
                    color: customTheme.green,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        maxRadius: 12,
                        backgroundColor: customTheme.red,
                        child: Icon(
                          Icons.arrow_downward,
                          color: customTheme.white,
                          size: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FxText.labelSmall(
                        "Expenses",
                        color: customTheme.black,
                        xMuted: true,
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  FxText.labelMedium(
                    "${controller.currencyIndicator}${controller.totalExpense.toCommaSeparated()}",
                    color: customTheme.red,
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxText.labelMedium(
                    "Total: ",
                    color: customTheme.black,
                  ),
                  const SizedBox(width: 8),
                  FxText.labelMedium(
                    "${controller.currencyIndicator}${controller.netProfit > 0 ? (controller.netProfit.toCommaSeparated()) : (controller.netProfit * -1).toCommaSeparated()}",
                    color: (controller.totalExpense > controller.totalIncome)
                        ? customTheme.red
                        : customTheme.green,
                  ),
                ],
              ),
            ],
          ),

          // Financial Advice
          // Financial Advice
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              // Navigate to view all transaction
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FinancialBlogScreen(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FxText.labelMedium(
                  "Discover more",
                  color: customTheme.lightPurple,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: customTheme.lightPurple,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterLineGraph() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < controller.lineGraphFilterList.length; i++)
          InkWell(
            onTap: () {
              controller.filterLineGraph(i);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: (controller.selectedLineGraphFilter == i)
                    ? customTheme.lightPurple
                    : Colors.transparent,
              ),
              child: FxText.bodySmall(
                controller.lineGraphFilterList[i],
                xMuted: true,
                color: (controller.selectedLineGraphFilter == i)
                    ? customTheme.white
                    : customTheme.black,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBudgetItem(String tmpCategoryName) {
    // If is other remove (bcoz this is self add, all category record will display here. Other category always 0)
    if (tmpCategoryName == "Others") {
      return const SizedBox();
    }

    Category tmpCategory = ExpenseCache.expenseCategories
        .firstWhere((element) => element.categoryName == tmpCategoryName);

    // Get total amount of the category (Compare name)
    double value =
        controller.categoryTotalAmount[tmpCategory.categoryName] ?? 0;

    int totalTransaction =
        controller.categoryTotalTransactions[tmpCategory.categoryName] ?? 0;

    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: customTheme.lightPurple,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            IconData(tmpCategory.iconHex, fontFamily: 'MaterialIcons'),
            color: customTheme.white,
          ),
        ),
      ),
      title: FxText.labelMedium(tmpCategory.categoryName),
      subtitle: FxText.bodySmall(
        "$totalTransaction transactions",
        color: customTheme.grey,
        xMuted: true,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FxText.labelMedium(
            "${controller.currencyIndicator}${value.toCommaSeparated()}",
          ),
        ],
      ),
    );
  }

  // Widget _buildCalendar() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 24),
  //     child: Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: customTheme.white,
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [
  //           BoxShadow(
  //             color: customTheme.lightGrey,
  //             blurRadius: 5,
  //             offset: const Offset(0, 5),
  //           ),
  //         ],
  //       ),
  //       child: TableCalendar(
  //         firstDay: DateTime.utc(2023, 1, 1),
  //         lastDay: DateTime.utc(2030, 12, 31),
  //         focusedDay: DateTime.now(),
  //         calendarStyle: CalendarStyle(
  //           defaultTextStyle: const TextStyle(
  //             color: Colors.black87,
  //             fontSize: 12,
  //           ),
  //           weekendTextStyle: const TextStyle(
  //             color: Colors.black87,
  //             fontSize: 12,
  //           ),
  //           holidayTextStyle: const TextStyle(
  //             color: Colors.black87,
  //             fontSize: 12,
  //           ),
  //           todayDecoration: BoxDecoration(
  //             color: const Color(0xFFD32F2F),
  //             shape: BoxShape.rectangle,
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           defaultDecoration: BoxDecoration(
  //             color: const Color(0xFFFFE0B2),
  //             shape: BoxShape.rectangle,
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           selectedDecoration: BoxDecoration(
  //             color: const Color(0xFFFFCC80),
  //             shape: BoxShape.rectangle,
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //         ),
  //         headerStyle: const HeaderStyle(
  //           formatButtonVisible: false,
  //           titleCentered: true,
  //           titleTextStyle: TextStyle(color: Colors.black87, fontSize: 18),
  //         ),
  //         daysOfWeekStyle: const DaysOfWeekStyle(
  //           weekdayStyle: TextStyle(color: Colors.black87),
  //           weekendStyle: TextStyle(color: Colors.black87),
  //         ),
  //         eventLoader: (day) {
  //           return [
  //             "Event 1",
  //           ];
  //         },
  //       ),
  //     ),
  //   );
  // }
}
