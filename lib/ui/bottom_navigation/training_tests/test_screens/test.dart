import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../core/bloc/inner_test_cubit/inside_test_cubit.dart';
import '../../../../core/bloc/subscription_cubit/subscription_cubit.dart';
import '../../../../core/domain/test_model/test_inner_model.dart';
import '../../../../core/domain/test_model/test_result_model.dart';
import '../../../../res/components/custom_dot.dart';
import '../../../../res/components/custom_simple_appbar.dart';
import '../../../../res/constants.dart';
import '../../../../res/navigation/main_navigation.dart';

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
        child: BlocBuilder<InnerTestCubit, InsideTestState>(
          builder: (context, state) {
            if (state is OnInnerTestError) {
              return whenError(state.error, "Obunalar oynasiga o'tish",
                  WarningValues.obunaError);
            }
            if (state is OnTestInnerSuccess) {
              return onInnerTest(state, context);
            }

            if (state is OnInnerTestCelebrate) {
              return onTestCelebration(state, context);
            }
            if (state is OnInnerTestCompleted) {
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

  Widget whenError(String errorText, String buttonText, String status) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
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
          Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: ElevatedButton(
              style: AppStyles.introUpButton,
              onPressed: () {
                if (status == WarningValues.hisobError) {
                  Navigator.of(context).pushNamed(
                    RouteNames.addCard,
                  );
                  return;
                }
                if (status == WarningValues.obunaError) {
                  context.read<SubscriptionCubit>().getScripts();
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
          ),
        ],
      ),
    );
  }

  Widget onTestEnd() {
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
            child: BlocBuilder<InnerTestCubit, InsideTestState>(
              builder: (context, state) {
                if (state is OnInnerTestCompleted) {
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

  Widget onTestCelebration(OnInnerTestCelebrate state, BuildContext context) {
    return ColoredBox(
      color: Colors.white,
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
          Text("Test yakunlandi",
              style: AppStyles.smsVerBigTextStyle.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              )),
          Gap(271.h),
          (state is OnInnerTestProgress)
              ? const CircularProgressIndicator(
                  color: AppColors.mainColor,
                )
              : ElevatedButton(
                  style: AppStyles.introUpButton,
                  onPressed: () {
                    context.read<InnerTestCubit>().getResults(state.testListId);
                  },
                  child: Text(
                    "Natijalarni ko'rish",
                    style: AppStyles.introButtonText
                        .copyWith(color: const Color(0xffFCFCFC)),
                  )),
        ],
      ),
    );
  }

  Widget onInnerTest(OnTestInnerSuccess state, BuildContext context) {
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
                  // state.innerTest.image != null
                  //     ? const SizedBox.shrink()
                  //     : SizedBox(
                  //         height: 150.h,
                  //         width: double.maxFinite,
                  //         child: Image.network(
                  //           state.innerTest.image!,
                  //           fit: BoxFit.cover,
                  //         ),
                  //       ),

                  if (state.innerTest.image != null)
                    Container(
                      height: 160.h,
                      width: double.maxFinite,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Image.network(
                        state.innerTest.image ?? "",
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    SizedBox.shrink(),

                  Padding(
                    padding: EdgeInsets.only(left: 10.w, top: 4.h),
                    child: Text(
                      state.innerTest.content!,
                      style: AppStyles.subtitleTextStyle.copyWith(
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Gap(45.h),
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
                            context.read<InnerTestCubit>().sendTestAnswer(
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
