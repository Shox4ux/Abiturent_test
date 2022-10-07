import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';

class DtmScreen extends StatelessWidget {
  const DtmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DTM testlar",
              style: AppStyles.introButtonText
                  .copyWith(color: AppColors.titleColor),
            ),
            Gap(5.h),
            Text(
              "Tarix fani",
              style: AppStyles.introButtonText
                  .copyWith(color: AppColors.titleColor),
            ),
          ],
        ),
        Gap(20.h),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              gridItem(),
              gridItem(),
              gridItem(),
              gridItem(),
              gridItem(),
              gridItem(),
              gridItem(),
              gridItem(),
              gridItem(),
              gridItem(),
              gridItem(),
              gridItem(),
              gridItem(),
              gridItem(),
              gridItem(),
              gridItem(),
            ],
          ),
        )
      ],
    );
  }

  Widget gridItem() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(9.h),
          height: 132.h,
          width: 132.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(120.r),
            border: Border.all(
              color: AppColors.mainColor, //<--- color
              width: 5.0,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(16.h),
            height: 113.h,
            width: 113.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(120.r),
            ),
            child: Image.asset(
              AppIcons.star,
              scale: 3.h,
            ),
          ),
        ),
        Positioned(
          top: 80.h,
          right: 25.w,
          child: Container(
            height: 42.h,
            width: 42.w,
            decoration: BoxDecoration(
              color: AppColors.subtitleColor,
              borderRadius: BorderRadius.circular(120.r),
            ),
            child: Center(
              child: Text(
                "10",
                style: AppStyles.subtitleTextStyle.copyWith(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
