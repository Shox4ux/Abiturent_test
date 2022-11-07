import 'package:flutter/material.dart';
import 'package:test_app/core/domain/news_models/main_news_model.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/ui/auth/forgot_password.dart';
import 'package:test_app/ui/auth/login.dart';
import 'package:test_app/ui/auth/reset_password.dart';
import 'package:test_app/ui/auth/sign_up.dart';
import 'package:test_app/ui/auth/sms_verification.dart';
import 'package:test_app/ui/auth/waiting.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/fund/filling_budget.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/news_screen/inside_news.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/news_screen/news.dart';
import 'package:test_app/ui/intro/intro.dart';
import 'package:test_app/ui/splash/splash.dart';
import 'package:test_app/ui/test_screens/test.dart';

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
    RouteNames.payme: (context) => PaymeScreen(),
    RouteNames.profile: (context) => const ProfileScreen(),
    RouteNames.group: (context) => const GroupScreen(),
    RouteNames.changePassword: (context) => const ResetPassWord(),
    RouteNames.wait: (context) => const WaitingScreen(),
    RouteNames.forget: (context) => const ForgotPasswordScreen(),
    RouteNames.test: (context) => const TestScreen()
  };

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.smsVerification:
        {
          final route = settings.arguments as String;

          return MaterialPageRoute(
            builder: (context) => SmsVerificationScreen(
              fromWhere: route,
            ),
          );
        }

      case RouteNames.innerNews:
        {
          final model = settings.arguments as MainNewsModel;
          return MaterialPageRoute(
            builder: (context) => InsideNewsScreen(
              model: model,
            ),
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
  static const changePassword = "reset";
  static const payme = "payme";
  static const wait = "wait";
  static const forget = "forget";
  static const innerNews = "innerNews";
  static const test = "test";
}
