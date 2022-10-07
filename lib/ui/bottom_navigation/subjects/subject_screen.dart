import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../res/constants.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tarix fani",
          style: AppStyles.introButtonText.copyWith(
            color: Colors.black,
          ),
        ),
        Gap(10.h),
        Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return subjectItem();
              }),
        ),
      ],
    );
  }

  Widget subjectItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      width: 333.w,
      height: 90.h,
      padding: EdgeInsets.only(
        right: 12.w,
        top: 13.h,
        bottom: 7.h,
        left: 9.w,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              offset: Offset(0, 5),
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(0, 0),
            ),
          ]),
      child: Column(children: [
        Row(
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: 14.h,
              width: 14.w,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(120.r),
              ),
            ),
            Gap(5.w),
            Expanded(
              child: Text(
                " 1918-1939- yillarda Osiyo davlatlarining iqtisodiy va siyosiy rivojlanishi",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: AppColors.titleColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        Gap(16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 11.w),
              width: 94.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(120.r),
              ),
              child: Row(
                children: [
                  Image.asset(
                    AppIcons.info,
                  ),
                  Gap(9.w),
                  Text(
                    "10 ta",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 16.w),
              height: 32.h,
              width: 48.w,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(120.r),
              ),
              child: Image.asset(
                AppIcons.arrow,
              ),
            )
          ],
        )
      ]),
    );
  }
}
