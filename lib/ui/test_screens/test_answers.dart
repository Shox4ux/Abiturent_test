import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../core/block/test_block/test_cubit.dart';
import '../../res/constants.dart';
import '../../res/models/test_model.dart';
import '../../res/components/custom_dot.dart';
import '../../res/components/custom_simple_appbar.dart';
import '../../res/navigation/main_navigation.dart';

class TestAnswerScreen extends StatefulWidget {
  const TestAnswerScreen({
    Key? key,
    required this.subName,
    required this.testNumber,
    required this.complitionTime,
  }) : super(key: key);

  final String subName;
  final String testNumber;

  final String complitionTime;

  @override
  State<TestAnswerScreen> createState() => TestAnswerScreenState();
}

class TestAnswerScreenState extends State<TestAnswerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, bottom: 17.h),
            child: CustomSimpleAppBar(
              isSimple: true,
              titleText:
                  "${widget.subName} fani: To’plam #${widget.testNumber}",
              routeText: RouteNames.profile,
              style: AppStyles.subtitleTextStyle.copyWith(
                fontSize: 24.sp,
                color: Colors.white,
              ),
              iconColor: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28.r),
                  topRight: Radius.circular(28.r),
                ),
              ),
              child: BlocBuilder<TestCubit, TestState>(
                builder: (context, state) {
                  if (state is OnTestCompleted) {
                    return Column(
                      children: [
                        Gap(28.h),
                        Text(
                          "Tugatilgan sana: ${widget.complitionTime}",
                          style: AppStyles.subtitleTextStyle.copyWith(
                            fontSize: 13.sp,
                          ),
                        ),
                        Gap(13.w),
                        Expanded(
                          child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: SubjectList.tests.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ordinary(SubjectList.tests[index],
                                    (index + 1).toString());
                              }),
                        ),
                      ],
                    );
                  }
                  return const Center(child: Text("Kuting...."));
                },
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget ordinary(TestModel model, String index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 34.h,
          width: 170.w,
          padding: EdgeInsets.only(left: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.r),
            border: Border.all(
              width: 1,
              color: AppColors.textFieldBorderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomDot(
                hight: 14.h,
                width: 14.w,
                color: AppColors.mainColor,
              ),
              Gap(7.w),
              Text(
                "$index )Savol",
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.h, bottom: 12.h, left: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.question,
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: Colors.black,
                  fontSize: 12.sp,
                ),
              ),
              Gap(18.h),
              Container(
                margin: EdgeInsets.only(left: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int t = 0; t < model.options.length; t++)
                      Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        child: Text(
                          model.options[t].optionText,
                          style: AppStyles.subtitleTextStyle.copyWith(
                              fontSize: 12.sp,
                              color: model.options[t].status.testColor),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
