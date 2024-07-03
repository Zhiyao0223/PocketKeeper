import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/receipt_scanner_controller.dart';
import 'package:pocketkeeper/application/view/form_add_expenses_screen.dart';
import 'package:pocketkeeper/template/utils/spacing.dart';
import 'package:pocketkeeper/template/widgets/button/button.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../theme/custom_theme.dart';
import '../../template/state_management/state_management.dart';

class ReceiptScannerScreen extends StatefulWidget {
  const ReceiptScannerScreen({super.key});

  @override
  State<ReceiptScannerScreen> createState() {
    return _ReceiptScannerState();
  }
}

class _ReceiptScannerState extends State<ReceiptScannerScreen> {
  late CustomTheme customTheme;
  late ReceiptScannerController controller;

  @override
  void initState() {
    super.initState();

    customTheme = CustomTheme();

    controller = FxControllerStore.put(ReceiptScannerController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ReceiptScannerController>(
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
      appBar: _buildAppbar(),
      body: Scaffold(
        body: (controller.picture.isNotEmpty)
            ? _buildImageView()
            : _buildNoImageView(),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      toolbarHeight: kToolbarHeight + 1,
      title: FxText.labelLarge(
        'QR Code Scanner',
        color: customTheme.white,
      ),
      centerTitle: true,
      backgroundColor: customTheme.lightPurple,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: customTheme.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  // Photoview at top with confirmation button at bottom right
  Widget _buildImageView() {
    return Stack(
      children: [
        Image.file(
          File(controller.picture),
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
        // Retake
        Positioned(
          bottom: 16,
          left: 16,
          child: FxButton.rounded(
            padding: FxSpacing.all(16),
            backgroundColor: customTheme.colorPrimary,
            onPressed: () {
              controller.scanReceipt().then((value) {
                setState(() {});
              });
            },
            child: FxText.labelMedium(
              "Retake",
              color: customTheme.white,
            ),
          ),
        ),

        // Confirm
        Positioned(
          bottom: 16,
          right: 16,
          child: FxButton.rounded(
            padding: FxSpacing.all(16),
            backgroundColor: customTheme.colorPrimary,
            onPressed: () => controller.confirmReceipt().then((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => FormAddExpensesScreen(
                    selectedExpense: controller.selectedExpenses,
                  ),
                ),
                (route) => false,
              );
            }),
            child: FxText.labelMedium(
              "Confirm",
              color: customTheme.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoImageView() {
    return Center(
      child: FxButton.rounded(
        padding: FxSpacing.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: customTheme.colorPrimary,
        onPressed: () => controller.scanReceipt().then((value) {
          setState(() {});
        }),
        child: FxText.labelMedium(
          "Scan / Upload Receipt",
          color: customTheme.white,
        ),
      ),
    );
  }
}
