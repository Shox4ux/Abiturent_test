import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/enum.dart';
import 'package:test_app/ui/components/custom_appbar.dart';
import 'package:test_app/ui/components/custom_dot.dart';
import 'package:test_app/ui/components/custom_drawer.dart';

import '../../../res/constants.dart';

class MistakesScreen extends StatelessWidget {
  const MistakesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: CustomDrawer(mainWidth: screenWidth),
      backgroundColor: AppColors.mainColor,
      key: _scaffKey,
      body: SafeArea(
        child: Column(children: [
          customAppBar(_scaffKey, context),
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
                  Text(
                    "Xatolar bilan ishlash",
                    style: AppStyles.introButtonText.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  Gap(10.h),
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return testItem();
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

  Widget testItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      child: Column(
        children: [
          Row(
            children: [
              CustomDot(
                hight: 14.h,
                width: 14.w,
                color: AppColors.mainColor,
              ),
              Gap(9.w),
              Text(
                "Test: Test11",
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: AppColors.titleColor,
                  fontSize: 14.sp,
                ),
              ),
              Gap(24.w),
              Text(
                "Savol #: 12",
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: AppColors.titleColor,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          Gap(9.w),
          Container(
            padding: EdgeInsets.all(14.h),
            width: 336.w,
            height: 148.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.mainColor,
                width: 1.w,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(13.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " 1918-1939- yillarda Osiyo davlatlarining iqtisodiy va siyosiy rivojlanishi",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.subtitleTextStyle.copyWith(
                    color: AppColors.titleColor,
                    fontSize: 12.sp,
                  ),
                ),
                Gap(14.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < 4; i++)
                      Row(
                        children: [
                          CustomDot(
                            hight: 11.h,
                            width: 11.w,
                            color: TestVertions.neutral.testColor,
                          ),
                          Gap(3.w),
                          Expanded(
                            child: Text(
                              "Shaharlarda ichki qal’alar borligi ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.subtitleTextStyle.copyWith(
                                color: TestVertions.neutral.testColor,
                                fontSize: 12.sp,
                              ),
                            ),
                          )
                        ],
                      )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
