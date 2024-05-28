// Copyright 2021 The FlutX Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables

/// [FxMeasureSize] - measures the size of any particular widget
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

typedef OnWidgetSizeChange = void Function(Size? size);

class FxMeasureSize extends StatefulWidget {
  final Widget child;
  final OnWidgetSizeChange onChange;

  const FxMeasureSize({
    super.key,
    required this.onChange,
    required this.child,
  });

  @override
  _FxMeasureSizeState createState() => _FxMeasureSizeState();
}

class _FxMeasureSizeState extends State<FxMeasureSize> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  var widgetKey = GlobalKey();
  var oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize);
  }
}
