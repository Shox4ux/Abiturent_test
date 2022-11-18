import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/test_model/test_result_model.dart';

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
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamed(
            context,
            RouteNames.subscripts,
          );
          return false;
        },
        child: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, bottom: 17.h),
              child: CustomSimpleAppBar(
                isSimple: false,
                titleText:
                    "${widget.subName} fani: To’plam #${widget.testNumber}",
                routeText: RouteNames.main,
                style: AppStyles.subtitleTextStyle.copyWith(
                  fontSize: 20.sp,
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
                                itemCount: state.resultTest.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ordinary(
                                      state.resultTest[index].answersDetail!,
                                      state.resultTest[index].questionContent!,
                                      (index + 1).toString());
                                }),
                          ),
                        ],
                      );
                    }
                    return const Center(child: Text("Iltimos kuting...."));
                  },
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget ordinary(
      List<AnswersDetail> model, String questionText, String index) {
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
                questionText,
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
                    for (int t = 0; t < model.length; t++)
                      Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        child: Text(model[t].content!,
                            style: returnStyle(model[t].selectedAnswer!,
                                model[t].answerId!, model[t].correctAnswer!)),
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

  TextStyle returnStyle(int selectedId, int answerId, int correctId) {
    if (answerId == correctId && answerId == selectedId) {
      return AppStyles.subtitleTextStyle
          .copyWith(fontSize: 12.sp, color: Colors.green);
    } else if (selectedId == answerId && answerId != correctId) {
      return AppStyles.subtitleTextStyle
          .copyWith(fontSize: 12.sp, color: Colors.red);
    }
    return AppStyles.subtitleTextStyle
        .copyWith(fontSize: 12.sp, color: Colors.grey);
  }
}
