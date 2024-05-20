import 'package:flutter/material.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';

class Header extends StatefulWidget {
  final String title;

  const Header({super.key, required this.title});

  @override
  State<Header> createState() {
    return _HeaderState();
  }
}

class _HeaderState extends State<Header> {
  late CustomTheme customTheme;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
    );
  }
}
