import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../res/constants.dart';

class SmsVerification extends StatelessWidget {
  const SmsVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(40.h),
              Container(
                height: 64.h,
                width: 375.w,
                child: Row(children: [
                  const Icon(Icons.arrow_back),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 44.w),
                    child: Text(
                      "Abiturentni tasniqlash",
                      style: AppStyles.introButtonText.copyWith(
                        color: AppColors.titleColor,
                      ),
                    ),
                  )
                ]),
              ),
              Gap(27.h),
              Text(
                "Tasdiqlash uchun SMS kodni kiriting",
                style: AppStyles.smsVerBigTextStyle,
              ),
              Gap(12.h),
              setPinput(),
              Text(
                "04:59",
                style: AppStyles.introButtonText.copyWith(
                  color: AppColors.mainColor,
                ),
              ),
              Gap(10.h),
              Text(
                AppStrings.smsText,
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: Colors.black,
                ),
              ),
              Gap(6.h),
              RichText(
                text: TextSpan(
                  style: AppStyles.subtitleTextStyle,
                  children: [
                    TextSpan(
                        text: "Ro’yhatdan o’tish",
                        style: AppStyles.subtitleTextStyle.copyWith(
                            color: AppColors.mainColor,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              launch), // launch function for navigating to other screen
                  ],
                ),
              ),
              Gap(55.h),
              ElevatedButton(
                style: AppStyles.introUpButton,
                onPressed: () {},
                child: Text(
                  "Tasdiqlash",
                  style: AppStyles.introButtonText
                      .copyWith(color: const Color(0xffFCFCFC)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget setPinput() {
    return Container(
      padding: EdgeInsets.all(10.h),
      width: double.maxFinite,
      child: Pinput(
        length: 6,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        defaultPinTheme: PinTheme(
          height: 45.h,
          width: 45.w,
          textStyle: GoogleFonts.urbanist(
            fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: Colors.black.withOpacity(0.5),
              width: 2.w,
            ),
          ),
        ),
        focusedPinTheme: PinTheme(
          height: 50.h,
          width: 50.w,
          textStyle: GoogleFonts.urbanist(
            fontSize: 24.sp,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 3.w,
            ),
          ),
        ),
      ),
    );
  }

  void launch() {}
}
