import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/components/custom_appbar.dart';
import 'package:test_app/res/components/custom_dot.dart';
import 'package:test_app/res/components/custom_drawer.dart';
import '../../../core/bloc/drawer_cubit/drawer_cubit.dart';
import '../../../core/bloc/mistakes_cubit/mistakes_cubit.dart';
import '../../../core/bloc/test_cubit/test_cubit.dart';
import '../../../core/domain/test_model/test_result_model.dart';
import '../../../res/constants.dart';
import '../../../res/functions/will_pop_function.dart';

class MistakesScreen extends StatefulWidget {
  const MistakesScreen({Key? key}) : super(key: key);

  @override
  State<MistakesScreen> createState() => _MistakesScreenState();
}

class _MistakesScreenState extends State<MistakesScreen> {
  final GlobalKey<ScaffoldState> scaffKey = GlobalKey<ScaffoldState>();
  var _currentSubjectId = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(mainWidth: MediaQuery.of(context).size.width),
      backgroundColor: AppColors.mainColor,
      key: scaffKey,
      body: WillPopScope(
        onWillPop: () async {
          return await onWillPop(context);
        },
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await context
                  .read<MistakesCubit>()
                  .getErrorList(_currentSubjectId);
            },
            child: Column(children: [
              CustomAppBar(scaffKey: scaffKey),
              BlocBuilder<DrawerCubit, DrawerState>(
                builder: (context, state) {
                  if (state is DrawerSubjectsLoadedState) {
                    _currentSubjectId = state.index + 2;
                    context
                        .read<MistakesCubit>()
                        .getErrorList(_currentSubjectId);
                  }
                  return Flexible(
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(28.r),
                          topRight: Radius.circular(28.r),
                        ),
                      ),
                      child: BlocBuilder<MistakesCubit, MistakesState>(
                        builder: (context, state) {
                          if (state is OnMistakesError) {
                            print(state.error);
                          }
                          if (state is OnMistakesReceived) {
                            final errorList = state.errorList;
                            return _onMistakes(errorList);
                          }
                          if (state is OnMistakesEmpty) {
                            return _onMistakesEmpty();
                          }
                          if (state is OnMistakesProgress) {
                            return _onProgress();
                          }
                          return _onProgress();
                        },
                      ),
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _onProgress() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget _onMistakesEmpty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Xatolar bilan ishlash",
          style: AppStyles.introButtonText.copyWith(
            color: Colors.black,
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Hozircha bu fan bo'yicha xatolar yo'q...",
            ),
          ),
        )
      ],
    );
  }

  Widget _onMistakes(List<TestResult> errorList) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Xatolar bilan ishlash",
            style: AppStyles.introButtonText.copyWith(
              color: Colors.black,
            ),
          ),
          Gap(10.h),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: errorList.length,
              itemBuilder: (BuildContext context, int index) {
                return testItem(
                  errorList[index],
                  errorList[index].answersDetail!,
                  errorList[index].questionContent!,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget testItem(
      TestResult result, List<AnswersDetail> ansList, String testQ) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      child: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  CustomDot(
                    hight: 14.h,
                    width: 14.w,
                    color: AppColors.mainColor,
                  ),
                  Gap(9.w),
                  Expanded(
                    child: Text(
                      "Test: ${result.testContent}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppStyles.subtitleTextStyle.copyWith(
                        color: AppColors.titleColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(10.h),
              Row(
                children: [
                  Text(
                    "Savol #: ${result.questionPrior}",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      color: AppColors.titleColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: Text(
                      "Fan #: ${result.subjectName}",
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.subtitleTextStyle.copyWith(
                        color: AppColors.titleColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(9.w),
          Container(
            padding: EdgeInsets.all(14.h),
            width: 336.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.mainColor,
                width: 1.w,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(13.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  testQ,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.subtitleTextStyle.copyWith(
                    color: AppColors.titleColor,
                    fontSize: 12.sp,
                  ),
                ),
                Gap(14.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < ansList.length; i++)
                      Row(
                        children: [
                          CustomDot(
                            hight: 11.h,
                            width: 11.w,
                            color: getColor(
                              ansList[i].selectedAnswer!,
                              ansList[i].answerId!,
                              ansList[i].correctAnswer!,
                            ),
                          ),
                          Gap(3.w),
                          Expanded(
                            child: Text(ansList[i].content!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: returnStyle(
                                  ansList[i].selectedAnswer!,
                                  ansList[i].answerId!,
                                  ansList[i].correctAnswer!,
                                )),
                          )
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

  TextStyle returnStyle(int selectedId, int answerId, int correctId) {
    if (selectedId == answerId && answerId != correctId) {
      return AppStyles.subtitleTextStyle
          .copyWith(fontSize: 12.sp, color: Colors.red);
    }
    return AppStyles.subtitleTextStyle
        .copyWith(fontSize: 12.sp, color: Colors.grey);
  }

  Color getColor(int selectedId, int answerId, int correctId) {
    if (selectedId == answerId && answerId != correctId) {
      return Colors.red;
    }
    return Colors.grey;
  }
}
