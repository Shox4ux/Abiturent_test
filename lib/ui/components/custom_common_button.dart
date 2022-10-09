import 'package:flutter/material.dart';

class CustomCommonButton extends StatefulWidget {
  const CustomCommonButton(
      {Key? key,
      required this.buttonText,
      required this.buttonCallBack,
      required this.buttonStyle,
      required this.buttonTextStyle})
      : super(key: key);

  final ButtonStyle buttonStyle;
  final String buttonText;
  final TextStyle buttonTextStyle;
  final VoidCallback buttonCallBack;
  @override
  State<CustomCommonButton> createState() => _CustomCommonButtonState();
}

class _CustomCommonButtonState extends State<CustomCommonButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: widget.buttonStyle,
      onPressed: widget.buttonCallBack,
      child: Text(widget.buttonText, style: widget.buttonTextStyle),
    );
  }
}
