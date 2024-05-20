import '../../template/state_management/controller.dart';

class HomePageController extends FxController {
  bool isDataFetched = false;

  late int counter;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    counter = 0;

    isDataFetched = true;

    // Update() is same with setState(), rebuild UI
    update();
  }

  void incrementCounter() {
    counter++;
    update();
  }

  @override
  String getTag() {
    return "HomePageController";
  }
}
