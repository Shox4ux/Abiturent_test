import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/test_model/test_inner_model.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/components/custom_dot.dart';

import '../../core/block/test_block/test_cubit.dart';
import '../../core/helper/repos/test_repo.dart';
import '../../res/components/custom_simple_appbar.dart';
import '../../res/navigation/main_navigation.dart';

class TestScreen extends StatefulWidget {
  const TestScreen(
      {Key? key,
      required this.testId,
      required this.subName,
      required this.testIndex})
      : super(key: key);

  final int testId;
  final String subName;
  final int testIndex;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var _questionNumber = 1;
  int? _selectedAnswerIndex;
  List<InnerTestModel> testList = [];
  var forIndex = 0;
  final repo = TestRepo();

  Future<List<InnerTestModel>> getInnerTestModel(
    int testId,
  ) async {
    final response = await repo.getInnerTestList(testId);
    if (response.statusCode == 200) {
      testList.clear();
      final rowData = response.data as List;
      print(rowData);
      final rowList = rowData
          .map(
            (e) => InnerTestModel.fromJson(e),
          )
          .toList();
      testList = rowList;
      return testList;
    }
    return testList;
  }

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
                    "${widget.subName} fani: To’plam #${widget.testIndex}",
                routeText: RouteNames.profile,
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
                child: BlocConsumer<TestCubit, TestState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is OnTestInnerSuccess) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(28.h),
                          Container(
                            height: 33.h,
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
                                  "$_questionNumber.Savol",
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
                                fontSize: 18.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Gap(57.h),
                          Column(
                            children: [
                              for (var i = 0;
                                  i < state.innerTest.answers!.length;
                                  i++)
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
                          Gap(168.h),
                          ElevatedButton(
                            style: AppStyles.introUpButton,
                            onPressed: () {
                              setState(() {
                                _questionNumber = _questionNumber + 1;
                              });
                              context.read<TestCubit>().sendTestAnswer(
                                  state.innerTest.id!,
                                  state.innerTest
                                      .answers![_selectedAnswerIndex!].id!);
                              _selectedAnswerIndex = null;
                            },
                            child: Text(
                              "Keyingi savol",
                              style: AppStyles.introButtonText
                                  .copyWith(color: const Color(0xffFCFCFC)),
                            ),
                          ),
                        ],
                      );
                    }

                    return const Center(
                      child: Text("Loading..."),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget testItem(Answers model, bool isPressed) {
    return isPressed
        ? Container(
            height: 50.h,
            width: 321.w,
            padding: EdgeInsets.only(left: 20.w),
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

  Container ordinary(Answers model) {
    return Container(
      height: 50.h,
      width: 321.w,
      padding: EdgeInsets.only(left: 20.w),
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
