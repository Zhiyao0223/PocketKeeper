// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class FxPageView extends StatefulWidget {
  const FxPageView({super.key});

  @override
  _FxPageViewState createState() => _FxPageViewState();
}

class _FxPageViewState extends State<FxPageView> {
  @override
  Widget build(BuildContext context) {
    return PageView();
  }
}
