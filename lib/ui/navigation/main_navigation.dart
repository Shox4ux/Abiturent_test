import 'package:flutter/material.dart';
import 'package:test_app/ui/auth/login.dart';
import 'package:test_app/ui/auth/sign_up.dart';
import 'package:test_app/ui/auth/sms_verification.dart';
import 'package:test_app/ui/intro/intro.dart';
import 'package:test_app/ui/splash/splash.dart';

import '../main_page/MAIN_PAGE.dart';

class MainNavigation {
  final routes = {
    RouteNames.splash: (context) => const SplashScreen(),
    RouteNames.main: (context) => const MainScreen(),
    RouteNames.intro: (context) => const IntroScreen(),
    RouteNames.signup: (context) => const SignUpScreen(),
    RouteNames.signin: (context) => const LoginScreen(),
  };

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.smsVerification:
        {
          final number = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => SmsVerification(number: number),
          );
        }
      default:
    }
  }
}

abstract class RouteNames {
  static const splash = 'splash';
  static const main = 'main';
  static const intro = 'intro';
  static const signup = 'signup';
  static const signin = 'signin';
  static const smsVerification = 'sms_verification';
}
