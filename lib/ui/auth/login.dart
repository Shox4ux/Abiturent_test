import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/ui/navigation/main_navigation.dart';

import '../../res/constants.dart';
import '../components/custom_simple_appbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    bool isObscure = true;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(40.h),
              const CustomSimpleAppBar(
                titleText: "Tizimga kirish",
                routeText: RouteNames.intro,
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
                      child: Icon(
                        isObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
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
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteNames.smsVerification, (route) => false,
                      arguments: "+998912222222");
                },
                child: Text(
                  "Kirish",
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void launch() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.signup,
      (route) => false,
    );
  }
}
