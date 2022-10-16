import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/ui/intro/intro.dart';
import 'package:test_app/ui/navigation/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  void route() {
    Navigator.pushNamed(context, RouteNames.intro, arguments: "+998912222222");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 118.h,
            width: 118.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100.r)),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.splashColor,
                  offset: Offset.zero,
                  blurRadius: 50,
                  spreadRadius: 5,
                  blurStyle: BlurStyle.normal,
                )
              ],
            ),
          ),
          Gap(30.h),
          Text(
            "e-abiturent ",
            style: AppStyles.mainTextStyle.copyWith(color: Colors.white),
          ),
          Text(
            "test",
            style: AppStyles.mainTextStyle.copyWith(color: Colors.white),
          )
        ]),
      ),
    );
  }
}
