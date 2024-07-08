import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/other_controller.dart';
import 'package:pocketkeeper/application/view/other/account_screen.dart';
import 'package:pocketkeeper/application/view/other/bill_screen.dart';
import 'package:pocketkeeper/application/view/other/goal_screen.dart';
import 'package:pocketkeeper/application/view/other/limit_screen.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../template/state_management/state_management.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({super.key});

  @override
  State<OtherScreen> createState() {
    return _OtherScreenState();
  }
}

class _OtherScreenState extends State<OtherScreen>
    with SingleTickerProviderStateMixin {
  late CustomTheme customTheme;
  late OtherController controller;

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(OtherController());
    tabController = TabController(length: 3, vsync: this);
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
      backgroundColor: customTheme.colorPrimary,
      appBar: buildCommonAppBar(
        headerTitle: 'Configurations',
        context: context,
        disableBackButton: true,
      ),
      body: Container(
        color: customTheme.white.withOpacity(0.87),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.25,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        switch (index) {
                          case 0:
                            return const GoalScreen();
                          case 1:
                            return const LimitScreen();
                          case 2:
                            return const BillScreen();
                          case 3:
                            return const AccountScreen();
                          default:
                            return Container();
                        }
                      }));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(
                          controller.categoriesHexColorData.values
                              .elementAt(index)['color']!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            IconData(
                              controller.categoriesHexColorData.values
                                  .elementAt(index)['categoryCode']!,
                              fontFamily: 'MaterialIcons',
                            ),
                            color: customTheme.white,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: FxText.bodyMedium(
                              controller.categoriesHexColorData.keys
                                  .elementAt(index),
                              color: customTheme.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
