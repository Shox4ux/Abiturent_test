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
import '../../../../../res/components/waiting.dart';
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
    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listener: (context, state) {
        if (state is OnSubscriptionPreview) {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const WaitingScreen(
                status: WarningValues.subFirstDone,
                alertText: "",
                buttonText: "",
                extraText: "",
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.mainColor,
        body: SafeArea(
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
                  child: BlocConsumer<SubscriptionCubit, SubscriptionState>(
                    listener: (context, state) {
                      if (state is OnReceivedScript) {
                        subList = state.scriptList;
                      }
                    },
                    builder: (context, state) {
                      if (state is OnScriptProgress) {
                        return const Center(child: Text("Iltimos kuting..."));
                      }
                      if (state is OnScriptError) {
                        return Center(child: Text(state.error));
                      }

                      return subList.isNotEmpty
                          ? Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                      padding: EdgeInsets.only(
                                        bottom: 20.h,
                                        top: 30.h,
                                      ),
                                      itemCount: subList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (subList[index].subscriptionData ==
                                            null) {
                                          return unSubedItem(
                                              subList[index], context);
                                        }
                                        return subedItem(subList[index]);
                                      }),
                                ),
                              ],
                            )
                          : const Center(child: Text("Hozircha obunalar yo'q"));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget unSubedItem(SubscriptionModel scriptItem, BuildContext context) {
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
                      style:
                          AppStyles.subtitleTextStyle.copyWith(fontSize: 13.sp),
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
