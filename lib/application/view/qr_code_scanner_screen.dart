import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/qr_code_scanner_controller.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../theme/custom_theme.dart';
import '../../template/state_management/state_management.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({super.key});

  @override
  State<QrCodeScannerScreen> createState() {
    return _QrCodeScannerState();
  }
}

class _QrCodeScannerState extends State<QrCodeScannerScreen> {
  late CustomTheme customTheme;
  late QrCodeScannerController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(QrCodeScannerController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<QrCodeScannerController>(
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

    return const Scaffold();
  }
}
