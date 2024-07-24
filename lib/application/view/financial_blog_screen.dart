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
import 'package:pocketkeeper/widget/shimmer_placeholder.dart';
import 'package:shimmer/shimmer.dart';
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
                    FxText.labelLarge(
                      "Financial Advice",
                      fontSize: 16,
                      color: customTheme.colorPrimary,
                    ),
                    const SizedBox(height: 8),

                    // Advice Text
                    if (controller.isDataFetched &&
                        !controller.isAdviceException)
                      for (String advice in controller.advices) ...[
                        FxText.bodyMedium(
                          advice,
                          textAlign: TextAlign.justify,
                          xMuted: true,
                        ),
                      ],
                    if (controller.isAdviceException)
                      const FxText.bodyMedium(
                        "Failed to fetch advice. Please check your internet connection.",
                        textAlign: TextAlign.justify,
                        xMuted: true,
                      )
                    else
                      for (int index = 0; index < 3; index++)
                        _buildShimmerWidget(buildTitlePlaceholder()),
                  ],
                ),
              ),
            ),
          ),
          // Show more
          const SizedBox(height: 8),
          if (controller.advices.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      controller.isShowMoreAdvice =
                          !controller.isShowMoreAdvice;
                    });
                  },
                  child: Row(
                    children: [
                      FxText.bodyMedium(
                        controller.isShowMoreAdvice ? "Show less" : "Show more",
                        color: customTheme.colorPrimary,
                        fontWeight: 600,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        controller.isShowMoreAdvice
                            ? Icons.keyboard_double_arrow_up
                            : Icons.keyboard_double_arrow_down,
                        color: customTheme.colorPrimary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBlogList() {
    // If no internet connection
    if (controller.noInternetConnection || !controller.isDataFetched) {
      Widget child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 16.0),
          for (int index = 0; index < 3; index++) ...[
            buildBannerPlaceholder(),
            const SizedBox(height: 16.0),
          ],
        ],
      );

      return _buildShimmerWidget(child);
    }

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
              width: 80,
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
                          // Default user if null
                          imageUrl: blog.authorImage ??
                              "https://th.bing.com/th/id/OIP.SrKYitjP5GdtE0a98StaAAAAAA?rs=1&pid=ImgDetMain",
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

  Widget _buildShimmerWidget(Widget child) {
    return Shimmer.fromColors(
      baseColor: customTheme.lightGrey.withOpacity(0.7),
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: child,
      ),
    );
  }
}
