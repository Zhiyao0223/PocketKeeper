import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketkeeper/application/model/enum/notification_type.dart';
import 'package:pocketkeeper/application/model/enum/read_status.dart';
import 'package:pocketkeeper/application/model/notification.dart';
import 'package:pocketkeeper/application/service/notification_service.dart';
import 'package:pocketkeeper/utils/custom_animation.dart';

import '../../template/state_management/controller.dart';

class NotificationController extends FxController {
  bool isDataFetched = false;

  // Animation
  late TickerProvider ticker;
  late CustomAnimation emailAnimation, passwordAnimation;

  // Variables
  List<Notifications> notifications = [];

  // Constructor
  NotificationController();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    // Get data from objectbox
    try {
      notifications = NotificationService().getAll();
    } catch (e) {
      log(e.toString());
    }

    // Add default message if no notification
    if (notifications.isEmpty) {
      notifications = [
        Notifications(
          tmpTitle: "Welcome to PocketKeeper",
          tmpDescription:
              "Thank you for using PocketKeeper. Start managing your expenses now!",
          tmpNotificationType: NotificationType.none,
          tmpReadStatus: ReadStatus.unread,
          tmpCreatedDate: DateTime.now(),
        ),
      ];

      // Add into objectbox
      for (var element in notifications) {
        NotificationService().add(element);
      }
    }

    isDataFetched = true;

    update();
  }

  // Update single notification to read
  void updateReadStatus(Notifications notification) {
    // Update objectbox
    notification.readStatus = ReadStatus.read.index;
    NotificationService().put(notification);

    // Update UI
    fetchData();
  }

  // Mark all unseen notification as read
  void markAllAsRead() {
    // Update objectbox
    NotificationService().updateAllToRead();
  }

  // Return formmated date time
  String formatDateTime(DateTime dateTime) {
    // Define the date format
    final DateFormat formatter = DateFormat('dd/MM/yy - h:mm a');

    return formatter.format(dateTime);
  }

  @override
  String getTag() {
    return "NotificationController";
  }
}
