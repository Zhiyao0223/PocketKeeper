import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/analytic_controller.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../template/state_management/state_management.dart';

class AnalyticScreen extends StatefulWidget {
  const AnalyticScreen({super.key});

  @override
  State<AnalyticScreen> createState() {
    return _AnalyticScreenState();
  }
}

class _AnalyticScreenState extends State<AnalyticScreen> {
  late CustomTheme customTheme;
  late AnalyticController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(AnalyticController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<AnalyticController>(
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
        title: Text("Analytics"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Analytics"),
          ],
        ),
      ),
    );
  }
}
