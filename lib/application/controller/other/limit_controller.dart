import 'package:pocketkeeper/utils/converters/number.dart';

import '../../../template/state_management/controller.dart';

class LimitController extends FxController {
  bool isDataFetched = false;

  int availableBalance = 1000, remainingDays = 10;
  double totalSpent = 500, totalBudget = 1000, chartProgress = 0.5;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;

    update();
  }

  String getTotalBudget() {
    return customFormatNumber(totalBudget.toInt());
  }

  String getTotalSpent() {
    return customFormatNumber(totalSpent.toInt());
  }

  /*
  Format number to k, M
  1000 => 1k
  1000000 => 1M
  */
  String customFormatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).removeExtraDecimal()} M';
    } else if (number >= 1000) {
      return '${(number / 1000).removeExtraDecimal()} K';
    } else {
      return number.toString();
    }
  }

  @override
  String getTag() {
    return "LimitController";
  }
}
