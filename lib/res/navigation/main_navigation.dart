import 'package:flutter/material.dart';
import 'package:test_app/core/domain/news_models/main_news_model.dart';
import 'package:test_app/ui/auth/forgot_password.dart';
import 'package:test_app/ui/auth/login.dart';
import 'package:test_app/ui/auth/sign_up.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/group/add_user_to_group.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/news_screen/inside_news.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/news_screen/news.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/payme/payme_screen.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/payment_history/payment_history.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/subscriptions/subscriptions_screen.dart';
import 'package:test_app/ui/intro/intro.dart';
import 'package:test_app/ui/main_screen/main_screen.dart';
import 'package:test_app/ui/splash/splash.dart';

import '../../ui/bottom_navigation/profile/profile_sections/group/group.dart';

class MainNavigation {
  final routes = <String, Widget Function(BuildContext)>{
    RouteNames.splash: (context) => const SplashScreen(),
    RouteNames.intro: (context) => const IntroScreen(),
    RouteNames.profile: (context) => const ProfileScreen(),
    RouteNames.signup: (context) => const SignUpScreen(),
    RouteNames.signin: (context) => const LoginScreen(),
    RouteNames.news: (context) => NewsScreen(),
    RouteNames.payme: (context) => const PaymeScreen(),
    RouteNames.forget: (context) => const ForgotPasswordScreen(),
    RouteNames.subscripts: (context) => const MySubscriptions(),
    RouteNames.budget: (context) => const PaymentHistoryScreen(),
    RouteNames.group: (context) => const GroupScreen(),
    RouteNames.main: (context) => const MainScreen(2),
    RouteNames.addMembers: (context) => const AddUserToGroup(),
  };

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
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
  static const paymeInfoConfirm = "paymeInfoConfirm";
  static const paymeSmsCinfirm = "paymeSmsCinfirm";
  static const forget = "forget";
  static const innerNews = "innerNews";
  static const subscripts = "subscripts";
  static const budget = "budget";
  static const addMembers = "addMembers";
  static const testEnd = "testEnd";
  static const edit = "edit";
}
