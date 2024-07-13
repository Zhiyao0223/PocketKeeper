import 'package:fl_chart/fl_chart.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/utils/converters/number.dart';

import '../../template/state_management/controller.dart';

class AnalyticController extends FxController {
  bool isDataFetched = false;

  // General
  List<String> monthFilterList = [];
  DateTime now = DateTime.now();
  String currencyIndicator = "\$";

  // Pie Chart
  late String pieChartSelectedMonth;
  late int totalAmount;
  Map<Category, double> pieChartData = {};

  // Category List
  Map<Category, int> categoryTotalTransactions = {};

  // Line graph
  List<String> lineGraphFilterList = ["Week", "Month", "Year"];
  List<FlSpot> lineGraphSpot = [];

  int selectedLineGraphFilter = 0; //  0: Day, 1: Week, 2: Month
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

    fetchData();
  }

  void fetchData() async {
    // General
    currencyIndicator = MemberCache.appSetting.currencyIndicator;
    totalAmount = 1570;

    // Pie Chart
    pieChartSelectedMonth = monthFilterList[now.month - 1];
    pieChartData = {
      ExpenseCache.expenseCategories[0]: 100,
      ExpenseCache.expenseCategories[1]: 200,
      ExpenseCache.expenseCategories[2]: 300,
      ExpenseCache.expenseCategories[3]: 400,
      ExpenseCache.expenseCategories[4]: 500,
    };

    // Category List
    categoryTotalTransactions = {
      ExpenseCache.expenseCategories[0]: 2,
      ExpenseCache.expenseCategories[1]: 3,
      ExpenseCache.expenseCategories[2]: 4,
      ExpenseCache.expenseCategories[3]: 1,
      ExpenseCache.expenseCategories[4]: 2,
    };

    // Line Graph
    lineGraphSpot = [
      const FlSpot(1, 10),
      const FlSpot(2, 20),
      const FlSpot(3, 13),
      const FlSpot(4, 15),
      const FlSpot(5, 22),
      const FlSpot(6, 8),
      const FlSpot(7, 7),
    ];

    lineGraphTitle = "Feb 2023";
    lineGraphTotal = "+${currencyIndicator}5975.50";
    yAxisInterval = 5;
    xAxisInterval = 1;
    minY = 0;
    maxY = 25;
    minX = 1;
    maxX = 7;

    // Cash flow
    netProfit = 5975.50;
    totalIncome = 10000;
    totalExpense = 4024.50;

    isDataFetched = true;

    update();
  }

  void filterLineGraph(int index) {
    selectedLineGraphFilter = index;
    update();
  }

  void setMonthFilterLineGraph(String tmpValue) {
    pieChartSelectedMonth = tmpValue;
    update();
  }

  @override
  String getTag() {
    return "AnalyticController";
  }
}
