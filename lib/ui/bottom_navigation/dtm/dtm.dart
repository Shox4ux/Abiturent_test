import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/ui/components/custom_appbar.dart';
import 'package:test_app/ui/components/custom_drawer.dart';

import '../../navigation/main_navigation.dart';

class DtmScreen extends StatefulWidget {
  const DtmScreen({Key? key}) : super(key: key);

  @override
  State<DtmScreen> createState() => _DtmScreenState();
}

class _DtmScreenState extends State<DtmScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: _scaffKey,
        backgroundColor: AppColors.mainColor,
        drawer: CustomDrawer(
          mainWidth: screenWidth,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customAppBar(_scaffKey, context),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28.r),
                      topRight: Radius.circular(28.r),
                    )),
                child: Column(
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
                          gridItem(context),
                          gridItem(context),
                          gridItem(context),
                          gridItem(context),
                          gridItem(context),
                          gridItem(context),
                          gridItem(context),
                          gridItem(context),
                          gridItem(context),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gridItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteNames.test);
      },
      child: Column(
        children: [
          Stack(
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
                top: 90.h,
                right: 0.w,
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
          ),
          Gap(10.h),
          Text(
            "DTM test to’plam #1",
            style: AppStyles.smsVerBigTextStyle.copyWith(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
