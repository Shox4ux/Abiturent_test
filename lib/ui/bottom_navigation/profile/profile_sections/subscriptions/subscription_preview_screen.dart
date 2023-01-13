import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/bloc/subscription_cubit/subscription_cubit.dart';
import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/constants.dart';
import '../../../../../res/functions/number_formatter.dart';
import '../../../../../res/navigation/main_navigation.dart';

class SubscriptionPreviewSceen extends StatelessWidget {
  const SubscriptionPreviewSceen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<SubscriptionCubit, SubscriptionState>(
          listener: (context, state) {
            if (state is OnScriptError) {}
          },
          builder: (context, state) {
            if (state is OnSubscriptionPreview) {
              return onScriptPreview(context, state);
            }
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
        ),
      ),
    );
  }

  Widget onScriptPreview(BuildContext context, OnSubscriptionPreview state) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              CustomSimpleAppBar(
                isIcon: false,
                titleText: "Obuna bo'lish",
                style: AppStyles.introButtonText.copyWith(color: Colors.black),
                iconColor: Colors.black,
                isSimple: true,
                routeText: RouteNames.main,
              ),
              Gap(66.h),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text("${state.preview.subjectData!.name} fani",
                          textAlign: TextAlign.center,
                          style: AppStyles.smsVerBigTextStyle.copyWith(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.mainColor,
                          )),
                    ),
                    Gap(11.h),
                    Text("1 oylik obuna narxi",
                        style: AppStyles.smsVerBigTextStyle.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        )),
                    Gap(5.h),
                    RichText(
                      text: TextSpan(
                        text:
                            '${numberFormatter(state.preview.subjectData!.price)} ',
                        style: AppStyles.introButtonText
                            .copyWith(color: Colors.black, fontSize: 48.sp),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'UZS',
                              style: AppStyles.introButtonText.copyWith(
                                color: Colors.black,
                                fontSize: 32.sp,
                              )),
                        ],
                      ),
                    ),
                    Gap(24.h),
                    Container(
                      width: 310.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            20.r,
                          ),
                        ),
                      ),
                    ),
                    Gap(32.h),
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
                                "${state.preview.startDay} - ${state.preview.endDay}",
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
              ),
            ],
          ),
        ),
        BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            if (state is OnSubscriptionPreview) {
              return Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: ElevatedButton(
                  style: AppStyles.introUpButton,
                  onPressed: () {
                    context
                        .read<SubscriptionCubit>()
                        .makeScript(state.preview.subjectData!.id!);

                    Navigator.pushNamed(context, RouteNames.makeSubscription);

                    /// send to makeScriptScreen
                  },
                  child: Text(
                    "Obuna bo’lish",
                    style: AppStyles.introButtonText
                        .copyWith(color: const Color(0xffFCFCFC)),
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            );
          },
        ),
      ],
    );
  }
}
