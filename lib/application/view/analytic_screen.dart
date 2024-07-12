import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/analytic_controller.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
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

  List<Color> gradientColors = [
    const Color(0xFF36D1DC),
    const Color(0xFFD8B5FF),
  ];

  bool showAvg = false;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(AnalyticController());
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
      appBar: buildCommonAppBar(headerTitle: "Analytics", context: context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const FxText.labelLarge('Expenses', fontSize: 18),
                // Three button to filter either day, week or month
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        controller.filterLineGraph(0);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (controller.selectedLineGraphFilter == 0)
                              ? customTheme.lightPurple
                              : customTheme.lightPurple.withOpacity(0.1),
                        ),
                        child: FxText.bodySmall(
                          'Day',
                          xMuted: true,
                          color: (controller.selectedLineGraphFilter == 0)
                              ? customTheme.white
                              : customTheme.black,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.filterLineGraph(1);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (controller.selectedLineGraphFilter == 1)
                              ? customTheme.lightPurple
                              : customTheme.lightPurple.withOpacity(0.1),
                        ),
                        child: FxText.bodySmall(
                          'Week',
                          xMuted: true,
                          color: (controller.selectedLineGraphFilter == 1)
                              ? customTheme.white
                              : customTheme.black,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.filterLineGraph(2);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (controller.selectedLineGraphFilter == 2)
                              ? customTheme.lightPurple
                              : customTheme.lightPurple.withOpacity(0.1),
                        ),
                        child: FxText.bodySmall(
                          'Month',
                          xMuted: true,
                          color: (controller.selectedLineGraphFilter == 2)
                              ? customTheme.white
                              : customTheme.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              child: LineChart(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                LineChartData(
                  minY: 0,
                  maxY: 25,
                  baselineY: 0,
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
                        reservedSize: 35,
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
                        interval: 1,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          // Display the month name
                          switch (value.toInt()) {
                            case 1:
                              return const FxText.bodySmall(
                                'Jan',
                                xMuted: true,
                              );
                            case 2:
                              return const FxText.bodySmall(
                                'Feb',
                                xMuted: true,
                              );
                            case 3:
                              return const FxText.bodySmall(
                                'Mar',
                                xMuted: true,
                              );
                            case 4:
                              return const FxText.bodySmall(
                                'Apr',
                                xMuted: true,
                              );
                            case 5:
                              return const FxText.bodySmall(
                                'May',
                                xMuted: true,
                              );
                            case 6:
                              return const FxText.bodySmall(
                                'Jun',
                                xMuted: true,
                              );
                            case 7:
                              return const FxText.bodySmall(
                                'Jul',
                                xMuted: true,
                              );
                            case 8:
                              return const FxText.bodySmall(
                                'Aug',
                                xMuted: true,
                              );
                            case 9:
                              return const FxText.bodySmall(
                                'Sep',
                                xMuted: true,
                              );
                            case 10:
                              return const FxText.bodySmall(
                                'Oct',
                                xMuted: true,
                              );
                            case 11:
                              return const FxText.bodySmall(
                                'Nov',
                                xMuted: true,
                              );
                            case 12:
                              return const FxText.bodySmall(
                                'Dec',
                                xMuted: true,
                              );
                            default:
                              return const FxText.bodySmall('', xMuted: true);
                          }
                        },
                      ),
                    ),
                  ),
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
                  // borderData: FlBorderData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.lineGraphSpot,
                      isCurved: true,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                        stops: const [0.0, 1.0],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      show: true,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Budget',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetItem(Expenses expenses) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      title: Text(expenses.description),
      subtitle: Text(expenses.expensesDate.toDateString()),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '\$${expenses.amount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(expenses.category.target!.categoryName,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
