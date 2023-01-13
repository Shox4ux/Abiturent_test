import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/subscription_model/subscription_model.dart';
import 'package:test_app/res/components/custom_dot.dart';
import '../../../../../core/bloc/subscription_cubit/subscription_cubit.dart';
import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/constants.dart';
import '../../../../../res/navigation/main_navigation.dart';
import '../../../../../res/functions/number_formatter.dart';

class MySubscriptions extends StatefulWidget {
  const MySubscriptions({super.key});

  @override
  State<MySubscriptions> createState() => _MySubscriptionsState();
}

class _MySubscriptionsState extends State<MySubscriptions> {
  List<SubscriptionModel> subList = [];
  @override
  void initState() {
    context.read<SubscriptionCubit>().getScripts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: BlocConsumer<SubscriptionCubit, SubscriptionState>(
          listener: (context, state) {
            if (state is OnReceivedScript) {
              subList = state.scriptList;
            }
          },
          builder: (context, state) {
            if (state is OnScriptProgress) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (state is OnScriptError) {
              return onError(state);
            }
            return onSubscriptionsList();
          },
        ),
      ),
    );
  }

  Widget onScriptMade(OnScriptMade state) {
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

  Widget onSubscriptionsList() {
    return ColoredBox(
      color: AppColors.mainColor,
      child: Column(
        children: [
          CustomSimpleAppBar(
            isIcon: false,
            isSimple: true,
            titleText: "Mening obunalarim",
            iconColor: Colors.white,
            routeText: RouteNames.main,
            style: AppStyles.subtitleTextStyle.copyWith(
              color: Colors.white,
              fontSize: 24.sp,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28.r),
                  topRight: Radius.circular(28.r),
                ),
              ),
              child: subList.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.only(
                                bottom: 20.h,
                                top: 30.h,
                              ),
                              itemCount: subList.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (subList[index].subscriptionData == null) {
                                  return unSubedItem(subList[index]);
                                }
                                return subedItem(subList[index]);
                              }),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text("Hozircha obunalar yo'q"),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget unSubedItem(SubscriptionModel scriptItem) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: CustomDot(
                      hight: 15.h,
                      width: 15.w,
                      color: AppColors.mainColor,
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${scriptItem.subjectName} fani",
                          maxLines: 1,
                          style: AppStyles.subtitleTextStyle.copyWith(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Obuna narxi:",
                              style: AppStyles.subtitleTextStyle
                                  .copyWith(fontSize: 13.sp),
                            ),
                            Gap(10.w),
                            Text(
                              "${numberFormatter(scriptItem.subjectPrice)} UZS",
                              style: AppStyles.introButtonText.copyWith(
                                fontSize: 14.sp,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                context
                    .read<SubscriptionCubit>()
                    .getPreview(scriptItem.subjectId!);

                Navigator.pushNamed(context, RouteNames.subscriptionPreview);
              },
              child: Container(
                height: 39.h,
                width: 39.w,
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.r),
                  ),
                ),
                child: Image.asset(
                  AppIcons.borrow,
                  scale: 3,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget subedItem(SubscriptionModel scriptItem) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
      width: 337.w,
      height: 73.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: CustomDot(
                hight: 15.h,
                width: 15.w,
                color: Colors.green,
              ),
            ),
            Gap(10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${scriptItem.subjectName} fani",
                      maxLines: 1,
                      style: AppStyles.subtitleTextStyle.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Obuna tugashi:",
                        style: AppStyles.subtitleTextStyle
                            .copyWith(fontSize: 13.sp),
                      ),
                      Gap(10.w),
                      Text(
                        "${scriptItem.subscriptionData!.endDay}",
                        style: AppStyles.introButtonText.copyWith(
                          fontSize: 14.sp,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget onError(OnScriptError state) {
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
                state.error,
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
              Navigator.of(context).pushNamed(
                RouteNames.addCard,
              );
            },
            child: Text(
              "Hisobni to'ldirish",
              style: AppStyles.introButtonText
                  .copyWith(color: const Color(0xffFCFCFC)),
            ),
          ),
        ),
      ],
    );
  }
}
