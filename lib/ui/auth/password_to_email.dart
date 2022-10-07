import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';

class PassToEmail extends StatelessWidget {
  const PassToEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Gap(76.h),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 32.w),
              width: 312.w,
              height: 312.h,
              child: Image.asset("assets/envy.png")),
          Gap(18.h),
          Text("SMS-kod yuborildi",
              style: AppStyles.smsVerBigTextStyle.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              )),
          Gap(271.h),
          ElevatedButton(
              style: AppStyles.introUpButton,
              onPressed: () {},
              child: Text(
                "Kirish qismiga o’tish",
                style: AppStyles.introButtonText
                    .copyWith(color: const Color(0xffFCFCFC)),
              )),
        ],
      ),
    );
  }
}
