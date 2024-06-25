import 'package:flutter/material.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/utils/converters/number.dart';

// Progress bar with different sections that represent by different colors
class MultiSectionProgressBar extends StatelessWidget {
  final List<ProgressSection> sections;

  MultiSectionProgressBar({super.key, required this.sections});

  final colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    // Give each section a color from the color list
    for (int i = 0; i < sections.length; i++) {
      sections[i].color = colorList[i % colorList.length];
    }

    return Row(
      children: sections.map((section) {
        String sectionValue = (section.value * 100).toWholeNumber();

        return Expanded(
          flex: (section.value * 1000).toInt(),
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: FxText.bodySmall(
                    '${section.name}: $sectionValue%',
                    color: Colors.white,
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              color: section.color,
              height: 8,
              // color: section.color,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ProgressSection {
  Color? color;
  final String name;
  final double value;

  ProgressSection({
    required this.name,
    required this.value,
  });
}
