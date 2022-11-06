import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDot extends StatefulWidget {
  const CustomDot({
    Key? key,
    required this.hight,
    required this.width,
    required this.color,
  }) : super(key: key);
  final double hight;
  final double width;
  final Color color;

  @override
  State<CustomDot> createState() => _CustomDotState();
}

class _CustomDotState extends State<CustomDot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      height: widget.hight,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(120.r),
      ),
    );
  }
}
