import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/other_controller.dart';
import 'package:pocketkeeper/application/view/other/account_screen.dart';
import 'package:pocketkeeper/application/view/other/goal_screen.dart';
import 'package:pocketkeeper/application/view/other/limit_screen.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:pocketkeeper/widget/will_pop_dialog.dart';
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

  bool billScreenAllow = false;

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

    return PopScope(
      canPop: false,
      onPopInvoked: (_) => buildWillPopDialog(context),
      child: Scaffold(
        appBar: buildCommonAppBar(
          headerTitle: 'Configurations',
          context: context,
          disableBackButton: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/configuration_bg.jpg',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.labelLarge(
                    'Your Financial Journey Begins Here!',
                    color: customTheme.colorPrimary,
                  ),
                  FxText.bodySmall(
                    'Start managing your finance with these options.',
                    color: customTheme.black,
                    xMuted: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(16),
                itemCount: controller.categoriesHexColorData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (billScreenAllow) ? 2 : 1,
                  childAspectRatio: (billScreenAllow) ? 1.25 : 4,
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
                            // return const BillScreen();
                            // case 3:
                            return const AccountScreen();
                          default:
                            return Container();
                        }
                      }));
                    },
                    child: _buildGridViewContainer(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridViewContainer(int index) {
    return (billScreenAllow)
        // With bill screen
        ? Container(
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
                    controller.categoriesHexColorData.keys.elementAt(index),
                    color: customTheme.white,
                  ),
                ),
              ],
            ),
          )
        // Without bill screen
        : Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(
                controller.categoriesHexColorData.values
                    .elementAt(index)['color']!,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
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
                const SizedBox(width: 10),
                Center(
                  child: FxText.bodyMedium(
                    controller.categoriesHexColorData.keys.elementAt(index),
                    color: customTheme.white,
                  ),
                ),
              ],
            ),
          );
  }
}
