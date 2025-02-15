// Copyright 2021 The FlutX Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: library_private_types_in_public_api

/// [FxCustomRating] - able to give customisable rating widget with custom features.
library;

import 'package:flutter/material.dart';

import '../../utils/utils.dart';

typedef OnRatingChange = void Function(int rating);

class FxCustomRating extends StatefulWidget {
  final int initialRating;

  final double? starSize, starSpacing;
  final List<Color>? starColors;
  final Color inactiveStarColor;
  final OnRatingChange onRatingChange;
  final IconData activeIcon, inActiveIcon;

  const FxCustomRating(
      {super.key,
      this.starSize = 24,
      this.starSpacing = 8,
      this.starColors,
      this.initialRating = 5,
      required this.onRatingChange,
      this.inactiveStarColor = Colors.grey,
      this.activeIcon = Icons.star,
      this.inActiveIcon = Icons.star_outline});

  @override
  _FxCustomRatingState createState() => _FxCustomRatingState();
}

class _FxCustomRatingState extends State<FxCustomRating> {
  late int rating;
  late List<Color> starColors;

  @override
  void initState() {
    rating = widget.initialRating;

    super.initState();
  }

  buildStar() {
    starColors = widget.starColors ?? FxColorUtils.getColorByRating();
    List<Widget> list = [];
    for (int i = 1; i < 6; i++) {
      list.add(InkWell(
        onTap: () {
          setState(() {
            rating = i;
          });
          widget.onRatingChange(i);
        },
        child: Icon(rating >= i ? widget.activeIcon : widget.inActiveIcon,
            size: widget.starSize,
            color: rating >= i
                ? starColors[rating - 1]
                : widget.inactiveStarColor),
      ));
      if (i != 5) {
        list.add(
          SizedBox(
            width: widget.starSpacing,
          ),
        );
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buildStar(),
    );
  }
}
