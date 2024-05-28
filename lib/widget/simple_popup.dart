import 'dart:async';
import 'package:flutter/material.dart';
import '../template/widgets/text/text.dart';
import '../theme/custom_theme.dart';

class CustomDialogScreen extends StatefulWidget {
  final String? customMessage;
  final String title;
  final IconData? icons;
  final String? buttontext1;
  final String? buttontext2;
  final VoidCallback? buttonfunction1;
  final VoidCallback? buttonfunction2;
  final VoidCallback? functionafterclose;
  final bool showButtons;
  final Color iconColor;
  final Duration? autoCloseDuration;
  final Color? button2Color;
  final bool additionalBirthDateField;

  const CustomDialogScreen({
    super.key,
    this.customMessage,
    required this.title,
    this.icons,
    this.buttontext1,
    this.buttontext2,
    this.buttonfunction1,
    this.buttonfunction2,
    this.showButtons = true,
    this.iconColor = const Color(0xff6666FF),
    this.autoCloseDuration,
    this.functionafterclose,
    this.additionalBirthDateField = false,
    // this.button1Color,
    this.button2Color,
  });

  @override
  State<CustomDialogScreen> createState() {
    return _CustomDialogScreenState();
  }
}

class _CustomDialogScreenState extends State<CustomDialogScreen> {
  Timer? _timer;
  late CustomTheme customTheme;
  Color? button1Color;
  Color? button2Color;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    if (widget.autoCloseDuration != null) {
      _timer = Timer(widget.autoCloseDuration!, () {
        Navigator.pop(context);
        widget.functionafterclose?.call();
      });
    }

    // Check if button color
    button2Color = widget.button2Color ?? customTheme.purple;
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? iconWidget = widget.icons != null
        ? Icon(
            widget.icons,
            size: 50,
            color: widget.iconColor,
          )
        : null;

    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: customTheme.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: customTheme.black,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 14),
            if (iconWidget != null) iconWidget,
            const SizedBox(height: 10),
            FxText(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
            const SizedBox(height: 10),
            if (widget.customMessage != null)
              FxText(
                widget.customMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 10),
            if (widget.showButtons) _buildButtons(),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  // Function to build the buttons
  Widget _buildButtons() {
    if (widget.buttontext2 == null) {
      return Container(
        alignment: AlignmentDirectional.center,
        child: ElevatedButton(
          onPressed: widget.buttonfunction1,
          style: ElevatedButton.styleFrom(backgroundColor: button2Color),
          child: FxText(
            widget.buttontext1 ?? 'OK',
            style: TextStyle(color: customTheme.white),
          ),
        ),
      );
    } else {
      return Container(
        alignment: AlignmentDirectional.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: customTheme.white),
              onPressed: widget.buttonfunction1,
              child: FxText(
                widget.buttontext1 ?? 'Cancel',
                style: TextStyle(color: customTheme.purple),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: button2Color),
              onPressed: widget.buttonfunction2,
              child: FxText(
                widget.buttontext2 ?? 'OK',
                style: TextStyle(color: customTheme.white),
              ),
            ),
          ],
        ),
      );
    }
  }
}
