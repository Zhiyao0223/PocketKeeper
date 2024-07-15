import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/financial_blog_controller.dart';
import 'package:pocketkeeper/application/model/financial_blog.dart';
import 'package:pocketkeeper/template/state_management/builder.dart';
import 'package:pocketkeeper/template/state_management/controller_store.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class FinancialBlogScreen extends StatefulWidget {
  const FinancialBlogScreen({super.key});

  @override
  State<FinancialBlogScreen> createState() {
    return _FinancialBlogScreenState();
  }
}

class _FinancialBlogScreenState extends State<FinancialBlogScreen> {
  late CustomTheme customTheme;
  late FinancialBlogController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(FinancialBlogController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<FinancialBlogController>(
      controller: controller,
      builder: (controllers) {
        return _buildBody();
      },
    );
  }

  @override
  void dispose() {
    FxControllerStore.delete(controller);
    super.dispose();
  }

  Widget _buildBody() {
    // Check if all data loaded
    if (!controller.isDataFetched) {
      return buildCircularLoadingIndicator();
    }

    return Scaffold(
      backgroundColor: customTheme.lightPurple,
      appBar: buildSafeAreaAppBar(appBarColor: customTheme.lightPurple),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Appbar
            buildCommonAppBar(headerTitle: "Discover", context: context),

            Container(
              color: customTheme.white.withOpacity(0.87),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Advice
                  _buildAdviceSection(),

                  // Blog List
                  _buildBlogList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdviceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: customTheme.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: customTheme.lightGrey,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRect(
            child: SizedBox(
              height: controller.isShowMoreAdvice ? null : 150,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FxText.labelLarge(
                      "Advice",
                      fontSize: 18,
                    ),
                    const SizedBox(height: 8),
                    const FxText.bodyMedium(
                      "Here are some tips to help you manage your finances better.",
                      xMuted: true,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "1. Set a budget and stick to it.",
                      style: TextStyle(
                        fontSize: 14,
                        color: customTheme.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "2. Save for emergencies.",
                      style: TextStyle(
                        fontSize: 14,
                        color: customTheme.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "3. Pay off your debts.",
                      style: TextStyle(
                        fontSize: 14,
                        color: customTheme.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Show more
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    controller.isShowMoreAdvice = !controller.isShowMoreAdvice;
                  });
                },
                child: FxText.bodyMedium(
                  controller.isShowMoreAdvice ? "Show less" : "Show more",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBlogList() {
    return Column(
      children: [
        for (int index = 0; index < controller.blogs.length; index++)
          _buildBlogItem(controller.blogs[index]),
      ],
    );
  }

  Widget _buildBlogItem(FinancialBlog blog) {
    return InkWell(
      onTap: () {
        if (blog.url != null && blog.url!.isNotEmpty) {
          launchUrl(Uri.parse(blog.url!));
        }
      },
      child: Container(
        height: 140,
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: customTheme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: customTheme.lightGrey,
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: blog.blogImage ??
                  "https://cdn.dribbble.com/users/915817/screenshots/5834160/mobile-blog-app_4x.jpg?resize=1000x750&vertical=center",
              width: 75,
              height: 110,
              fit: BoxFit.cover,
              placeholder: (context, url) => buildCircularLoadingIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.labelLarge(
                    blog.title.length > 60
                        ? "${blog.title.substring(0, 60)}..."
                        : blog.title,
                    textAlign: TextAlign.justify,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: blog.authorImage ??
                              "https://cdn.dribbble.com/users/915817/screenshots/5834160/mobile-blog-app_4x.jpg?resize=1000x750&vertical=center",
                          width: 25,
                          height: 25,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              buildCircularLoadingIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FxText.labelSmall(
                        blog.author.length > 15
                            ? "${blog.author.substring(0, 15)}..."
                            : blog.author,
                      ),
                      const Spacer(),
                      FxText.bodySmall(
                        "•${blog.averageReadingTime} min read",
                        xMuted: true,
                        color: customTheme.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
