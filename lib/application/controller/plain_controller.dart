import 'package:pocketkeeper/template/state_management/controller.dart';

class PlainController extends FxController {
  bool isDataFetched = false;

  // Constructor
  PlainController();

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
    return "PlainController";
  }
}
