import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/test_repo.dart';
import 'package:test_app/res/enum.dart';
import 'package:test_app/res/components/custom_appbar.dart';
import 'package:test_app/res/components/custom_dot.dart';
import 'package:test_app/res/components/custom_drawer.dart';

import '../../../core/block/test_block/test_cubit.dart';
import '../../../core/block/user_block/user_cubit_cubit.dart';
import '../../../core/domain/test_model/test_result_model.dart';
import '../../../res/constants.dart';

List<TestResult>? errorList;
final _repo = TestRepo();
final _storage = AppStorage();

class MistakesScreen extends StatelessWidget {
  const MistakesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;

    Future<List<TestResult>> getErrorList() async {
      final uId = await _storage.getUserId();
      final response = await _repo.getErrorList(uId);
      errorList = null;
      if (response.statusCode == 200) {
        final rowData = response.data as List;
        final rowtList = rowData.map((e) => TestResult.fromJson(e)).toList();
        errorList = rowtList;
        return errorList!;
      }

      return errorList!;
    }

    return Scaffold(
      drawer: CustomDrawer(mainWidth: screenWidth),
      backgroundColor: AppColors.mainColor,
      key: scaffKey,
      body: SafeArea(
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
                  FutureBuilder(
                    future: getErrorList(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("Iltimos kuting..."),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: errorList!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return testItem(
                                  errorList![index].answersDetail!,
                                  errorList![index].questionContent!,
                                );
                              }),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget testItem(List<AnswersDetail> ansList, String testQ) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      child: Column(
        children: [
          Row(
            children: [
              CustomDot(
                hight: 14.h,
                width: 14.w,
                color: AppColors.mainColor,
              ),
              Gap(9.w),
              Text(
                "Test: Test11",
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: AppColors.titleColor,
                  fontSize: 14.sp,
                ),
              ),
              Gap(24.w),
              Text(
                "Savol #: 12",
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: AppColors.titleColor,
                  fontSize: 14.sp,
                ),
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
