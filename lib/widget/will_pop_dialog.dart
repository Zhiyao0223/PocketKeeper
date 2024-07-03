import 'package:flutter/material.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';

Future<bool> buildWillPopDialog(BuildContext context) async {
  CustomTheme customTheme = CustomTheme();

  return (await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(),
            title: const FxText.bodyMedium(
              "Are you sure you want to exit?",
              xMuted: true,
              textAlign: TextAlign.left,
            ),
            actionsAlignment: MainAxisAlignment.end,
            actions: <Widget>[
              InkWell(
                onTap: () => Navigator.of(context).pop(false),
                child: FxText.labelSmall(
                  "NO",
                  color: customTheme.colorPrimary,
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () => Navigator.of(context).pop(true),
                child: FxText.labelSmall(
                  "YES",
                  color: customTheme.colorPrimary,
                ),
              ),
            ],
          );
        },
      )) ??
      false;
}
