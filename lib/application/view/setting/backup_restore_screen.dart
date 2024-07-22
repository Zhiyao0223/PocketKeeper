import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/setting/backup_restore_controller.dart';
import 'package:pocketkeeper/template/state_management/builder.dart';
import 'package:pocketkeeper/template/state_management/controller_store.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() {
    return _BackupRestoreScreenState();
  }
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  late CustomTheme customTheme;
  late BackupRestoreController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(BackupRestoreController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<BackupRestoreController>(
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          children: [
            // Backup
            _buildListTileItem(
              icon: Icons.backup,
              title: "Backup",
              subTitle: controller.getLastBackupDate(),
              onTapFunction: controller.backupData,
            ),

            // Restore
            _buildListTileItem(
              icon: Icons.restore,
              title: "Restore",
              subTitle: controller.getLastRestoreDate(),
              onTapFunction: controller.restoreData,
            ),

            // Export
            _buildListTileItem(
              icon: Icons.file_download,
              title: "Export as CSV",
              onTapFunction: controller.exportData,
            ),

            // Resync
            _buildListTileItem(
              icon: Icons.sync,
              title: "Resync Data",
              subTitle: controller.getLastResyncDate(),
              onTapFunction: controller.resyncData,
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
          onTap: () async {
            if (title != "Resync Data") {
              showLoadingDialog(isBackup: title == "Backup");
            }
            onTapFunction();
          },
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
      ],
    );
  }

  void showLoadingDialog({bool isBackup = false}) {
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
              FxText.bodyMedium(isBackup ? "Uploading..." : "Downloading..."),
            ],
          ),
        );
      },
    );
  }
}
