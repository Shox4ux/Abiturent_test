import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(40.h),
              Container(
                padding: EdgeInsets.all(16.h),
                height: 64.h,
                width: 375.w,
                child: Row(children: [
                  const Icon(Icons.arrow_back),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 64.w),
                    child: Text(
                      "Ro’yhatdan o’tish",
                      style: AppStyles.introButtonText.copyWith(
                        color: AppColors.titleColor,
                      ),
                    ),
                  )
                ]),
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
                            ? Icons.visibility_off
                            : Icons.visibility)),
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
                onPressed: () {},
                child: Text(
                  AppStrings.introUpButtonText,
                  style: AppStyles.introButtonText
                      .copyWith(color: const Color(0xffFCFCFC)),
                ),
              ),
              Gap(12.h),
              Text(
                "Yoki",
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
                  // Text(,
                  //     style: AppStyles.subtitleTextStyle.copyWith(
                  //         color: AppColors.violetColor,
                  //         textBaseline:
                  //         )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void launch() {}
}
