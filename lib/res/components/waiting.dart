import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/block/test_block/test_cubit.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/number_formatter.dart';
import '../../core/block/subscription_block/subscription_cubit.dart';
import 'custom_simple_appbar.dart';
import '../navigation/main_navigation.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({
    Key? key,
    required this.status,
    required this.errorText,
    required this.buttonText,
  }) : super(key: key);

  final String status;
  final String errorText;
  final String buttonText;

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.status == WarningValues.subFirstDone) {
      return Scaffold(
        body: SafeArea(
          child: whenPreview(context),
        ),
      );
    }

    if (widget.status == WarningValues.hisobError) {
      return Scaffold(
        body: SafeArea(
          child: whenError(
              context, widget.errorText, widget.buttonText, widget.status),
        ),
      );
    }
    if (widget.status == WarningValues.obunaError) {
      return Scaffold(
        body: SafeArea(
          child: whenError(
              context, widget.errorText, widget.buttonText, widget.status),
        ),
      );
    }

    if (widget.status == WarningValues.subSecondDone) {
      return Scaffold(
        body: SafeArea(
          child: whenScriptEnd(context),
        ),
      );
    }
    if (widget.status == WarningValues.fillBudget) {
      return Scaffold(
        body: SafeArea(
          child: whenWaiting(context),
        ),
      );
    }
    if (widget.status == WarningValues.smsDone) {
      return Scaffold(
        body: SafeArea(
          child: whenReceived(context),
        ),
      );
    }

    return const Scaffold(
      body: Center(
        child: Text("Hozircha bu qism ishlamaydi"),
      ),
    );
  }
}

Widget whenPreview(BuildContext context) {
  return BlocConsumer<SubscriptionCubit, SubscriptionState>(
    listener: (context, state) {
      if (state is OnScriptError) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => WaitingScreen(
                    status: WarningValues.hisobError,
                    errorText: state.error,
                    buttonText: "Hisobni to'ldirish",
                  )),
        );
      }
      if (state is OnScriptMade) {
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => const WaitingScreen(
                    status: WarningValues.subSecondDone,
                    errorText: "",
                    buttonText: "",
                  )),
          (Route<dynamic> route) => false,
        );
      }
    },
    builder: (context, state) {
      if (state is OnSubscriptionPreview) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Gap(20.h),
                    CustomSimpleAppBar(
                      titleText: "Obuna bo'lish",
                      style: AppStyles.introButtonText
                          .copyWith(color: Colors.black),
                      iconColor: Colors.black,
                      isSimple: true,
                    ),
                  ],
                ),
                Gap(66.h),
                Text("${state.preview.subjectData!.name} fani",
                    style: AppStyles.smsVerBigTextStyle.copyWith(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mainColor,
                    )),
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
      if (state is OnScriptError) {
        return Center(
          child: Text(state.error),
        );
      }

      return const Center(
          child: CircularProgressIndicator(
        color: AppColors.mainColor,
      ));
    },
  );
}

Widget whenScriptEnd(BuildContext context) {
  return BlocBuilder<SubscriptionCubit, SubscriptionState>(
    builder: (context, state) {
      if (state is OnScriptProgress) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.mainColor,
          ),
        );
      }
      if (state is OnScriptError) {
        return Center(
          child: Text(state.error),
        );
      }
      if (state is OnScriptMade) {
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
                      "${state.madeScript.subjectText} fani obuna muvaffaqiyatli bo’ldi",
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

      return const Center(
        child: Text("Hozircha bo'sh"),
      );
    },
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
          Text("SMS-kod yuborildi",
              style: AppStyles.smsVerBigTextStyle.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
      ElevatedButton(
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
          Row(
            children: [
              Gap(20.h),
              CustomSimpleAppBar(
                titleText: "Orqaga qaytish",
                style: AppStyles.introButtonText.copyWith(color: Colors.black),
                iconColor: Colors.black,
                isSimple: false,
                routeText: RouteNames.main,
              ),
            ],
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
      ElevatedButton(
        style: AppStyles.introUpButton,
        onPressed: () {
          if (status == WarningValues.hisobError) {
            Navigator.of(context).pushNamed(
              RouteNames.addCard,
            );
            return;
          }

          if (status == WarningValues.hisobError) {
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
    ],
  );
}
