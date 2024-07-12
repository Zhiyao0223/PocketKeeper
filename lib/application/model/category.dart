import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

@Entity()
class Category {
  int id = 0;

  late String categoryName;
  late int categoryType; // 0 = Expense, 1 = Income
  late int status;
  late int iconHex;

  @Property(type: PropertyType.date)
  late DateTime createdDate;

  @Property(type: PropertyType.date)
  late DateTime updatedDate;

  // Store color as ARGB integer
  late int iconColor;

  Category({
    int? tmpId,
    String? tmpCategoryName,
    int? tmpStatus,
    int? tmpCategoryType,
    int? tmpIconHex,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
    Color? tmpIconColor,
  }) {
    id = tmpId ?? 0;
    categoryName = tmpCategoryName ?? '';
    status = tmpStatus ?? 0;
    categoryType = tmpCategoryType ?? 0;
    iconHex = tmpIconHex ?? Icons.store.codePoint;
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
    iconColor = tmpIconColor?.value ?? Colors.blue.value;
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'categoryType': categoryType,
      'status': status,
      'iconHex': iconHex,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
      'iconColor': iconColor,
    };
  }
}
