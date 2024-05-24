import 'package:flutter/material.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';

Widget buildCircularLoadingIndicator() {
  return Center(
    child: CircularProgressIndicator(
      backgroundColor: CustomTheme().white,
      color: CustomTheme().colorPrimary,
    ),
  );
}
