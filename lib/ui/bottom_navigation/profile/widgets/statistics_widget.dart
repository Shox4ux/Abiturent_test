import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/user_model/stat_model.dart';
import 'package:test_app/res/constants.dart';

class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget({super.key, required this.statModel});
  final StatModel statModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                statModel.medalImg!,
                width: 48.w,
                height: 48.h,
              ),
              Gap(10.h),
              Text(
                statModel.medalName!,
                style: AppStyles.subtitleTextStyle.copyWith(fontSize: 12.sp),
              ),
            ],
          ),
          Gap(40.w),
          Expanded(
            child: Column(
              children: [
                Text(
                  "${statModel.subjectText}",
                  style: AppStyles.introButtonText.copyWith(
                    color: Colors.black,
                    fontSize: 18.sp,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Umumiy:",
                          style: AppStyles.introButtonText.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          "${statModel.rating}",
                          style: AppStyles.introButtonText
                              .copyWith(color: Colors.green, fontSize: 18.sp),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "So’ngi haftalik:",
                          style: AppStyles.introButtonText.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          "${statModel.ratingWeek}",
                          style: AppStyles.introButtonText
                              .copyWith(color: Colors.black, fontSize: 18.sp),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
