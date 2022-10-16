import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';

import '../components/custom_simple_appbar.dart';
import '../navigation/main_navigation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool _isObscure = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: CustomSimpleAppBar(
                    titleText: "Ro’yhatdan o’tish",
                    routeText: RouteNames.intro,
                    style: AppStyles.introButtonText.copyWith(
                      color: AppColors.smsVerColor,
                    ),
                    iconColor: AppColors.smsVerColor,
                  ),
                ),
                Gap(56.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Abiturent FISH",
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
                      hintText: "Telefon raqami",
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  child: TextField(
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      hintText: "Maxfiy so’z",
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          child: Icon(_isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined)),
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
                Gap(21.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isChecked = !_isChecked;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(microseconds: 200),
                          height: 24.h,
                          width: 24.w,
                          decoration: BoxDecoration(
                              color: _isChecked
                                  ? AppColors.mainColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(
                                color: AppColors.mainColor,
                                width: 2.w,
                              )),
                          child: _isChecked
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16.h,
                                )
                              : null,
                        ),
                      ),
                      Gap(14.w),
                      Expanded(
                        child: Text(
                          AppStrings.checkBoxText,
                          style: AppStyles.subtitleTextStyle.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ),
                Gap(27.h),
                ElevatedButton(
                  style: AppStyles.introUpButton,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RouteNames.smsVerification, (route) => false,
                        arguments: "+998912222222");
                  },
                  child: Text(
                    AppStrings.introUpButtonText,
                    style: AppStyles.introButtonText
                        .copyWith(color: const Color(0xffFCFCFC)),
                  ),
                ),
                Gap(12.h),
                Text(
                  "yoki",
                  style: AppStyles.subtitleTextStyle,
                ),
                Gap(24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Ro’yhatdan o’tganmisiz? ",
                        style: AppStyles.subtitleTextStyle,
                        children: [
                          TextSpan(
                              text: "Kirish",
                              style: AppStyles.subtitleTextStyle.copyWith(
                                  color: AppColors.mainColor,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    launch), // launch function for navigating to other screen
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void launch() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.signin,
      (route) => false,
    );
  }
}
