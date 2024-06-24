import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

@Entity()
class Category {
  @Id(assignable: true)
  late int categoryId;

  late String categoryName;
  late int status;
  late DateTime createdDate;
  late DateTime updatedDate;

  Category({
    int? tmpCategoryId,
    String? tmpCategoryName,
    int? tmpStatus,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
  }) {
    categoryId = tmpCategoryId ?? 0;
    categoryName = tmpCategoryName ?? '';
    status = tmpStatus ?? 0;
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
  }
}
