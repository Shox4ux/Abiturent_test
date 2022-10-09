import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/constants.dart';
import '../navigation/main_navigation.dart';

class CustomSimpleAppBar extends StatefulWidget {
  const CustomSimpleAppBar(
      {Key? key, required this.titleText, required this.routeText})
      : super(key: key);

  final String titleText;
  final String routeText;

  @override
  State<CustomSimpleAppBar> createState() => _CustomSimpleAppBarState();
}

class _CustomSimpleAppBarState extends State<CustomSimpleAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      height: 64.h,
      width: 375.w,
      child: Row(children: [
        GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                widget.routeText,
                (route) => false,
              );
            },
            child: const Icon(Icons.arrow_back)),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 64.w),
          child: Text(
            widget.titleText,
            style: AppStyles.introButtonText.copyWith(
              color: AppColors.titleColor,
            ),
          ),
        )
      ]),
    );
  }
}
