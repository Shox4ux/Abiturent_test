import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/number_formatter.dart';
import '../../core/bloc/auth_cubit/auth_cubit.dart';
import '../../core/bloc/subscription_cubit/subscription_cubit.dart';
import 'custom_simple_appbar.dart';
import '../navigation/main_navigation.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({
    Key? key,
    required this.status,
    required this.extraText,
    required this.alertText,
    required this.buttonText,
  }) : super(key: key);

  final String status;
  final String alertText;
  final String extraText;

  final String buttonText;

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: checkStatus(context, widget.status, widget.alertText,
            widget.buttonText, widget.extraText),
      ),
    );
  }
}

Widget checkStatus(BuildContext context, String status, String alertText,
    String buttonText, String extraText) {
  // if (status == WarningValues.subFirstDone) {
  //   return whenPreview(context);
  // }

  // if (status == WarningValues.paymentDone) {
  //   return whenPaymentDone(context, alertText, buttonText, extraText);
  // }

  // if (status == WarningValues.hisobError) {
  //   return whenError(context, alertText, buttonText, status);
  // }
  // if (status == WarningValues.obunaError) {
  //   return whenError(context, alertText, buttonText, status);
  // }

  // if (status == WarningValues.subSecondDone) {
  //   return whenScriptEnd(context);
  // }
  // if (status == WarningValues.fillBudget) {
  //   return whenWaiting(context);
  // }
  // if (status == WarningValues.smsDone) {
  //   return whenReceived(context);
  // }
  // if (status == WarningValues.authError) {
  //   return whenError(context, extraText, buttonText, status);
  // }

  // return whenPaymentDone(context, alertText, buttonText, extraText);

  return whenError(context, "", buttonText, status);
}

Widget whenPaymentDone(
  BuildContext context,
  String alertText,
  String buttonText,
  String extraText,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gap(66.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32.w),
            width: 312.w,
            height: 312.h,
            child: Image.asset(
              AppIcons.bi,
              color: AppColors.greenBackground,
              scale: 3,
            ),
          ),
          Text(
            alertText,
            style: AppStyles.introButtonText.copyWith(
              color: Colors.black,
              fontSize: 24.sp,
            ),
          ),
          Gap(10.h),
          RichText(
            text: TextSpan(
              text: numberFormatter(int.parse(extraText)),
              style: AppStyles.introButtonText
                  .copyWith(color: Colors.black, fontSize: 48.sp),
              children: [
                TextSpan(
                  text: " UZS",
                  style: AppStyles.introButtonText
                      .copyWith(color: Colors.black, fontSize: 36.sp),
                ),
              ],
            ),
          )
        ],
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 24.h),
        child: ElevatedButton(
          style: AppStyles.introUpButton,
          onPressed: () async {
            Navigator.of(context).pushNamedAndRemoveUntil(
              RouteNames.main,
              (Route<dynamic> route) => false,
            );
            await context.read<AuthCubit>().getUserData();
          },
          child: Text(
            "Bosh sahifa",
            style: AppStyles.introButtonText
                .copyWith(color: const Color(0xffFCFCFC)),
          ),
        ),
      ),
    ],
  );
}

Widget whenReceived(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        children: [
          Gap(76.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32.w),
            width: 312.w,
            height: 312.h,
            child: Image.asset(
              AppIcons.bi,
              color: AppColors.greenBackground,
              scale: 3,
            ),
          ),
          Gap(18.h),
          Text("SMS-kod tasdiqlandi",
              style: AppStyles.smsVerBigTextStyle.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 24.h),
        child: ElevatedButton(
          style: AppStyles.introUpButton,
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              RouteNames.signin,
              (Route<dynamic> route) => false,
            );
          },
          child: Text(
            "Kirish qismiga o’tish",
            style: AppStyles.introButtonText
                .copyWith(color: const Color(0xffFCFCFC)),
          ),
        ),
      ),
    ],
  );
}

Widget whenWaiting(BuildContext context) {
  return Column(
    children: [
      Gap(76.h),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 32.w),
        width: 312.w,
        height: 312.h,
        child: Image.asset(AppIcons.bigEnvy),
      ),
      Gap(18.h),
      Text("SMS-kod yuborildi",
          style: AppStyles.smsVerBigTextStyle.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          )),
      Padding(
        padding: EdgeInsets.all(30.h),
        child: const LinearProgressIndicator(
          color: AppColors.mainColor,
          backgroundColor: AppColors.fillingColor,
        ),
      ),
    ],
  );
}

Widget whenError(
    BuildContext context, String errorText, String buttonText, String status) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomSimpleAppBar(
            isIcon: false,
            titleText: "Orqaga qaytish",
            style: AppStyles.introButtonText.copyWith(color: Colors.black),
            iconColor: Colors.black,
            isSimple: true,
            routeText: RouteNames.main,
          ),
          Gap(76.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32.w),
            width: 180.w,
            height: 180.h,
            child: Image.asset(
              AppIcons.errorImg,
            ),
          ),
          Gap(18.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              errorText,
              textAlign: TextAlign.center,
              style: AppStyles.smsVerBigTextStyle.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 24.h),
        child: ElevatedButton(
          style: AppStyles.introUpButton,
          onPressed: () {
            if (status == WarningValues.hisobError) {
              Navigator.of(context).pushNamed(
                RouteNames.addCard,
              );
              return;
            }

            if (status == WarningValues.obunaError) {
              context.read<SubscriptionCubit>().getScripts();

              Navigator.of(context).pushNamed(
                RouteNames.subscripts,
              );
              return;
            }

            Navigator.of(context).pushNamedAndRemoveUntil(
              RouteNames.signin,
              (Route<dynamic> route) => false,
            );
          },
          child: Text(
            buttonText,
            style: AppStyles.introButtonText
                .copyWith(color: const Color(0xffFCFCFC)),
          ),
        ),
      ),
    ],
  );
}
