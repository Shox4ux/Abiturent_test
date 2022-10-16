import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/ui/components/custom_simple_appbar.dart';

class InsideNewsScreen extends StatelessWidget {
  const InsideNewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Stack(
          children: [
            SizedBox(
              height: 212.h,
              width: double.maxFinite,
              child: Image.asset(
                AppIcons.bigNews,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 120,
              child: CustomSimpleAppBar(
                titleText: "Yangiliklar",
                routeText: "routeText",
                style: AppStyles.introButtonText.copyWith(
                  color: AppColors.fillingColor,
                ),
                iconColor: Colors.white,
              ),
            ),
            Positioned(
              top: 180,
              child: Container(
                padding: EdgeInsets.only(
                  left: 11.w,
                  right: 11.w,
                  top: 17.h,
                  bottom: 7.h,
                ),
                height: 93.h,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25.r),
                    topLeft: Radius.circular(25.r),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 49.h,
                          width: 49.w,
                          decoration: BoxDecoration(
                            color: const Color(0xffEEE5FF),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Image.asset(
                            AppIcons.bell,
                            height: 20,
                            width: 20,
                            scale: 3,
                          ),
                        ),
                        Gap(9.w),
                        Expanded(
                          child: Text(
                            "Odamlar yana Oyga qaytmoqda. NASA so‘nggi 50 yildagi eng umidli  loyihani ishga tushirdi",
                            style: AppStyles.subtitleTextStyle.copyWith(
                              color: AppColors.mainColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "11.09.2022 14:11",
                          style: AppStyles.subtitleTextStyle.copyWith(
                            color: AppColors.smsVerColor,
                            fontSize: 10.sp,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: 280,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 13.h,
                    horizontal: 23.w,
                  ),
                  height: 388.h,
                  width: 330.w,
                  child: Expanded(
                    child: Text(
                      AppStrings.newsString,
                      textAlign: TextAlign.justify,
                      style: AppStyles.introButtonText.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
