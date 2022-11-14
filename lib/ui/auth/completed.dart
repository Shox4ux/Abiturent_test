import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../core/block/test_block/test_cubit.dart';
import '../../res/constants.dart';
import '../test_screens/test_answers.dart';

class CompletedTest extends StatefulWidget {
  const CompletedTest({super.key, required this.subName, required this.qCount});

  final String subName;
  final String qCount;

  @override
  State<CompletedTest> createState() => _CompletedTestState();
}

class _CompletedTestState extends State<CompletedTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocConsumer<TestCubit, TestState>(
        listener: (context, state) {
          if (state is OnTestCompleted) {
            final complitionTime =
                DateFormat('yyyy.MM.dd kk:mm').format(DateTime.now());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TestAnswerScreen(
                  subName: widget.subName,
                  testNumber: widget.qCount,
                  complitionTime: complitionTime,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OnCelebrate) {
            return Column(
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
                          context
                              .read<TestCubit>()
                              .getResults(state.testListId);
                        },
                        child: Text(
                          "Natijalarni ko'rish",
                          style: AppStyles.introButtonText
                              .copyWith(color: const Color(0xffFCFCFC)),
                        )),
              ],
            );
          } else {
            return const CircularProgressIndicator(color: AppColors.mainColor);
          }
        },
      )),
    );
  }
}
