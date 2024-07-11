import 'package:pocketkeeper/template/state_management/controller.dart';

class BackupRestoreController extends FxController {
  bool isDataFetched = false;

  // Constructor
  BackupRestoreController();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;
    update();
  }

  @override
  String getTag() {
    return "CurrencyConversionController";
  }
}
