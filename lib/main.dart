import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/ui/auth/login.dart';
import 'package:test_app/ui/auth/password_to_email.dart';
import 'package:test_app/ui/auth/reset_password.dart';
import 'package:test_app/ui/auth/sign_up.dart';
import 'package:test_app/ui/auth/sms_verification.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/filling_budget.dart';
import 'package:test_app/ui/bottom_navigation/subjects/subject_screen.dart';
import 'package:test_app/ui/intro/intro.dart';
import 'package:test_app/ui/main_page/main_page.dart';
import 'package:test_app/ui/splash/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(376, 812),
      builder: (BuildContext context, Widget? child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: IntroScreen(),
      ),
    );
  }
}
