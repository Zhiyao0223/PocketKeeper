import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/enum/read_status.dart';
import 'package:pocketkeeper/application/model/notification.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class NotificationService extends ObjectboxService<Notifications> {
  NotificationService() : super(MemberCache.objectBox!.store, Notifications);

  // Update all notifications to read
  void updateAllToRead() {
    final List<Notifications> notifications = getAll();
    for (final Notifications notification in notifications) {
      notification.readStatus = ReadStatus.read.index;
    }

    // Update all
    putMany(notifications);
  }

  // Get total unread notification count
  int getUnreadNotificationCount() {
    final List<Notifications> notifications = getAll();
    return notifications
        .where((Notifications notification) =>
            notification.readStatus != ReadStatus.read.index)
        .length;
  }
}
