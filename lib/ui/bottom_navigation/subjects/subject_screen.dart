import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/test_model/test_model.dart';
import 'package:test_app/core/helper/repos/test_repo.dart';
import 'package:test_app/res/components/custom_dot.dart';
import 'package:test_app/res/components/custom_drawer.dart';
import 'package:test_app/res/navigation/main_navigation.dart';

import '../../../core/block/drawer_cubit/drawer_cubit.dart';

import '../../../res/constants.dart';
import '../../../res/components/custom_appbar.dart';
import '../../test_screens/test.dart';

TestModel? testModel;

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({
    Key? key,
    required this.testType,
  }) : super(key: key);

  final int testType;

  @override
  Widget build(BuildContext context) {
    final repo = TestRepo();

    final GlobalKey<ScaffoldState> scaffKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;

    Future<TestModel> getTestModel(int subId) async {
      final response = await repo.getTestsBySubjectId(subId, 1);

      if (response.statusCode == 200) {
        final allTestData = TestModel.fromJson(response.data);
        testModel = allTestData;

        return testModel!;
      }

      return testModel!;
    }

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      key: scaffKey,
      drawer: CustomDrawer(mainWidth: screenWidth),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(scaffKey: scaffKey),
            Expanded(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 14.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28.r),
                      topRight: Radius.circular(28.r),
                    )),
                child: BlocBuilder<DrawerCubit, DrawerState>(
                  builder: (context, state) {
                    if (state is DrawerSubId) {
                      return FutureBuilder(
                        future: getTestModel(state.subId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: Text("Loading..."));
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Text(
                                  testModel!.subjects!.name!,
                                  style: AppStyles.introButtonText.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Gap(10.h),
                              (testModel!.tests!.isEmpty)
                                  ? const Center(
                                      child: Text("Testlar topilmadi"))
                                  : Expanded(
                                      child: ListView.builder(
                                          padding: EdgeInsets.only(
                                            bottom: 20.h,
                                            top: 10.h,
                                          ),
                                          itemCount: testModel!.tests!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return subjectItem(
                                              testModel!.tests![index],
                                              context,
                                              (index + 1),
                                            );
                                          }),
                                    ),
                            ],
                          );
                        },
                      );
                    }
                    return FutureBuilder(
                      future: getTestModel(1),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: Text("Loading..."));
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                testModel!.subjects!.name!,
                                style: AppStyles.introButtonText.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Gap(10.h),
                            (testModel!.tests!.isEmpty)
                                ? const Center(child: Text("Testlar topilmadi"))
                                : Expanded(
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(
                                          bottom: 20.h,
                                          top: 10.h,
                                        ),
                                        itemCount: testModel!.tests!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return subjectItem(
                                              testModel!.tests![index],
                                              context,
                                              (index + 1));
                                        }),
                                  ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget subjectItem(Tests tests, BuildContext context, int testIndex) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
      width: 333.w,
      height: 90.h,
      padding: EdgeInsets.only(
        right: 12.w,
        top: 13.h,
        bottom: 7.h,
        left: 9.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: [
        Row(
          children: [
            CustomDot(
              hight: 14.h,
              width: 14.w,
              color: AppColors.mainColor,
            ),
            Gap(5.w),
            Expanded(
              child: Text(
                tests.title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: AppColors.titleColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        Gap(16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 11.w),
              width: 94.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(120.r),
              ),
              child: Row(
                children: [
                  Image.asset(
                    AppIcons.info,
                  ),
                  Gap(9.w),
                  Text(
                    "${tests.questionsCount}",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TestScreen(
                            testId: tests.id!,
                            subName: tests.subjectName!,
                            testIndex: testIndex,
                          )),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 16.w),
                height: 32.h,
                width: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(120.r),
                ),
                child: Image.asset(
                  AppIcons.arrow,
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
