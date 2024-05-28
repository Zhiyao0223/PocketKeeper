import 'package:flutter/material.dart';

typedef OnChangeColor = void Function(Color color);

class FxColorPicker extends StatelessWidget {
  final List<Color> colors;
  final Color? selectedColor;
  final OnChangeColor onChangeColor;
  final int crossAxisCount;

  const FxColorPicker({
    super.key,
    required this.colors,
    this.selectedColor,
    required this.onChangeColor,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: colors.length,
      itemBuilder: (BuildContext context, int index) {
        Color newColor = colors[index];
        bool selected = (colors.contains(selectedColor))
            ? (newColor == selectedColor)
            : (index == 0);
        return InkWell(
          onTap: () {
            onChangeColor(newColor);
          },
          child: Container(
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: newColor,
            ),
            child: selected
                ? const Icon(
                    Icons.check,
                    size: 20,
                    color: Colors.white,
                  )
                : Container(),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
    );
  }
}
