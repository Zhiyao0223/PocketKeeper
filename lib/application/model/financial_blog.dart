import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

@Entity()
class FinancialBlog {
  int id = 0;

  late String title;
  late String author;
  late String? blogImage;
  late String? authorImage;
  late String? url;
  late int averageReadingTime;
  late int status;

  @Property(type: PropertyType.date)
  late DateTime createdDate;

  @Property(type: PropertyType.date)
  late DateTime updatedDate;

  FinancialBlog({
    int? tmpId,
    String? tmpBlogTitle,
    String? tmpAuthorName,
    String? tmpUrl,
    int? tmpStatus,
    int? tmpAverageReadingTime,
    String? tmpBlogImage,
    String? tmpAuthorImage,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
  }) {
    id = tmpId ?? 0;
    title = tmpBlogTitle ?? '';
    status = tmpStatus ?? 0;
    url = tmpUrl ?? '';
    author = tmpAuthorName ?? '';
    averageReadingTime = tmpAverageReadingTime ?? 1;
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
    blogImage = tmpBlogImage;
    authorImage = tmpAuthorImage;
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blogTitle': title,
      'author': author,
      'averageReadingTime': averageReadingTime,
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
    };
  }

  // From JSON
  factory FinancialBlog.fromJson(Map<String, dynamic> json) {
    return FinancialBlog(
      tmpId: int.tryParse(json['blog_id'] ?? 0),
      tmpBlogTitle: json['title'],
      tmpAuthorName: json['author_name'],
      tmpBlogImage: json['image'],
      tmpAuthorImage: json['author_image'],
      tmpUrl: json['url'],
      tmpAverageReadingTime: int.tryParse(json['average_reading_time']),
      tmpStatus: int.tryParse(json['status']),
      tmpCreatedDate: DateTime.parse(json['created_date']),
      tmpUpdatedDate: DateTime.parse(json['updated_date']),
    );
  }
}
