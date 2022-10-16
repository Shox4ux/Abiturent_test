import 'package:flutter/material.dart';
import 'package:test_app/ui/auth/login.dart';
import 'package:test_app/ui/auth/sign_up.dart';
import 'package:test_app/ui/auth/sms_verification.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/fund/filling_budget.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/news_screen/news.dart';
import 'package:test_app/ui/intro/intro.dart';
import 'package:test_app/ui/splash/splash.dart';

import '../bottom_navigation/profile/profile_sections/group/group.dart';
import '../main_page/MAIN_PAGE.dart';

class MainNavigation {
  final routes = <String, Widget Function(BuildContext)>{
    RouteNames.splash: (context) => const SplashScreen(),
    RouteNames.main: (context) => const MainScreen(),
    RouteNames.intro: (context) => const IntroScreen(),
    RouteNames.signup: (context) => const SignUpScreen(),
    RouteNames.signin: (context) => const LoginScreen(),
    RouteNames.news: (context) => const NewsScreen(),
    RouteNames.payme: (context) => const PaymeScreen(),
    RouteNames.group: (context) => const GroupScreen(),
    RouteNames.profile: (context) => const ProfileScreen(),
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
    return null;
  }
}

abstract class RouteNames {
  static const splash = 'splash';
  static const main = 'main';
  static const profile = 'profile';
  static const intro = 'intro';
  static const signup = 'signup';
  static const signin = 'signin';
  static const smsVerification = 'sms_verification';
  static const news = "news";

  static const group = "group";

  static const payme = "payme";
}
