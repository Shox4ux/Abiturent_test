import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/ui/components/custom_simple_appbar.dart';
import 'package:test_app/ui/navigation/main_navigation.dart';

import '../../../../../res/constants.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.mainColor,
        body: Column(children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, bottom: 17.h),
            child: CustomSimpleAppBar(
              titleText: "Yangiliklar",
              routeText: RouteNames.profile,
              style: AppStyles.subtitleTextStyle.copyWith(
                fontSize: 24.sp,
                color: Colors.white,
              ),
              iconColor: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28.r),
                  topRight: Radius.circular(28.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {}, child: newsItem());
                        }),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

Widget newsItem() {
  return Container(
    height: 80.h,
    margin: EdgeInsets.only(bottom: 10.h),
    child: Row(
      children: [
        Image.asset(
          AppIcons.news,
          fit: BoxFit.cover,
        ),
        Gap(11.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "11.09.2022 14:11",
                style: AppStyles.subtitleTextStyle.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.mainColor,
                ),
              ),
              Gap(4.h),
              Text(
                "Odamlar yana Oyga qaytmoqda. NASA so‘nggi 50 yildagi eng umidli  loyihani ishga tushirdi",
                style: AppStyles.subtitleTextStyle.copyWith(
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
