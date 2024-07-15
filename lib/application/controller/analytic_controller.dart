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
  List<FlSpot> expenseslineGraphSpot = [], incomeLineGraphSpot = [];

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
    ExpenseService expenseService = ExpenseService();

    // Clear all data
    pieChartData = {};
    categoryTotalTransactions = {};
    categoryTotalAmount = {};
    expenseslineGraphSpot = [];
    incomeLineGraphSpot = [];

    // General
    currencyIndicator = MemberCache.appSetting.currencyIndicator;

    // Pie Chart
    Map<Category, double> tmpCategoryExpenses =
        expenseService.getTopSpendCategories(
      pieChartSelectedMonth.substring(0, 3).toMonthInt(),
    );

    totalAmount = 0;
    for (Category category in tmpCategoryExpenses.keys) {
      pieChartData[category] = tmpCategoryExpenses[category] ?? 0;
      totalAmount += pieChartData[category]!;
    }

    // Category List
    int month = pieChartSelectedMonth.substring(0, 3).toMonthInt();
    categoryTotalTransactions = expenseService.getTotalRecordsByCategory(month);

    categoryTotalAmount = expenseService
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

      totalIncome = expenseService.getTotalIncomeInWeek(startDate, endDate);
      totalExpense = expenseService.getTotalExpensesInWeek(startDate, endDate);

      expenseService
          .getTotalExpensesByDay(startDate, endDate)
          .forEach((key, value) {
        expenseslineGraphSpot.add(FlSpot(key.toDouble(), value));
      });

      expenseService
          .getTotalIncomeByDay(startDate, endDate)
          .forEach((key, value) {
        incomeLineGraphSpot.add(FlSpot(key.toDouble(), value));
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

      totalIncome = expenseService.getTotalIncomeInMonth(now.month);
      totalExpense =
          expenseService.getTotalExpensesInMonth(now.month, now.year);

      expenseService
          .getTotalExpensesByDay(startDayOfMonth, lastDayOfMonth)
          .forEach((key, value) {
        expenseslineGraphSpot.add(FlSpot(key.toDouble(), value));
      });

      expenseService
          .getTotalIncomeByDay(startDayOfMonth, lastDayOfMonth)
          .forEach((key, value) {
        incomeLineGraphSpot.add(FlSpot(key.toDouble(), value));
      });

      xAxisInterval = lastDayOfMonth.day / 5;
      minX = 1;
      maxX = lastDayOfMonth.day.toDouble();
    } else if (selectedLineGraphFilter == 2) {
      // Filter by year
      lineGraphTitle = "Jan ${now.year} - Dec ${now.year}";

      totalIncome = expenseService.getTotalIncomeInYear(now.year);
      totalExpense = expenseService.getTotalExpensesInYear(now.year);

      expenseService.getTotalExpensesByMonth(now.year).forEach((key, value) {
        expenseslineGraphSpot.add(FlSpot(key.toDouble(), value));
      });

      expenseService.getTotalIncomeByMonth(now.year).forEach((key, value) {
        incomeLineGraphSpot.add(FlSpot(key.toDouble(), value));
      });

      xAxisInterval = 3;
      minX = 1;
      maxX = 12;
    }

    // If empty, add 0
    if (expenseslineGraphSpot.isEmpty) {
      for (int i = 1; i <= maxX; i++) {
        expenseslineGraphSpot.add(FlSpot(i.toDouble(), 0));
      }
    }
    if (incomeLineGraphSpot.isEmpty) {
      for (int i = 1; i <= maxX; i++) {
        incomeLineGraphSpot.add(FlSpot(i.toDouble(), 0));
      }
    }

    // Calculate y-axis interval
    int tmpExpensesYAxisInterval = (expenseslineGraphSpot.isNotEmpty)
        ? expenseslineGraphSpot.reduce((a, b) => a.y > b.y ? a : b).y ~/ 5
        : 5;
    int tmpIncomeYAxisInterval = (incomeLineGraphSpot.isNotEmpty)
        ? incomeLineGraphSpot.reduce((a, b) => a.y > b.y ? a : b).y ~/ 5
        : 5;
    yAxisInterval = tmpExpensesYAxisInterval > tmpIncomeYAxisInterval
        ? tmpExpensesYAxisInterval.toDouble()
        : tmpIncomeYAxisInterval.toDouble();

    yAxisInterval = yAxisInterval == 0 ? 5 : yAxisInterval;

    // Calculate y-axis max
    double tmpExpensesMaxY = (expenseslineGraphSpot.isNotEmpty)
        ? expenseslineGraphSpot.reduce((a, b) => a.y > b.y ? a : b).y
        : 25;
    double tmpIncomeMaxY = (incomeLineGraphSpot.isNotEmpty)
        ? incomeLineGraphSpot.reduce((a, b) => a.y > b.y ? a : b).y
        : 25;
    maxY = tmpExpensesMaxY > tmpIncomeMaxY ? tmpExpensesMaxY : tmpIncomeMaxY;
    maxY = maxY == 0 ? 25 : maxY;

    // Calculate y-axis min
    double tmpIncomeMinY = (incomeLineGraphSpot.isNotEmpty)
        ? incomeLineGraphSpot.reduce((a, b) => a.y < b.y ? a : b).y
        : 0;
    double tmpExpenseMinY = (expenseslineGraphSpot.isNotEmpty)
        ? expenseslineGraphSpot.reduce((a, b) => a.y < b.y ? a : b).y
        : 0;
    minY = tmpIncomeMinY < tmpExpenseMinY ? tmpIncomeMinY : tmpExpenseMinY;

    // Calculate total
    double headerTotal = 0;
    if (expenseslineGraphSpot.isNotEmpty) {
      for (int i = 1; i <= 7; i++) {
        headerTotal += expenseslineGraphSpot[i - 1].y;
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
