import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/plain_controller.dart';
import 'package:pocketkeeper/template/state_management/builder.dart';
import 'package:pocketkeeper/template/state_management/controller_store.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';

class PlainScreen extends StatefulWidget {
  const PlainScreen({super.key});

  @override
  State<PlainScreen> createState() {
    return _PlainScreenState();
  }
}

class _PlainScreenState extends State<PlainScreen> {
  late CustomTheme customTheme;
  late PlainController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(PlainController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<PlainController>(
      controller: controller,
      builder: (controllers) {
        return _buildBody();
      },
    );
  }

  @override
  void dispose() {
    FxControllerStore.delete(controller);
    super.dispose();
  }

  Widget _buildBody() {
    // Check if all data loaded
    if (!controller.isDataFetched) {
      return buildCircularLoadingIndicator();
    }

    return const Scaffold();
  }
}
