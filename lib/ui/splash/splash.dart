import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/res/constants.dart';
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

  final _storage = AppStorage();

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  void route() async {
    if (await _storage.isLoggedIn()) {
      Navigator.pushNamed(
        context,
        RouteNames.signin,
      );
    } else {
      Navigator.pushNamed(
        context,
        RouteNames.intro,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 118.h,
              width: 118.w,
              alignment: Alignment.center,
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
              child: Image.asset(
                AppIcons.mobile,
                scale: 3,
              ),
            ),
            Container(
              height: 75.h,
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                AppIcons.bilim,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
