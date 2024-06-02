import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/other_controller.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../template/state_management/state_management.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({Key? key}) : super(key: key);

  @override
  State<OtherScreen> createState() {
    return _OtherScreenState();
  }
}

class _OtherScreenState extends State<OtherScreen> {
  late CustomTheme customTheme;
  late OtherController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(OtherController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<OtherController>(
      controller: controller,
      builder: (controllers) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    // Prevent load UI if data is not finish load
    if (!controller.isDataFetched) {
      // Display spinner while loading
      return buildCircularLoadingIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Other Screen"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Other Screen"),
          ],
        ),
      ),
    );
  }
}
