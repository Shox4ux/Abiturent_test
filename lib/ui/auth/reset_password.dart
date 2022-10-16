import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/ui/components/custom_simple_appbar.dart';

import '../../res/constants.dart';

class ResetPassWord extends StatefulWidget {
  const ResetPassWord({Key? key}) : super(key: key);

  @override
  State<ResetPassWord> createState() => _ResetPassWordState();
}

class _ResetPassWordState extends State<ResetPassWord> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomSimpleAppBar(
                titleText: "Abiturentni tasniqlash",
                routeText: "routeText",
                style: AppStyles.introButtonText.copyWith(
                  color: AppColors.titleColor,
                ),
                iconColor: AppColors.smsVerColor,
              ),
              Gap(56.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Yangi maxfiy so’zni kiritish",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.h),
                      borderSide: BorderSide(color: Colors.red, width: 2.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.h),
                      borderSide: BorderSide(
                          color: AppColors.textFieldBorderColor, width: 2.w),
                    ),
                  ),
                ),
              ),
              Gap(24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Qayta maxfiy so’zni kiritish",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.h),
                      borderSide: BorderSide(color: Colors.red, width: 2.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.h),
                      borderSide: BorderSide(
                          color: AppColors.textFieldBorderColor, width: 2.w),
                    ),
                  ),
                ),
              ),
              Gap(27.h),
              ElevatedButton(
                style: AppStyles.introUpButton,
                onPressed: () {},
                child: Text(
                  "Saqlash",
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

  void launch() {}
}
