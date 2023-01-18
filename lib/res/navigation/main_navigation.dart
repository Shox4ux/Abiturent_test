import 'package:flutter/material.dart';
import 'package:test_app/core/domain/news_models/main_news_model.dart';
import 'package:test_app/ui/auth/forgot_password.dart';
import 'package:test_app/ui/auth/login.dart';
import 'package:test_app/ui/auth/sign_up.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/group_screen/inside_group.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/news_screen/inside_news.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/news_screen/news.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/payme_sceens/add_card_screen.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/payme_sceens/make_payment_screen.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/payment_history/payment_history.dart';
import 'package:test_app/ui/intro/intro.dart';
import 'package:test_app/ui/main_screen/main_screen.dart';
import 'package:test_app/ui/splash/blocked_warning.dart';
import 'package:test_app/ui/splash/sms_code_varified.dart';
import 'package:test_app/ui/splash/splash.dart';
import '../../ui/bottom_navigation/profile/profile_sections/group_screen/group.dart';
import '../../ui/bottom_navigation/profile/profile_sections/payme_sceens/card_confirma_screen.dart';
import '../../ui/bottom_navigation/profile/profile_sections/subscriptions/make_subscription_screen.dart';
import '../../ui/bottom_navigation/profile/profile_sections/subscriptions/subscription_preview_screen.dart';
import '../../ui/bottom_navigation/profile/profile_sections/subscriptions/subscriptions_screen.dart';

class MainNavigation {
  final routes = <String, Widget Function(BuildContext)>{
    RouteNames.splash: (context) => const SplashScreen(),
    RouteNames.intro: (context) => const IntroScreen(),
    RouteNames.profile: (context) => const ProfileScreen(),
    RouteNames.signup: (context) => const SignUpScreen(),
    RouteNames.signin: (context) => const LoginScreen(),
    RouteNames.onSmsCodeVarified: (context) => const SmsCodeVarifiedScreen(),
    RouteNames.news: (context) => NewsScreen(),
    RouteNames.userBlockedWarning: (context) => const UserBlockedWarning(),
    RouteNames.subscriptionPreview: (context) =>
        const SubscriptionPreviewSceen(),
    RouteNames.makeSubscription: (context) => const MakeSubscriptionScreen(),
    RouteNames.onPaymentDone: (context) => NewsScreen(),
    RouteNames.addCard: (context) => const AddCardScreen(),
    RouteNames.confirmCard: (context) => const CardConfirmationSceen(),
    RouteNames.makePayment: (context) => const MakePaymentScreen(),
    RouteNames.forgetPassword: (context) => const ForgotPasswordScreen(),
    RouteNames.subscripts: (context) => const MySubscriptions(),
    RouteNames.paymentsHistory: (context) => const PaymentHistoryScreen(),
    RouteNames.group: (context) => const GroupScreen(),
    RouteNames.main: (context) => const MainScreen(2),
    RouteNames.addMembers: (context) => const InsideGroup(),
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
  static const userBlockedWarning = "userBlockedWarning";
  static const subscriptionPreview = "subscriptionPreview";
  static const makeSubscription = "makeSubscriptions";
  static const onPaymentDone = "onPaymentDone";
  static const changePassword = "reset";
  static const addCard = "addCard";
  static const onSmsCodeVarified = "onSmsCodeVarified";

  static const confirmCard = "confirmCard";
  static const makePayment = "makePayment";
  static const forgetPassword = "forgetPassword";
  static const innerNews = "innerNews";
  static const subscripts = "subscripts";
  static const paymentsHistory = "paymentsHistory";
  static const addMembers = "addMembers";
  static const testEnd = "testEnd";
  static const editProfile = "editProfile";
}
