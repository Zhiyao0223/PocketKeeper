import 'package:pocketkeeper/application/member_cache.dart';

import '../../template/state_management/controller.dart';

class BillController extends FxController {
  bool isDataFetched = false;

  String currencyIndicator = "\$";

  int selectedTabIndex = 0;
  double monthlySubscription = 0, monthlyBill = 0;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    currencyIndicator = MemberCache.appSetting!.currencyIndicator;

    monthlySubscription = 61.88;

    isDataFetched = true;
    update();
  }

  @override
  String getTag() {
    return "BillController";
  }
}
