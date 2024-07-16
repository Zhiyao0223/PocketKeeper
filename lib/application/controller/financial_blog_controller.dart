import 'dart:developer';

import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/model/financial_blog.dart';
import 'package:pocketkeeper/application/service/api_service.dart';
import 'package:pocketkeeper/application/service/gemini_service.dart';
import 'package:pocketkeeper/template/state_management/controller.dart';

class FinancialBlogController extends FxController {
  bool isDataFetched = false, isShowMoreAdvice = false;

  List<FinancialBlog> blogs = [];
  List<String> advices = [];

  // Constructor
  FinancialBlogController();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    await fetchAdvice();
    await fetchBlogs();

    isDataFetched = true;
    update();
  }

  Future<void> fetchBlogs() async {
    try {
      const String filename = "get-blog.php";
      Map<String, dynamic> requestBody = {
        "process": "get_blog",
      };

      Map<String, dynamic> responseJson = await ApiService.post(
        filename: filename,
        body: requestBody,
      );

      // Store all blogs into cache
      if (responseJson["status"] == 200) {
        ExpenseCache.blogs.clear();

        for (var blog in responseJson["body"]["blogs"]) {
          FinancialBlog financialBlog = FinancialBlog.fromJson(blog);
          ExpenseCache.blogs.add(financialBlog);
        }

        blogs = ExpenseCache.blogs;
        log("Get blog successful!");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> fetchAdvice() async {
    GeminiService geminiService = GeminiService(true);

    try {
      String advice = await geminiService.generateAdvice();

      // Split by new line
      advices = advice.split("\n");
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  String getTag() {
    return "FinancialBlogController";
  }
}
