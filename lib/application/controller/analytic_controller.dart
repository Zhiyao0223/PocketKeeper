import 'package:fl_chart/fl_chart.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/service/expense_service.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/utils/converters/string.dart';

import '../../template/state_management/controller.dart';

class AnalyticController extends FxController {
  bool isDataFetched = false;

  // General
  List<String> monthFilterList = [];
  DateTime now = DateTime.now();
  String currencyIndicator = "\$";

  // Pie Chart
  late String pieChartSelectedMonth;
  late double totalAmount;
  Map<Category, double> pieChartData = {};

  // Category List
  Map<String, int> categoryTotalTransactions = {};
  Map<String, double> categoryTotalAmount = {};

  // Line graph
  List<String> lineGraphFilterList = ["Week", "Month", "Year"];
  List<FlSpot> lineGraphSpot = [];

  int selectedLineGraphFilter = 0; //  0: Week, 1: Month, 2: Year
  late double yAxisInterval, xAxisInterval, minY, maxY, minX, maxX;
  late String lineGraphTitle, lineGraphTotal;

  // Cash flow
  late double netProfit, totalIncome, totalExpense;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < now.month; i++) {
      monthFilterList.add("${(i + 1).toMonthString(true)} ${now.year}");
    }

    pieChartSelectedMonth = monthFilterList[now.month - 1];

    fetchData();
  }

  void fetchData() async {
    // Clear all data
    pieChartData = {};
    categoryTotalTransactions = {};
    categoryTotalAmount = {};
    lineGraphSpot = [];

    // General
    currencyIndicator = MemberCache.appSetting.currencyIndicator;

    // Pie Chart
    Map<Category, double> tmpCategoryExpenses =
        ExpenseService().getTopSpendCategories(
      pieChartSelectedMonth.substring(0, 3).toMonthInt(),
    );

    totalAmount = 0;
    for (Category category in tmpCategoryExpenses.keys) {
      pieChartData[category] = tmpCategoryExpenses[category] ?? 0;
      totalAmount += pieChartData[category]!;
    }

    // Category List
    int month = pieChartSelectedMonth.substring(0, 3).toMonthInt();
    categoryTotalTransactions =
        ExpenseService().getTotalRecordsByCategory(month);

    categoryTotalAmount = ExpenseService()
        .getTotalExpensesByCategory(month)
        .map((key, value) => MapEntry(key.categoryName, value));

    // Line Graph
    // Check filter by week, month, year
    if (selectedLineGraphFilter == 0) {
      // Filter by week
      DateTime startDate = now.subtract(Duration(days: now.weekday - 1));
      DateTime endDate = startDate.add(const Duration(days: 6));

      lineGraphTitle =
          "${startDate.day} ${startDate.month.toMonthString(true)} - ${endDate.day} ${endDate.month.toMonthString(true)}";

      totalIncome = ExpenseService().getTotalIncomeInWeek(startDate, endDate);
      totalExpense =
          ExpenseService().getTotalExpensesInWeek(startDate, endDate);

      ExpenseService()
          .getTotalExpensesByDay(startDate, endDate)
          .forEach((key, value) {
        lineGraphSpot.add(FlSpot(key.toDouble(), value));
      });

      xAxisInterval = 1;
      minX = 1;
      maxX = 7;
    } else if (selectedLineGraphFilter == 1) {
      // Filter by month
      DateTime startDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      lineGraphTitle =
          "1 ${now.month.toMonthString(true)} - ${lastDayOfMonth.day} ${now.month.toMonthString(true)} ${now.year}";

      totalIncome = ExpenseService().getTotalIncomeInMonth(now.month);
      totalExpense =
          ExpenseService().getTotalExpensesInMonth(now.month, now.year);

      ExpenseService()
          .getTotalExpensesByDay(startDayOfMonth, lastDayOfMonth)
          .forEach((key, value) {
        lineGraphSpot.add(FlSpot(key.toDouble(), value));
      });

      xAxisInterval = lastDayOfMonth.day / 5;
      minX = 1;
      maxX = lastDayOfMonth.day.toDouble();
    } else if (selectedLineGraphFilter == 2) {
      // Filter by year
      lineGraphTitle = "Jan ${now.year} - Dec ${now.year}";

      totalIncome = ExpenseService().getTotalIncomeInYear(now.year);
      totalExpense = ExpenseService().getTotalExpensesInYear(now.year);

      ExpenseService().getTotalExpensesByMonth(now.year).forEach((key, value) {
        lineGraphSpot.add(FlSpot(key.toDouble(), value));
      });

      xAxisInterval = 3;
      minX = 1;
      maxX = 12;
    }

    yAxisInterval = (lineGraphSpot.isNotEmpty)
        ? lineGraphSpot.reduce((a, b) => a.y > b.y ? a : b).y / 5
        : 5;
    minY = (lineGraphSpot.isNotEmpty)
        ? lineGraphSpot.reduce((a, b) => a.y < b.y ? a : b).y
        : 0;
    maxY = (lineGraphSpot.isNotEmpty)
        ? lineGraphSpot.reduce((a, b) => a.y > b.y ? a : b).y
        : 25;

    // Calculate total
    double headerTotal = 0;
    if (lineGraphSpot.isNotEmpty) {
      for (int i = 1; i <= 7; i++) {
        headerTotal += lineGraphSpot[i - 1].y;
      }
    }
    lineGraphTotal = "+$currencyIndicator$headerTotal";

    // Cash flow
    netProfit = totalIncome - totalExpense;

    isDataFetched = true;
    update();
  }

  void setMonthFilterPieChart(String tmpValue) {
    pieChartSelectedMonth = tmpValue;
    fetchData();
  }

  void filterLineGraph(int index) {
    selectedLineGraphFilter = index;
    fetchData();
  }

  @override
  String getTag() {
    return "AnalyticController";
  }
}
