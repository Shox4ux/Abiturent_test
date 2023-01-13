import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/navigation/main_navigation.dart';

class SmsCodeVarifiedScreen extends StatelessWidget {
  const SmsCodeVarifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: whenReceived(context)),
    );
  }

  Widget whenReceived(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Gap(76.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32.w),
              width: 312.w,
              height: 312.h,
              child: Image.asset(
                AppIcons.bi,
                color: AppColors.greenBackground,
                scale: 3,
              ),
            ),
            Gap(18.h),
            Text("SMS-kod tasdiqlandi",
                style: AppStyles.smsVerBigTextStyle.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: ElevatedButton(
            style: AppStyles.introUpButton,
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                RouteNames.signin,
                (Route<dynamic> route) => false,
              );
            },
            child: Text(
              "Kirish qismiga o’tish",
              style: AppStyles.introButtonText
                  .copyWith(color: const Color(0xffFCFCFC)),
            ),
          ),
        ),
      ],
    );
  }
}
