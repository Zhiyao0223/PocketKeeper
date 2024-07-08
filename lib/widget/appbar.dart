import 'package:flutter/material.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';

AppBar buildCommonAppBar({
  required String headerTitle,
  required BuildContext context,
  bool disableBackButton = false,
  IconData? trailingIcon,
  Function()? onTrailingIconPressed,
}) {
  CustomTheme customTheme = CustomTheme();

  return AppBar(
    toolbarHeight: kToolbarHeight + 1, // Make bottom border invisible
    title: FxText.labelLarge(
      headerTitle,
      color: customTheme.white,
    ),
    centerTitle: true,
    backgroundColor: customTheme.lightPurple,
    leading: disableBackButton
        ? null
        : IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: customTheme.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
    actions: [
      trailingIcon == null
          ? const SizedBox()
          : IconButton(
              icon: Icon(
                trailingIcon,
                color: customTheme.white,
              ),
              onPressed: onTrailingIconPressed,
            ),
    ],
  );
}
