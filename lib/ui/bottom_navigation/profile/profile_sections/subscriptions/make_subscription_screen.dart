import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/bloc/auth_cubit/auth_cubit.dart';
import 'package:test_app/core/bloc/subscription_cubit/subscription_cubit.dart';
import '../../../../../res/constants.dart';
import '../../../../../res/navigation/main_navigation.dart';

class MakeSubscriptionScreen extends StatelessWidget {
  const MakeSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          if (state is OnScriptMade) {
            return onMakeSubscription(context, state);
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      )),
    );
  }

  Widget onMakeSubscription(BuildContext context, OnScriptMade state) {
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
            Gap(18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                  "${state.madeScript.subjectText} faniga obuna bo'lish muvaffaqiyatli amalga oshirildi",
                  overflow: TextOverflow.visible,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: AppStyles.smsVerBigTextStyle.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            Gap(18.h),
            Container(
              height: 66.h,
              width: 314.w,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(
                  Radius.circular(24.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppIcons.warning,
                    height: 24.h,
                    width: 24.w,
                    scale: 3,
                  ),
                  Gap(12.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Amal qilish muddati:",
                        style: AppStyles.introButtonText.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${state.madeScript.startDay} - ${state.madeScript.endDay}",
                        style: AppStyles.introButtonText.copyWith(
                          color: Colors.white,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: ElevatedButton(
            style: AppStyles.introUpButton,
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                RouteNames.main,
                (Route<dynamic> route) => false,
              );
// when script is made money will get minused so user should see expanse
              context.read<AuthCubit>().getUserData();
            },
            child: Text(
              "Profilga o'tish",
              style: AppStyles.introButtonText
                  .copyWith(color: const Color(0xffFCFCFC)),
            ),
          ),
        ),
      ],
    );
  }
}
