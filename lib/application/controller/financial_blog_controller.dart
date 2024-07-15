import 'package:pocketkeeper/application/model/financial_blog.dart';
import 'package:pocketkeeper/template/state_management/controller.dart';

class FinancialBlogController extends FxController {
  bool isDataFetched = false, isShowMoreAdvice = false;

  List<FinancialBlog> blogs = [];

  // Constructor
  FinancialBlogController();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    blogs = [
      FinancialBlog(
        tmpId: 1,
        tmpBlogTitle: "How to save money",
        tmpAuthorName: "John Doe",
        tmpStatus: 1,
        tmpAverageReadingTime: 5,
        tmpCreatedDate: DateTime.now(),
        tmpUpdatedDate: DateTime.now(),
        tmpBlogImage: null,
        tmpUrl: "https://www.google.com",
      ),
      FinancialBlog(
        tmpId: 2,
        tmpBlogTitle: "How to invest in stocks",
        tmpAuthorName: "Jane Doe",
        tmpStatus: 1,
        tmpAverageReadingTime: 10,
        tmpCreatedDate: DateTime.now(),
        tmpUpdatedDate: DateTime.now(),
        tmpBlogImage: null,
      ),
      FinancialBlog(
        tmpId: 3,
        tmpBlogTitle: "How to save money",
        tmpAuthorName: "John Doe",
        tmpStatus: 1,
        tmpAverageReadingTime: 5,
        tmpCreatedDate: DateTime.now(),
        tmpUpdatedDate: DateTime.now(),
        tmpBlogImage: null,
      ),
      FinancialBlog(
        tmpId: 4,
        tmpBlogTitle: "How to invest in stocks",
        tmpAuthorName: "Jane Doe",
        tmpStatus: 1,
        tmpAverageReadingTime: 10,
        tmpCreatedDate: DateTime.now(),
        tmpUpdatedDate: DateTime.now(),
        tmpBlogImage: null,
      ),
      FinancialBlog(
        tmpId: 5,
        tmpBlogTitle: "How to save money",
        tmpAuthorName: "John Doe",
        tmpStatus: 1,
        tmpAverageReadingTime: 5,
        tmpCreatedDate: DateTime.now(),
        tmpUpdatedDate: DateTime.now(),
        tmpBlogImage: null,
      ),
    ];

    isDataFetched = true;
    update();
  }

  @override
  String getTag() {
    return "FinancialBlogController";
  }
}
