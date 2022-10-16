import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/subscriptions/my_subscriptions.dart';

import '../../../res/enum.dart';
import '../../navigation/main_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isInSubs = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          setState(() {
            print("object");
            isInSubs = false;
          });
          return false;
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 42.w,
                        foregroundImage: AssetImage(
                          AppIcons.man,
                        ),
                      ),
                      Gap(5.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ID #456",
                            style: AppStyles.subtitleTextStyle.copyWith(
                              fontSize: 14.sp,
                              color: const Color(0xff0D0E0F),
                            ),
                          ),
                          Gap(4.h),
                          Text(
                            "Sardor ",
                            style: AppStyles.introButtonText.copyWith(
                                fontSize: 24.sp,
                                color: const Color(0xff161719)),
                          ),
                          Text(
                            "Abdullayev",
                            style: AppStyles.introButtonText.copyWith(
                                fontSize: 24.sp,
                                color: const Color(0xff161719)),
                          ),
                        ],
                      ),
                      Gap(48.w),
                      Column(
                        children: [
                          Text(
                            "Bronze",
                            style: AppStyles.subtitleTextStyle,
                          ),
                          Gap(11.h),
                          SizedBox(
                            width: 48.w,
                            height: 48.h,
                            child: Image.asset(AppIcons.medl),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Gap(19.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                  height: 52.h,
                  decoration: BoxDecoration(
                      color: AppColors.greenBackground,
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40.h,
                        width: 52.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Image.asset(
                          AppIcons.greenPocket,
                          scale: 3.h,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "UZS",
                          style: AppStyles.introButtonText
                              .copyWith(color: Colors.white, fontSize: 14.sp),
                          children: [
                            TextSpan(
                              text: "2 200 000",
                              style: AppStyles.introButtonText.copyWith(
                                  color: Colors.white, fontSize: 28.sp),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Gap(25.h),
                body()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget body() {
    return isInSubs ? subs() : menu();
  }

  Widget subs() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mening hisoblarim",
            style: AppStyles.introButtonText.copyWith(
              color: Colors.black,
            ),
          ),
          Gap(9.h),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 20.h),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return subcriptionsItem();
                }),
          ),
        ],
      ),
    );
  }

  Widget menu() {
    return Container(
      height: 410.h,
      width: 331.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(children: [
        InkWell(
          onTap: () {
            setState(() {
              print("object true");
              isInSubs = true;
            });
          },
          child: rowItem(AppIcons.purplePocket, "Mening hisoblarim", false),
        ),
        spacer(),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.news,
            );
          },
          child: rowItem(AppIcons.gallery, "Yangiliklar", false),
        ),
        spacer(),
        InkWell(
          onTap: () {},
          child: rowItem(AppIcons.purpleDone, "Mening obunalarim", false),
        ),
        spacer(),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.group,
            );
          },
          child: rowItem(AppIcons.purpleDone, "Mening guruhlarim", false),
        ),
        spacer(),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.payme,
            );
          },
          child: rowItem(AppIcons.payme, "Hisobni to’ldirish", false),
        ),
        spacer(),
        InkWell(
          onTap: () {},
          child: rowItem(AppIcons.logout, "Tizimdan chiqish", true),
        ),
      ]),
    );
  }

  Widget rowItem(String imagePath, String text, bool isRed) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 16.w),
      child: Row(
        children: [
          Container(
            height: 52.h,
            width: 52.w,
            decoration: BoxDecoration(
              color: isRed ? const Color(0xffFFE2E4) : AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Image.asset(
              imagePath,
              scale: 3.h,
            ),
          ),
          Gap(9.w),
          Text(
            text,
            style: AppStyles.subtitleTextStyle.copyWith(
              color: const Color(0xff292B2D),
            ),
          )
        ],
      ),
    );
  }

  Widget spacer() {
    return Container(
      color: AppColors.backgroundColor,
      height: 2.h,
      width: double.maxFinite,
    );
  }
}

Widget subcriptionsItem() {
  return Container(
    margin: EdgeInsets.only(bottom: 6.h),
    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 11.w),
    height: 55.h,
    width: 331.w,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Row(
      children: [
        SizedBox(
          height: 24.h,
          width: 24.w,
          child: Image.asset(Subscriptions.green.iconPath),
        ),
        Gap(11.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "11.01.2022",
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 10.sp,
                          color: const Color(0xff161719)),
                    ),
                    // Gap(80.w),
                    Text(
                      "+2 200 000 UZS",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 14.sp,
                        color: const Color(0xff161719),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(4.h),
              Text(
                Subscriptions.green.text,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14.sp,
                  color: const Color(0xff161719),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
