import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/ui/components/custom_dot.dart';
import 'package:test_app/ui/components/custom_drawer.dart';
import 'package:test_app/ui/navigation/main_navigation.dart';

import '../../../res/constants.dart';
import '../../components/custom_appbar.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final topPadding = MediaQuery.of(context).padding.top; this alternative of safeArea
    final GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      key: _scaffKey,
      drawer: CustomDrawer(mainWidth: screenWidth),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customAppBar(_scaffKey, context),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 14.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      "Tarix fani",
                      style: AppStyles.introButtonText.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Gap(10.h),
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.only(
                          bottom: 20.h,
                          top: 10.h,
                        ),
                        itemCount: 10,
                        itemBuilder: (
                          BuildContext context,
                          int index,
                        ) {
                          return subjectItem(context);
                        }),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget subjectItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
      width: 333.w,
      height: 90.h,
      padding: EdgeInsets.only(
        right: 12.w,
        top: 13.h,
        bottom: 7.h,
        left: 9.w,
      ),
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
      child: Column(children: [
        Row(
          children: [
            CustomDot(
              hight: 14.h,
              width: 14.w,
              color: AppColors.mainColor,
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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteNames.test);
              },
              child: Container(
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
              ),
            )
          ],
        )
      ]),
    );
  }
}
