import 'package:fl_chart/fl_chart.dart';

import '../../template/state_management/controller.dart';

class AnalyticController extends FxController {
  bool isDataFetched = false;

  //  0: Day, 1: Week, 2: Month
  int selectedLineGraphFilter = 0;
  late double yAxisInterval;

  List<FlSpot> lineGraphSpot = [];

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    lineGraphSpot = [
      const FlSpot(1, 10),
      const FlSpot(2, 20),
      const FlSpot(3, 13),
      const FlSpot(4, 15),
      const FlSpot(5, 22),
      const FlSpot(6, 8),
      const FlSpot(7, 7),
    ];

    yAxisInterval = 5;

    isDataFetched = true;

    update();
  }

  void filterLineGraph(int index) {
    selectedLineGraphFilter = index;
    update();
  }

  @override
  String getTag() {
    return "AnalyticController";
  }
}
