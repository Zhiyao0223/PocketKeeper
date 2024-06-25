import 'package:flutter/material.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';

class CircularProgressWithIcon extends StatefulWidget {
  final IconData icon;
  final double progressValue;

  const CircularProgressWithIcon({
    super.key,
    required this.icon,
    required this.progressValue,
  });

  @override
  CircularProgressWithIconState createState() =>
      CircularProgressWithIconState();
}

class CircularProgressWithIconState extends State<CircularProgressWithIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();

    customTheme = CustomTheme();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CircularProgressIndicator(
                strokeWidth: 4.0,
                backgroundColor: customTheme.white.withOpacity(0.87),
                valueColor: AlwaysStoppedAnimation<Color>(customTheme.lime),
                value: Tween<double>(
                  begin: 0.0,
                  end: widget.progressValue,
                ).animate(_controller).value,
              );
            },
          ),
          Icon(
            widget.icon,
            size: 20.0,
            color: customTheme.white,
          ),
        ],
      ),
    );
  }
}
