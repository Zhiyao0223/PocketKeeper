import '../../template/state_management/controller.dart';

class NavigationController extends FxController {
  bool isDataFetched = false;

  // Navigation Index
  int bottomNavIndex = 0;

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
    return "NavigationController";
  }
}
