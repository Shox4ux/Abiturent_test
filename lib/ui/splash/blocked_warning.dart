import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../res/constants.dart';
import '../../res/navigation/main_navigation.dart';

class UserBlockedWarning extends StatelessWidget {
  const UserBlockedWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 76.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 32.w),
                    width: 180.w,
                    height: 180.h,
                    child: Image.asset(
                      AppIcons.errorImg,
                    ),
                  ),
                  Gap(18.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      "Operator bilan bog'laning",
                      textAlign: TextAlign.center,
                      style: AppStyles.smsVerBigTextStyle.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: ElevatedButton(
                style: AppStyles.introUpButton,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteNames.intro,
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text(
                  "Orqaga qaytish",
                  style: AppStyles.introButtonText
                      .copyWith(color: const Color(0xffFCFCFC)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
