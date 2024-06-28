import '../../template/state_management/controller.dart';

class QrCodeScannerController extends FxController {
  bool isDataFetched = false;

  // Contructor
  QrCodeScannerController();

  @override
  void initState() {
    super.initState();

    // Fetch data
    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;

    update();
  }

  @override
  String getTag() {
    return "QrCodeScannerController";
  }
}
