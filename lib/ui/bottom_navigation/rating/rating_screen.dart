import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/ui/components/custom_drawer.dart';

import '../../../res/constants.dart';
import '../../components/custom_appbar.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      key: scaffKey,
      drawer: CustomDrawer(mainWidth: screenWidth),
      body: SafeArea(
        child: Column(children: [
          customAppBar(scaffKey, context),
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
                    "Umumiy reyting",
                    style: AppStyles.introButtonText.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  Gap(18.h),
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: 20,
                        itemBuilder: (BuildContext context, int index) {
                          return ratingItem();
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

  Widget ratingItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "1",
            style: AppStyles.subtitleTextStyle.copyWith(
              fontSize: 13.sp,
            ),
          ),
          Gap(8.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "# 123",
                      style: AppStyles.subtitleTextStyle.copyWith(
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      "Qudrator Abdurasul",
                      style: AppStyles.subtitleTextStyle
                          .copyWith(color: AppColors.smsVerColor),
                    ),
                  ],
                ),
                Container(
                  height: 37.h,
                  width: 79.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(13.r),
                    ),
                    color: AppColors.mainColor,
                  ),
                  child: Center(
                    child: Text(
                      "123 ball",
                      style: AppStyles.subtitleTextStyle.copyWith(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
