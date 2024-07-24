import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/setting/budgeting_preference_controller.dart';
import 'package:pocketkeeper/template/state_management/builder.dart';
import 'package:pocketkeeper/template/state_management/controller_store.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';

class BudgetingPreferencesScreen extends StatefulWidget {
  const BudgetingPreferencesScreen({super.key});

  @override
  State<BudgetingPreferencesScreen> createState() {
    return _BudgetingPreferencesScreenState();
  }
}

class _BudgetingPreferencesScreenState
    extends State<BudgetingPreferencesScreen> {
  late CustomTheme customTheme;
  late BudgetingPreferenceController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(BudgetingPreferenceController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<BudgetingPreferenceController>(
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

    return Scaffold(
      appBar: buildCommonAppBar(headerTitle: "Preferences", context: context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Currency
            _buildListTileItem(
              icon: Icons.attach_money,
              title: "Currency",
              trailingWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FxText.labelLarge(
                    "${controller.appSetting.currencyIndicator} ${controller.appSetting.currencyCode}",
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTapFunction: () => _buildCurrencyList(),
            ),

            // Monthly Limit
            _buildListTileItem(
              icon: Icons.calendar_today,
              title: "Monthly Limit",
              trailingWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FxText.labelLarge(
                    "${controller.appSetting.currencyIndicator} ${controller.appSetting.monthlyLimit.removeExtraDecimal()}",
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTapFunction: () {
                // Open dialog to set monthly limit
                _buildMonthlyLimitDialog();
              },
            ),

            // No implement relevant function, so hide first
            // End of Month
            // _buildListTileItem(
            //   icon: Icons.calendar_today,
            //   title: "End of Month",
            //   trailingWidget: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       FxText.labelLarge(
            //         "${controller.appSetting.endOfMonth}",
            //       ),
            //       const SizedBox(width: 8),
            //       const Icon(Icons.chevron_right),
            //     ],
            //   ),
            //   onTapFunction: () {
            //     // Open dialog to set end of month
            //     _buildEndOfMonthDialog();
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTileItem({
    required IconData icon,
    required String title,
    required Widget trailingWidget,
    required Function() onTapFunction,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: customTheme.colorPrimary),
          title: FxText.labelMedium(
            title,
            xMuted: true,
          ),
          trailing: trailingWidget,
          onTap: onTapFunction,
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
      ],
    );
  }

  void _buildCurrencyList() {
    final ScrollController scrollController = ScrollController();

    // Calculate the offset to scroll to the selected currency
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double offset = controller.selectedCurrencyIndex * 72.0;
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
                controller.setCurrency(index);
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
                    if (controller.selectedCurrencyIndex == index)
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

  Future<void> _buildMonthlyLimitDialog() async {
    final TextEditingController textEditingController = TextEditingController()
      ..text = controller.appSetting.monthlyLimit.removeExtraDecimal();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const FxText.labelLarge(
            "Set Monthly Limit",
            textAlign: TextAlign.center,
          ),
          content: TextField(
            controller: textEditingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText:
                  "Monthly Limit (${controller.appSetting.currencyCode})",
              hintText: "Enter monthly limit",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const FxText.bodyMedium(
                "Cancel",
                xMuted: true,
              ),
            ),
            TextButton(
              onPressed: () {
                controller.appSetting.monthlyLimit =
                    double.parse(textEditingController.text);
                Navigator.pop(context);
              },
              child: FxText.bodyMedium(
                "Save",
                color: customTheme.colorPrimary,
              ),
            ),
          ],
        );
      },
    ).then((_) {
      controller.fetchData();
    });
  }

  // Future<void> _buildEndOfMonthDialog() async {
  //   await showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const FxText.labelLarge(
  //           "Set End of Month",
  //           textAlign: TextAlign.center,
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Row(
  //               children: [
  //                 const FxText.labelMedium("Select day:"),
  //                 const Spacer(),
  //                 DropdownButton<int>(
  //                   dropdownColor: customTheme.lightGrey,
  //                   menuMaxHeight: MediaQuery.of(context).size.height * 0.4,
  //                   value: controller.appSetting.endOfMonth,
  //                   items: List.generate(30, (index) {
  //                     return DropdownMenuItem<int>(
  //                       value: index + 1,
  //                       child: FxText.bodyMedium(
  //                         "${index + 1}",
  //                       ),
  //                     );
  //                   }),
  //                   onChanged: (int? value) {
  //                     if (value != null) {
  //                       controller.appSetting.endOfMonth = value;
  //                       Navigator.pop(context);
  //                     }
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   ).then((_) {
  //     controller.fetchData();
  //   });
  // }
}
