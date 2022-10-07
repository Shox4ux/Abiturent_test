import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../res/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    bool isObscure = false;
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
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    hintText: "Maxfiy so’z",
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        child: Icon(isObscure
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
              Gap(33.h),
              Text(
                "Maxfiy so’zni tiklash",
                style: AppStyles.introButtonText
                    .copyWith(color: AppColors.mainColor),
              ),
              Gap(33.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Yangi foydalanuvchimisiz ? ",
                    style: AppStyles.subtitleTextStyle,
                  ),
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
