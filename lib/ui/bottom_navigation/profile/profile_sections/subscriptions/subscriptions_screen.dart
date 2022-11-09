import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/components/custom_dot.dart';

import '../../../../../res/constants.dart';
import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/navigation/main_navigation.dart';

class MySubscriptions extends StatefulWidget {
  const MySubscriptions({super.key});

  @override
  State<MySubscriptions> createState() => _MySubscriptionsState();
}

class _MySubscriptionsState extends State<MySubscriptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: CustomSimpleAppBar(
              isSimple: true,
              titleText: "Menin obunalarim",
              iconColor: Colors.white,
              routeText: RouteNames.main,
              style: AppStyles.subtitleTextStyle.copyWith(
                color: Colors.white,
                fontSize: 24.sp,
              ),
            ),
          ),
          Gap(17.h),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.only(
                            bottom: 20.h,
                            top: 30.h,
                          ),
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return subItems();
                          }),
                    ),
                  ],
                )),
          ),
        ]),
      ),
    );
  }
}

Widget subItems() {
  return Container(
    margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
    width: 337.w,
    height: 73.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5.0,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: CustomDot(
              hight: 15.h,
              width: 15.w,
              color: Colors.green,
            ),
          ),
          Gap(10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tarix fani",
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Obuna tugashi:",
                    style:
                        AppStyles.subtitleTextStyle.copyWith(fontSize: 13.sp),
                  ),
                  Gap(20.w),
                  Text(
                    "2.10.2022",
                    style: AppStyles.introButtonText.copyWith(
                      fontSize: 14.sp,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
