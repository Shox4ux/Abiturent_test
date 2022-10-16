import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../res/constants.dart';

Widget customAppBar() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
    child: Row(
      children: [
        Container(
          height: 17.h,
          width: 23.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppIcons.menu),
            ),
          ),
        ),
        Gap(100.w),
        Row(
          children: [
            Container(
              height: 17.h,
              width: 23.w,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppIcons.check),
                ),
              ),
            ),
            Gap(8.w),
            Text(
              "1340",
              style: AppStyles.subtitleTextStyle
                  .copyWith(color: const Color(0xffFCFCFC), fontSize: 24.sp),
            )
          ],
        ),
        Gap(16.w),
        Row(
          children: [
            Container(
              height: 19.h,
              width: 19.w,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppIcons.clock),
                ),
              ),
            ),
            Gap(7.w),
            Text(
              "4",
              style: AppStyles.subtitleTextStyle
                  .copyWith(color: const Color(0xffFCFCFC), fontSize: 24.sp),
            ),
            Gap(29.w),
            Container(
              height: 20.h,
              width: 25.w,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppIcons.group),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
