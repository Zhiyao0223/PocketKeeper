import '../../../template/state_management/controller.dart';

class GoalController extends FxController {
  bool isDataFetched = false;

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
    return "GoalController";
  }
}
