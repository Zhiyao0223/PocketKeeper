// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/notification_controller.dart';
import 'package:pocketkeeper/application/model/enum/notification_type.dart';
import 'package:pocketkeeper/application/model/enum/read_status.dart';
import 'package:pocketkeeper/application/model/notification.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';
import '../../template/state_management/state_management.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() {
    return _NotificationScreenState();
  }
}

class _NotificationScreenState extends State<NotificationScreen> {
  late CustomTheme customTheme;
  late NotificationController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(NotificationController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<NotificationController>(
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
      appBar: AppBar(
        title: const FxText.titleMedium('Notifications'),
        centerTitle: true,
        backgroundColor: customTheme.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.checklist,
              color: customTheme.colorPrimary,
            ),
            onPressed: () {
              setState(() {
                controller.markAllAsRead();
                showToast(customMessage: 'All notifications marked as read');
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
        children: [
          for (Notifications notificationItem in controller.notifications)
            _buildNotificationItem(notificationItem),
        ],
      ),
    );
  }

  // Build notification box
  Widget _buildNotificationItem(
    Notifications notificationItem,
  ) {
    bool isHighlighted = notificationItem.readStatus != ReadStatus.unread.index;
    String formatDateTime =
        controller.formatDateTime(notificationItem.createdDate);

    // Determine icon and its colour
    IconData icon;
    Color iconColor;

    if (notificationItem.notificationType == NotificationType.info.index) {
      icon = Icons.info_outline;
      iconColor = customTheme.colorPrimary;
    } else if (notificationItem.notificationType ==
        NotificationType.warning.index) {
      icon = Icons.warning_amber_rounded;
      iconColor = customTheme.onWarning;
    } else if (notificationItem.notificationType ==
        NotificationType.error.index) {
      icon = Icons.error_outline;
      iconColor = customTheme.onError;
    } else if (notificationItem.notificationType ==
        NotificationType.success.index) {
      icon = Icons.check_circle_outline;
      iconColor = customTheme.onSuccess;
    } else if (notificationItem.notificationType ==
        NotificationType.none.index) {
      icon = Icons.article;
      iconColor = customTheme.colorPrimary;
    } else {
      icon = Icons.article;
      iconColor = customTheme.colorPrimary;
    }

    return InkWell(
      onTap: () {
        // Only executed if notification is not read to prevent continous setState
        if (isHighlighted == false) {
          controller.updateReadStatus(notificationItem);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isHighlighted
              ? customTheme.grey.withOpacity(0.05)
              : customTheme.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundColor: iconColor.withOpacity(0.1),
              child: Icon(icon, color: iconColor, size: 20.0),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.caption(
                    formatDateTime,
                    xMuted: true,
                  ),
                  const SizedBox(height: 5.0),
                  FxText.labelMedium(
                    notificationItem.title,
                  ),
                  const SizedBox(height: 5.0),
                  FxText.caption(
                    notificationItem.description,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
