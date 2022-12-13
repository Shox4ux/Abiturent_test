import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/block/drawer_cubit/drawer_cubit.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/test_repo.dart';
import 'package:test_app/res/components/custom_appbar.dart';
import 'package:test_app/res/components/custom_dot.dart';
import 'package:test_app/res/components/custom_drawer.dart';
import '../../../core/domain/test_model/test_result_model.dart';
import '../../../res/constants.dart';
import '../../../res/functions/show_toast.dart';
import '../subjects/subject_screen.dart';

List<TestResult>? errorList;
final _repo = TestRepo();
final _storage = AppStorage();

class MistakesScreen extends StatefulWidget {
  const MistakesScreen({Key? key}) : super(key: key);

  @override
  State<MistakesScreen> createState() => _MistakesScreenState();
}

class _MistakesScreenState extends State<MistakesScreen> {
  @override
  void initState() {
    getErrorList(1);
    super.initState();
  }

  final GlobalKey<ScaffoldState> scaffKey = GlobalKey<ScaffoldState>();

  Future<List<TestResult>> getErrorList(int subId) async {
    final uId = await _storage.getUserId();
    final response = await _repo.getErrorList(uId, subId);
    errorList = null;
    if (response.statusCode == 200) {
      final rowData = response.data as List;
      final rowtList = rowData.map((e) => TestResult.fromJson(e)).toList();
      errorList = rowtList;
      return errorList!;
    }

    return errorList!;
  }

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
          child: Column(children: [
            CustomAppBar(scaffKey: scaffKey),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
                child: BlocBuilder<DrawerCubit, DrawerState>(
                  builder: (context, state) {
                    if (state is DrawerSubId) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Xatolar bilan ishlash",
                            style: AppStyles.introButtonText.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          Gap(10.h),
                          FutureBuilder(
                            future: getErrorList(state.subId),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Expanded(
                                  child:
                                      Center(child: Text("Iltimos kuting...")),
                                );
                              }
                              return errorList!.isNotEmpty
                                  ? Expanded(
                                      child: ListView.builder(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          itemCount: errorList!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return testItem(
                                              errorList![index],
                                              errorList![index].answersDetail!,
                                              errorList![index]
                                                  .questionContent!,
                                            );
                                          }),
                                    )
                                  : const Expanded(
                                      child: Center(
                                        child: Text(
                                            "Hozircha bu fan bo'yicha xatolar yo'q..."),
                                      ),
                                    );
                            },
                          )
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Xatolar bilan ishlash",
                          style: AppStyles.introButtonText.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Gap(10.h),
                        FutureBuilder(
                          future: getErrorList(1),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Expanded(
                                child: Center(
                                  child: Text("Hozircha xatolar topilmadi..."),
                                ),
                              );
                            } else {
                              return errorList!.isNotEmpty
                                  ? Expanded(
                                      child: ListView.builder(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          itemCount: errorList!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return testItem(
                                              errorList![index],
                                              errorList![index].answersDetail!,
                                              errorList![index]
                                                  .questionContent!,
                                            );
                                          }),
                                    )
                                  : const Expanded(
                                      child: Center(
                                        child: Text(
                                            "Hozircha bu fan bo'yicha xatolar yo'q..."),
                                      ),
                                    );
                            }
                          },
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ]),
        ),
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

  Future<bool> onWillPop(BuildContext context) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToast("Darturdan chiqich uchun tugmani ikki marta bosing");
      return Future.value(false);
    }
    return Future.value(true);
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
