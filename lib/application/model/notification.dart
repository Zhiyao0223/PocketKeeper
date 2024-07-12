import 'package:objectbox/objectbox.dart';
import 'package:pocketkeeper/application/model/enum/notification_type.dart';
import 'package:pocketkeeper/application/model/enum/read_status.dart';
import 'package:pocketkeeper/application/model/enum/sync_status.dart';

@Entity()
class Notifications {
  @Id(assignable: true)
  int id = 0;

  late String title;
  late String description;
  late int notificationType;
  late int readStatus;

  late int syncStatus;
  late int status;

  @Property(type: PropertyType.date)
  late DateTime createdDate;

  @Property(type: PropertyType.date)
  late DateTime updatedDate;

  Notifications({
    String? tmpTitle,
    String? tmpDescription,
    NotificationType? tmpNotificationType,
    ReadStatus? tmpReadStatus,
    SyncStatus? tmpSyncStatus,
    int? tmpStatus,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
  }) {
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

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'notificationType': notificationType,
      'readStatus': readStatus,
      'syncStatus': syncStatus,
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
    };
  }
}
