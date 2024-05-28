import 'package:flutter/material.dart';

/*
This class is used to prevent an event from being trigger multiple time
*/
class SafeOnTap extends StatefulWidget {
  const SafeOnTap({
    super.key,
    required this.child,
    required this.onSafeTap,
    this.intervalMs = 500,
  });

  final Widget child;
  final GestureTapCallback onSafeTap;
  final int intervalMs;

  @override
  State<SafeOnTap> createState() {
    return _SafeOnTapState();
  }
}

class _SafeOnTapState extends State<SafeOnTap> {
  int lastTimeClicked = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Detect the interval if reach
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - lastTimeClicked < widget.intervalMs) {
          return;
        }

        lastTimeClicked = now;
        widget.onSafeTap();
      },
      child: widget.child,
    );
  }
}
