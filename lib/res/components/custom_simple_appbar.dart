import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../constants.dart';

class CustomSimpleAppBar extends StatefulWidget {
  CustomSimpleAppBar({
    Key? key,
    required this.titleText,
    this.routeText,
    required this.style,
    required this.iconColor,
    required this.isSimple,
  }) : super(key: key);

  final String titleText;
  String? routeText;
  final TextStyle style;
  final Color iconColor;
  final bool isSimple;

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
          IconButton(
            onPressed: () {
              widget.isSimple
                  ? Navigator.pop(context)
                  : Navigator.pushNamed(
                      context,
                      widget.routeText!,
                    );
            },
            icon: Image.asset(
              AppIcons.arrowBack,
              color: widget.iconColor,
              height: 24.h,
              width: 24.w,
            ),
          ),
          // GestureDetector(
          //   onTap: () {

          //   },
          //   child: SizedBox(

          //     child: Image.asset(
          //       AppIcons.arrowBack,
          //       color: widget.iconColor,
          //     ),
          //   ),
          // ),
          Gap(10.w),
          Text(
            widget.titleText,
            style: widget.style,
          )
        ],
      ),
    );
  }
}
