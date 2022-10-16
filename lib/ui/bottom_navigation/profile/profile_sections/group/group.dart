import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/ui/components/custom_simple_appbar.dart';
import 'package:test_app/ui/navigation/main_navigation.dart';

import '../../../../../res/constants.dart';
import '../../../../components/custom_appbar.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: CustomSimpleAppBar(
              titleText: "Guruhlarim",
              iconColor: Colors.white,
              routeText: RouteNames.profile,
              style: AppStyles.subtitleTextStyle.copyWith(
                color: Colors.white,
                fontSize: 24.sp,
              ),
            ),
          ),
          Gap(17.h),
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
              child: Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return groupItem();
                    }),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

Widget groupItem() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Gap(6.h),
      Text(
        "Tarix fani",
        style: AppStyles.introButtonText.copyWith(
          color: AppColors.smsVerColor,
        ),
      ),
      Gap(13.h),
      Column(
        children: [
          for (var i = 0; i < 3; i++) groupMemberItem(),
        ],
      )
    ],
  );
}

Widget groupMemberItem() {
  return Padding(
    padding: EdgeInsets.only(bottom: 14.h),
    child: Row(
      children: [
        Container(
          height: 60.h,
          width: 60.w,
          decoration: BoxDecoration(
            color: AppColors.textFieldBorderColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Image.asset(
            AppIcons.members,
            height: 20,
            width: 20,
            scale: 3,
          ),
        ),
        Gap(9.w),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "101 guruhlar",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      color: AppColors.smsVerColor,
                    ),
                  )
                ],
              ),
              Gap(13.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Yaratilgan sana:",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),
                  Text(
                    "13 ishtirokchi",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}
