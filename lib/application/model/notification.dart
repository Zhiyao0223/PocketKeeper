import 'package:objectbox/objectbox.dart';
import 'package:pocketkeeper/application/model/enum/notification_type.dart';
import 'package:pocketkeeper/application/model/enum/read_status.dart';
import 'package:pocketkeeper/application/model/enum/sync_status.dart';

@Entity()
class Notifications {
  @Id(assignable: true)
  late int notificationId;

  late String title;
  late String description;
  late int notificationType;
  late int readStatus;

  late int syncStatus;
  late int status;
  late DateTime createdDate;
  late DateTime updatedDate;

  Notifications({
    int? tmpNotificationId,
    String? tmpTitle,
    String? tmpDescription,
    NotificationType? tmpNotificationType,
    ReadStatus? tmpReadStatus,
    SyncStatus? tmpSyncStatus,
    int? tmpStatus,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
  }) {
    notificationId = tmpNotificationId ?? 0;
    title = tmpTitle ?? '';
    description = tmpDescription ?? '';
    notificationType =
        tmpNotificationType?.index ?? NotificationType.none.index;
    readStatus = tmpReadStatus?.index ?? ReadStatus.none.index;

    syncStatus = tmpSyncStatus?.index ?? SyncStatus.none.index;
    status = tmpStatus ?? 0;
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
  }
}
