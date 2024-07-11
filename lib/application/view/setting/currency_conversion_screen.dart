import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/setting/currency_conversion_controller.dart';
import 'package:pocketkeeper/template/state_management/builder.dart';
import 'package:pocketkeeper/template/state_management/controller_store.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';

class CurrencyConversionScreen extends StatefulWidget {
  const CurrencyConversionScreen({super.key});

  @override
  CurrencyConversionScreenState createState() =>
      CurrencyConversionScreenState();
}

class CurrencyConversionScreenState extends State<CurrencyConversionScreen> {
  late CustomTheme customTheme;
  late CurrencyConversionController controller;

  FocusNode amountFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FxBuilder<CurrencyConversionController>(
      controller: controller,
      builder: (controllers) {
        return _buildBody();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(CurrencyConversionController());
  }

  @override
  void dispose() {
    FxControllerStore.delete(controller);
    super.dispose();
  }

  Widget _buildBody() {
    if (!controller.isDataFetched) {
      return buildCircularLoadingIndicator();
    }

    return Scaffold(
      appBar: buildCommonAppBar(
          headerTitle: "Currency Converter", context: context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Form(
                        key: controller.formKey,
                        child: TextFormField(
                          onTapOutside: (_) {
                            amountFocusNode.unfocus();
                          },
                          focusNode: amountFocusNode,
                          validator: controller.validateAmount,
                          controller: controller.amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // From currency
                          InkWell(
                            onTap: () {
                              _buildCurrencyList(true);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  FxText.bodyMedium(
                                    controller.currencyDatabase[
                                        controller.fromCurrencyIndex]['code'],
                                  ),
                                  const Icon(Icons.arrow_drop_down_rounded)
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              controller.swapCurrency();
                            },
                            child: Icon(
                              Icons.swap_horiz,
                              color: customTheme.colorPrimary,
                            ),
                          ),
                          // To currency
                          InkWell(
                            onTap: () {
                              _buildCurrencyList(false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  FxText.bodyMedium(
                                    controller.currencyDatabase[
                                        controller.toCurrencyIndex]['code'],
                                  ),
                                  const Icon(Icons.arrow_drop_down_rounded)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: customTheme.colorPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.convert();
                  }
                },
                child: FxText.bodyMedium(
                  'Convert',
                  color: customTheme.white,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.bodyMedium(
                      'Result',
                      xMuted: true,
                      color: customTheme.grey,
                    ),
                    const SizedBox(height: 8),
                    FxText.labelLarge(
                      "${controller.targetCurrencySymbol} ${controller.result.removeExtraDecimal()}",
                      fontSize: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _buildCurrencyList(bool isFromCurrency) {
    final scrollController = ScrollController();

    // Calculate the offset to scroll to the selected currency
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int currencyIndex = (isFromCurrency)
          ? controller.fromCurrencyIndex
          : controller.toCurrencyIndex;

      double offset = currencyIndex * 72.0;

      scrollController.jumpTo(offset);
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.separated(
          controller: scrollController,
          itemCount: controller.currencyDatabase.length,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> currency =
                controller.currencyDatabase[index];

            return InkWell(
              onTap: () {
                controller.setCurrency(isFromCurrency, index);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: customTheme.colorPrimary,
                      child: FxText.labelLarge(
                        "${currency["symbol"]}",
                        color: customTheme.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        FxText.bodySmall(
                          currency['name'].length > 30
                              ? currency['name'].substring(0, 30)
                              : currency['name'],
                        ),
                        FxText.labelMedium(
                          " - ${currency['code']}",
                          xMuted: true,
                        )
                      ],
                    ),
                    const Spacer(),
                    if (isFromCurrency && controller.fromCurrencyIndex == index)
                      const Icon(Icons.check),
                    if (!isFromCurrency && controller.toCurrencyIndex == index)
                      const Icon(Icons.check),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(height: 1, thickness: 1);
          },
        );
      },
    );
  }
}
