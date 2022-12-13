import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:test_app/core/domain/test_model/test_inner_model.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/components/custom_dot.dart';
import 'package:test_app/res/components/waiting.dart';

import '../../core/block/test_block/test_cubit.dart';
import '../../core/domain/test_model/test_result_model.dart';
import '../../res/components/custom_simple_appbar.dart';
import '../../res/navigation/main_navigation.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({
    Key? key,
    required this.testId,
    required this.subName,
    required this.testIndex,
    required this.questionCount,
  }) : super(key: key);

  final int testId;
  final String subName;
  final int testIndex;
  final int questionCount;
  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var _questionNumber = 1;
  int? _selectedAnswerIndex;
  final complitionTime = DateFormat('yyyy.MM.dd kk:mm').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: BlocConsumer<TestCubit, TestState>(
          listener: (context, state) {
            if (state is OnTestError) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => WaitingScreen(
                          status: WarningValues.obunaError,
                          alertText: state.error,
                          extraText: "",
                          buttonText: "Obunalar oynasiga o'tish",
                        )),
              );
            }
          },
          builder: (context, state) {
            if (state is OnTestInnerSuccess) {
              return onInnerTest(state, context);
            }

            if (state is OnCelebrate) {
              return onTestCelebration(state, context);
            }
            if (state is OnTestCompleted) {
              return onTestEnd();
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Column onTestEnd() {
    return Column(
      children: [
        CustomSimpleAppBar(
          isIcon: false,
          isSimple: true,
          titleText: "${widget.subName} fani: To’plam #${widget.questionCount}",
          routeText: RouteNames.main,
          style: AppStyles.subtitleTextStyle
              .copyWith(fontSize: 20.sp, color: Colors.white),
          iconColor: Colors.white,
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
                      Gap(20.h),
                      Text(
                        "Tugatilgan sana: $complitionTime",
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
                              return ordinaryAnswer(
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
    );
  }

  Expanded onTestCelebration(OnCelebrate state, BuildContext context) {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
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
            Text("Test yakulandi",
                style: AppStyles.smsVerBigTextStyle.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                )),
            Gap(271.h),
            (state is OnTestProgress)
                ? const CircularProgressIndicator(
                    color: AppColors.mainColor,
                  )
                : ElevatedButton(
                    style: AppStyles.introUpButton,
                    onPressed: () {
                      context.read<TestCubit>().getResults(state.testListId);
                    },
                    child: Text(
                      "Natijalarni ko'rish",
                      style: AppStyles.introButtonText
                          .copyWith(color: const Color(0xffFCFCFC)),
                    )),
          ],
        ),
      ),
    );
  }

  Column onInnerTest(OnTestInnerSuccess state, BuildContext context) {
    return Column(
      children: [
        CustomSimpleAppBar(
          isIcon: false,
          isSimple: true,
          titleText: "${widget.subName} fani: To’plam #${widget.testIndex}",
          routeText: RouteNames.profile,
          style: AppStyles.subtitleTextStyle.copyWith(
            fontSize: 20.sp,
            color: Colors.white,
          ),
          iconColor: Colors.white,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Gap(28.h),
                  Container(
                    padding: EdgeInsets.all(6.h),
                    width: 116.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.r),
                      border: Border.all(
                        width: 1,
                        color: AppColors.textFieldBorderColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomDot(
                          hight: 14.h,
                          width: 14.w,
                          color: AppColors.mainColor,
                        ),
                        Gap(7.w),
                        Text(
                          "${state.innerTest.prior}.Savol",
                          style: AppStyles.subtitleTextStyle.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(8.h),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      state.innerTest.content!,
                      style: AppStyles.subtitleTextStyle.copyWith(
                        fontSize: 15.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Gap(50.h),
                  Column(
                    children: [
                      for (var i = 0; i < state.innerTest.answers!.length; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedAnswerIndex == i) {
                                _selectedAnswerIndex = null;
                              } else {
                                _selectedAnswerIndex = i;
                              }
                            });
                          },
                          child: testItem(state.innerTest.answers![i],
                              (i == _selectedAnswerIndex)),
                        ),
                    ],
                  ),
                ]),
                _selectedAnswerIndex != null
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 24.h),
                        child: ElevatedButton(
                          style: AppStyles.introUpButton,
                          onPressed: () {
                            setState(() {
                              _questionNumber = _questionNumber + 1;
                            });
                            context.read<TestCubit>().sendTestAnswer(
                                  state.innerTest.id!,
                                  state.innerTest
                                      .answers![_selectedAnswerIndex!].id!,
                                  state.innerTest.testListId!,
                                );

                            _selectedAnswerIndex = null;
                          },
                          child: Text(
                            "Keyingi savol",
                            style: AppStyles.introButtonText
                                .copyWith(color: const Color(0xffFCFCFC)),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(bottom: 24.h),
                        child: ElevatedButton(
                          style: AppStyles.disabledButton,
                          onPressed: null,
                          child: Text(
                            "Keyingi savol",
                            style: AppStyles.introButtonText
                                .copyWith(color: const Color(0xffFCFCFC)),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget ordinaryAnswer(
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

  Widget testItem(Answers model, bool isPressed) {
    return isPressed
        ? Container(
            width: 321.w,
            padding: EdgeInsets.all(10.h),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 8.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.r),
                color: AppColors.mainColor),
            child: Row(
              children: [
                SizedBox(
                  height: 24.h,
                  width: 24.w,
                  child: Image.asset(
                    AppIcons.white,
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: Text(
                    model.content!,
                    style: AppStyles.subtitleTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          )
        : ordinary(model);
  }

  Widget ordinary(Answers model) {
    return Container(
      width: 321.w,
      padding: EdgeInsets.all(10.h),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(
          width: 1,
          color: AppColors.textFieldBorderColor,
        ),
      ),
      child: Text(
        model.content!,
        style: AppStyles.subtitleTextStyle.copyWith(
          color: Colors.black,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
