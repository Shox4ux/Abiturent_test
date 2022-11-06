import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';

import '../../core/block/auth_block/auth_cubit.dart';
import '../navigation/main_navigation.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          // if (state is OnReceivingResult) {
          //   return whenReceived(context);
          // }
          // if (state is OnReceivingErrorResult) {
          //   return whenError(context);
          // }
          return whenReceived(context);
        },
      )),
    );
  }
}

Widget whenReceived(BuildContext context) {
  return Column(
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
      Text("SMS-kod yuborildi",
          style: AppStyles.smsVerBigTextStyle.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          )),
      Gap(271.h),
      ElevatedButton(
          style: AppStyles.introUpButton,
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              RouteNames.main,
              (Route<dynamic> route) => false,
            );
          },
          child: Text(
            "Kirish qismiga o’tish",
            style: AppStyles.introButtonText
                .copyWith(color: const Color(0xffFCFCFC)),
          )),
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

Widget whenError(BuildContext context) {
  return Column(
    children: [
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
      Text("Tizimga xatoli yuz berdi!",
          style: AppStyles.smsVerBigTextStyle.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          )),
      Gap(30.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Text(
          "Voluptatibus harum, aspernatur illum! Ipsum occaecat, sequi rerum vulputate purus. Erat aptent, accusamus consequat fugiat, ante quae, alias. Commodo vestibulum.",
          textAlign: TextAlign.center,
          style: AppStyles.smsVerBigTextStyle.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Gap(255.h),
      ElevatedButton(
          style: AppStyles.introUpButton,
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              RouteNames.signin,
              (Route<dynamic> route) => false,
            );
          },
          child: Text(
            "Bosh sahifaga o’tish",
            style: AppStyles.introButtonText
                .copyWith(color: const Color(0xffFCFCFC)),
          )),
    ],
  );
}
