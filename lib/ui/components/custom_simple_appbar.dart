import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../res/constants.dart';

class CustomSimpleAppBar extends StatefulWidget {
  const CustomSimpleAppBar({
    Key? key,
    required this.titleText,
    required this.routeText,
    required this.style,
    required this.iconColor,
  }) : super(key: key);

  final String titleText;
  final String routeText;
  final TextStyle style;
  final Color iconColor;

  @override
  State<CustomSimpleAppBar> createState() => _CustomSimpleAppBarState();
}

class _CustomSimpleAppBarState extends State<CustomSimpleAppBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(
                context,
                widget.routeText,
              );
            },
            child: SizedBox(
              height: 24.h,
              width: 24.w,
              child: Image.asset(
                AppIcons.arrowBack,
                color: widget.iconColor,
              ),
            ),
          ),
          Gap(12.w),
          Text(
            widget.titleText,
            style: widget.style,
          )
        ],
      ),
    );
  }
}
