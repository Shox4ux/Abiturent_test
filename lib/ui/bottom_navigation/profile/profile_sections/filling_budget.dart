import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../res/constants.dart';

class FillingBudgetScreen extends StatelessWidget {
  const FillingBudgetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(40.h),
          Padding(
            padding: EdgeInsets.all(20.h),
            child: Row(
              children: [
                SizedBox(
                  height: 24.h,
                  width: 24.w,
                  child: Image.asset(AppIcons.arrowBack),
                ),
                Gap(64.w),
                Text(
                  "Hisobni to’ldirish",
                  style: AppStyles.introButtonText.copyWith(
                    color: AppColors.fillingColor,
                  ),
                )
              ],
            ),
          ),
          Gap(64.w),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To’lov summasi",
                  style: AppStyles.introButtonText.copyWith(
                    color: AppColors.fillingColor.withOpacity(0.6),
                  ),
                ),
                Gap(11.h),
                Text(
                  "100 000 UZS",
                  style: AppStyles.introButtonText.copyWith(
                    color: AppColors.fillingColor,
                    fontSize: 36.sp,
                  ),
                ),
              ],
            ),
          ),
          Gap(22.h),
          Expanded(
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25.r),
                  topLeft: Radius.circular(25.r),
                ),
              ),
              child: fillInfo(),
            ),
          ),
        ],
      ),
    );
  }
}

Widget fillInfo() {
  return Padding(
    padding: EdgeInsets.only(
      top: 12.h,
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Telefon raqami",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.h),
                borderSide: BorderSide(color: Colors.red, width: 2.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.h),
                borderSide: BorderSide(
                    color: AppColors.textFieldBorderColor, width: 2.w),
              ),
            ),
          ),
        ),
        Gap(24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Telefon raqami",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.h),
                borderSide: BorderSide(color: Colors.red, width: 2.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.h),
                borderSide: BorderSide(
                    color: AppColors.textFieldBorderColor, width: 2.w),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget certificateInfo() {
  return Column(
    children: [],
  );
}
