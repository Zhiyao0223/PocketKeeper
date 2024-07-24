import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/developer_controller.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/template/state_management/builder.dart';
import 'package:pocketkeeper/template/state_management/controller_store.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() {
    return _DeveloperScreenState();
  }
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  late CustomTheme customTheme;
  late DeveloperController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(DeveloperController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<DeveloperController>(
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
      appBar: buildCommonAppBar(
        headerTitle: "Developer Tools",
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          children: [
            // Enable auto categorization
            _buildEnableAutoCategorization(),
            const Divider(),

            // Get dummy data
            _buildListTileItem(
              icon: Icons.backup,
              title: "Get Dummy Data",
              onTapFunction: controller.getDummyData,
            ),

            // Reminder on recording budget
            _buildListTileItem(
              icon: Icons.restore,
              title: "Create Notification",
              onTapFunction: _buildNotificationList,
            ),

            // Clear all data
            _buildListTileItem(
              icon: Icons.delete,
              title: "Reset to Default",
              onTapFunction: controller.clearData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTileItem({
    required IconData icon,
    required String title,
    String? subTitle,
    Widget? trailingWidget,
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
          subtitle: subTitle != null
              ? FxText.bodySmall(subTitle, xMuted: true)
              : null,
          trailing: trailingWidget ?? const Icon(Icons.arrow_forward_ios),
          onTap: () {
            if (title == "Reset to Default") {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildCircularLoadingIndicator(),
                        const SizedBox(height: 20),
                        const FxText.bodyMedium("Resetting..."),
                      ],
                    ),
                  );
                },
              );
            }
            onTapFunction();
          },
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildEnableAutoCategorization() {
    return ListTile(
      leading: Icon(Icons.rocket, color: customTheme.colorPrimary),
      title: const FxText.labelMedium(
        "Enable Auto Categorization",
        xMuted: true,
      ),
      trailing: Transform.scale(
        scale: 0.75,
        child: Switch(
          activeTrackColor: customTheme.colorPrimary.withOpacity(0.5),
          value: MemberCache.appSetting!.isBiometricOn,
          onChanged: (value) {
            setState(() {
              MemberCache.isGeminiTunedModelEnable = value;
            });
          },
          activeColor: customTheme.colorPrimary,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  void _buildNotificationList() {
    // Appear a dialog box with multiple container to select (eg: Budget reminder, daily reminder for recording budget, etc)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const FxText.labelLarge(
            "Select Notification",
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: customTheme.colorPrimary,
                ),
                onPressed: () {
                  controller.localNotificationService.sendNotification(
                    channelId: "budget_reminder",
                    channelName: "Budget Reminder",
                    description: "You have spent 50% of your budget",
                  );
                },
                child: FxText.bodyMedium(
                  "Budget Reminder",
                  color: customTheme.white,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: customTheme.colorPrimary,
                ),
                onPressed: () {
                  controller.localNotificationService.sendNotification(
                    channelId: "daily_checkin",
                    channelName: "Daily Check-In",
                    description: "Don't forget to record your expenses daily!",
                  );
                },
                child: FxText.bodyMedium(
                  "Daily Reminder",
                  color: customTheme.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
