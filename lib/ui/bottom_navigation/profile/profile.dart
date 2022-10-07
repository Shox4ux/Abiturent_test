import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(22.w),
        child: Column(
          children: [
            Gap(40.h),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 84.w,
                    height: 84.h,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            AppIcons.person,
                          )),
                      borderRadius: BorderRadius.circular(106.r),
                    ),
                  ),
                  Gap(16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID #456",
                        style: AppStyles.subtitleTextStyle.copyWith(
                            fontSize: 14.sp, color: const Color(0xff0D0E0F)),
                      ),
                      Gap(9.h),
                      Text(
                        "Sardor ",
                        style: AppStyles.introButtonText.copyWith(
                            fontSize: 24.sp, color: const Color(0xff161719)),
                      ),
                      Text(
                        "Abdullayev",
                        style: AppStyles.introButtonText.copyWith(
                            fontSize: 24.sp, color: const Color(0xff161719)),
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
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
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
                          text: "220000",
                          style: AppStyles.introButtonText
                              .copyWith(color: Colors.white, fontSize: 28.sp),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Gap(17.h),
            Container(
              height: 410.h,
              width: 331.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(children: [
                RowItem(AppIcons.purplePocket, "Mening hisoblarim", false),
                spacer(),
                RowItem(AppIcons.gallery, "Mening hisoblarim", false),
                spacer(),
                RowItem(AppIcons.purpleDone, "Mening hisoblarim", false),
                spacer(),
                RowItem(AppIcons.purpleDone, "Mening hisoblarim", false),
                spacer(),
                RowItem(AppIcons.payme, "Mening hisoblarim", false),
                spacer(),
                RowItem(AppIcons.logout, "Mening hisoblarim", true),
              ]),
            )
          ],
        ),
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

Widget RowItem(String imagePath, String text, bool isRed) {
  return Padding(
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
          style: AppStyles.subtitleTextStyle.copyWith(color: Color(0xff292B2D)),
        )
      ],
    ),
  );
}
