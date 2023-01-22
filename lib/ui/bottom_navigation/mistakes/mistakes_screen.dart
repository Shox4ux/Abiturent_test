import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/components/custom_appbar.dart';
import 'package:test_app/res/components/custom_dot.dart';
import 'package:test_app/res/components/custom_drawer.dart';
import '../../../core/bloc/auth_cubit/auth_cubit.dart';
import '../../../core/bloc/drawer_cubit/drawer_cubit.dart';
import '../../../core/bloc/mistakes_cubit/mistakes_cubit.dart';
import '../../../core/domain/mistakes_model/mistakes_model.dart';
import '../../../res/constants.dart';
import '../../../res/functions/show_toast.dart';
import '../../../res/functions/will_pop_function.dart';

class MistakesScreen extends StatefulWidget {
  const MistakesScreen({Key? key}) : super(key: key);

  @override
  State<MistakesScreen> createState() => _MistakesScreenState();
}

class _MistakesScreenState extends State<MistakesScreen> {
  final GlobalKey<ScaffoldState> scaffKey = GlobalKey<ScaffoldState>();
  var _currentSubjectId = 0;

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 1)) {
      currentBackPressTime = now;
      showToast("Darturdan chiqich uchun tugmani ikki marta bosing");
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<MistakesCubit>().getErrorList(_currentSubjectId);
      },
      child: Scaffold(
        drawer: CustomDrawer(mainWidth: MediaQuery.of(context).size.width),
        backgroundColor: AppColors.mainColor,
        key: scaffKey,
        body: WillPopScope(
          onWillPop: () async {
            return await onWillPop();
          },
          child: SafeArea(
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
                          if (state is OnMistakesError) {}
                          if (state is OnMistakesReceived) {
                            final errorList = state.mistakesModel.data;
                            final subName = state.mistakesModel.subjectName;
                            return _onMistakes(errorList!, subName!);
                          }
                          if (state is OnMistakesEmpty) {
                            return _onMistakesEmpty(state.subjectName);
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

  Widget _onMistakesEmpty(String subName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Xatolar bilan ishlash",
          style: AppStyles.introButtonText.copyWith(
            color: Colors.black,
          ),
        ),
        Text(
          subName,
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

  Widget _onMistakes(List<Data> errorList, String subName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Xatolar bilan ishlash",
          style: AppStyles.introButtonText.copyWith(
            color: Colors.black,
          ),
        ),
        Text(
          subName,
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
              );
            },
          ),
        )
      ],
    );
  }

  Widget testItem(Data mistakeData, List<AnswersDetail> ansList) {
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
                      "Test: ${mistakeData.testContent}",
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
              Gap(5.h),
              Row(
                children: [
                  Text(
                    "Savol #: ${mistakeData.questionPrior}",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      color: AppColors.titleColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: Text(
                      "Fan #: ${mistakeData.subjectName}",
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
                if (mistakeData.image != null)
                  Container(
                    height: 150.h,
                    width: double.maxFinite,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Image.network(
                      mistakeData.image ?? "",
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Text(
                    mistakeData.questionContent ?? "",
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
