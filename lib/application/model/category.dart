import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

@Entity()
class Category {
  @Id(assignable: true)
  int categoryId = 0;

  late String categoryName;
  late int categoryType; // 0 = Expense, 1 = Income
  late int status;
  late IconData icon;
  late DateTime createdDate;
  late DateTime updatedDate;
  late Color iconColor;

  Category({
    String? tmpCategoryName,
    int? tmpStatus,
    int? tmpCategoryType,
    IconData? tmpIcon,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
    Color? tmpIconColor,
  }) {
    categoryName = tmpCategoryName ?? '';
    status = tmpStatus ?? 0;
    categoryType = tmpCategoryType ?? 0;
    icon = tmpIcon ?? Icons.category;
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
    iconColor = tmpIconColor ?? Colors.blue;
  }
}
