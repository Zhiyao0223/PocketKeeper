import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/enum/read_status.dart';
import 'package:pocketkeeper/application/model/notification.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class NotificationService extends ObjectboxService<Notifications> {
  NotificationService() : super(MemberCache.objectBox!.store, Notifications);

  // Update all notifications to read
  int updateAllToRead() {
    int updatedCount = 0;

    final List<Notifications> notifications = getAll();
    for (final Notifications notification in notifications) {
      if (notification.readStatus != ReadStatus.read.index) {
        notification.readStatus = ReadStatus.read.index;
        updatedCount++;
      }
    }

    // Update all
    putMany(notifications);

    return updatedCount;
  }

  // Get total unread notification count
  int getUnreadNotificationCount() {
    final List<Notifications> notifications = getAll();
    return notifications
        .where((Notifications notification) =>
            notification.readStatus != ReadStatus.read.index)
        .length;
  }

  void restoreBackup(Map<String, dynamic> data) {
    if (data['notifications'] == null) {
      return;
    }

    final List<Notifications> expenses = data['notifications']
        .map<Notifications>((dynamic entity) => Notifications.fromJson(entity))
        .toList();

    putMany(expenses);
  }
}
