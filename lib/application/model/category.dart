import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

@Entity()
class Category {
  @Id(assignable: true)
  late int categoryId;

  late String categoryName;
  late int status;
  late Icon icon;
  late DateTime createdDate;
  late DateTime updatedDate;

  Category({
    int? tmpCategoryId,
    String? tmpCategoryName,
    int? tmpStatus,
    Icon? tmpIcon,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
  }) {
    categoryId = tmpCategoryId ?? 0;
    categoryName = tmpCategoryName ?? '';
    status = tmpStatus ?? 0;
    icon = tmpIcon ?? const Icon(Icons.category);
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
  }
}
