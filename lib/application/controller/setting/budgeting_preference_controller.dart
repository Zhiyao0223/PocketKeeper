import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/app_setting.dart';
import 'package:pocketkeeper/application/model/currencies.dart';
import 'package:pocketkeeper/template/state_management/controller.dart';

class BudgetingPreferenceController extends FxController {
  bool isDataFetched = false;

  late AppSetting appSetting;

  int selectedCurrencyIndex = 0, selectedEndofMonthIndex = 0;

  List<Map<String, dynamic>> currencyDatabase = currencies;

  @override
  void initState() {
    super.initState();

    // Sort currency by code
    currencyDatabase.sort((a, b) => a["code"].compareTo(b["code"]));

    fetchData();
  }

  void fetchData() async {
    appSetting = MemberCache.appSetting;
    selectedEndofMonthIndex = appSetting.endOfMonth;

    // Find selected currency
    for (int i = 0; i < currencyDatabase.length; i++) {
      if (currencyDatabase[i]["code"] == appSetting.currencyCode) {
        selectedCurrencyIndex = i;
        break;
      }
    }

    isDataFetched = true;
    update();
  }

  void setCurrency(int index) {
    selectedCurrencyIndex = index;
    appSetting.currencyCode = currencyDatabase[index]["code"];
    appSetting.currencyIndicator = currencyDatabase[index]["symbol"];
    MemberCache.appSetting = appSetting;
    update();
  }

  void saveSettings() {
    appSetting.endOfMonth = selectedEndofMonthIndex;
    MemberCache.appSetting = appSetting;
  }

  @override
  String getTag() {
    return "BudgetingPreferenceController";
  }
}
