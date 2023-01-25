import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import '../../core/bloc/auth_cubit/auth_cubit.dart';

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
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.main,
        (route) => false,
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.intro,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is OnAuthBlocked) {
              showToast("Siz operator tomonidan bloklangansiz");
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.userBlockedWarning,
                (route) => false,
              );
            }
            if (state is OnLoginDataEmpty) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.signin,
                (route) => false,
              );
            }
          },
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
      ),
    );
  }
}
