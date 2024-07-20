import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/model/enum/content_type.dart';

Widget buildBannerPlaceholder() {
  return Container(
    width: double.infinity,
    height: 200.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      color: Colors.red,
    ),
  );
}

Widget buildTitlePlaceholder() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        height: 12.0,
        color: Colors.white,
      ),
      const SizedBox(height: 8.0),
      Container(
        width: double.infinity,
        height: 12.0,
        color: Colors.white,
      ),
    ],
  );
}

Widget buildContentPlaceholder(ContentLineType lineType) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 96.0,
          height: 72.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 10.0,
                color: Colors.red,
                margin: const EdgeInsets.only(bottom: 8.0),
              ),
              if (lineType == ContentLineType.threeLines)
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.red,
                  margin: const EdgeInsets.only(bottom: 8.0),
                ),
              Container(
                width: 100.0,
                height: 10.0,
                color: Colors.white,
              )
            ],
          ),
        )
      ],
    ),
  );
}
