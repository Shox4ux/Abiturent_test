import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/components/custom_appbar.dart';
import 'package:test_app/res/components/custom_drawer.dart';
import 'package:test_app/ui/test_screens/test.dart';

import '../../../core/block/drawer_cubit/drawer_cubit.dart';
import '../../../core/block/test_block/test_cubit.dart';
import '../../../core/domain/test_model/test_model.dart';
import '../../../core/helper/repos/test_repo.dart';
import '../../../res/navigation/main_navigation.dart';

TestModel? testModel;

class DtmScreen extends StatefulWidget {
  const DtmScreen({Key? key, required this.testType}) : super(key: key);
  final int testType;
  @override
  State<DtmScreen> createState() => _DtmScreenState();
}

class _DtmScreenState extends State<DtmScreen> {
  final repo = TestRepo();

  Future<TestModel> getTestModel(int subId) async {
    final response = await repo.getTestsBySubjectId(subId, 0);

    testModel = null;
    if (response.statusCode == 200) {
      final allTestData = TestModel.fromJson(response.data);

      testModel = allTestData;

      return testModel!;
    }

    return testModel!;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: scaffKey,
        backgroundColor: AppColors.mainColor,
        drawer: CustomDrawer(
          mainWidth: screenWidth,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      return FutureBuilder(
                        future: getTestModel(state.subId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Text("Iltimos kuting..."),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "DTM testlar",
                                    style: AppStyles.introButtonText
                                        .copyWith(color: AppColors.titleColor),
                                  ),
                                  Gap(5.h),
                                  Text(
                                    testModel!.subjects!.name!,
                                    style: AppStyles.introButtonText
                                        .copyWith(color: AppColors.titleColor),
                                  ),
                                ],
                              ),
                              Gap(20.h),
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemCount: testModel!.tests!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return gridItem(context,
                                        testModel!.tests![index], (index + 1));
                                  },
                                ),
                              )
                            ],
                          );
                        },
                      );
                    }
                    return FutureBuilder(
                      future: getTestModel(widget.testType),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Iltimos kuting..."),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "DTM testlar",
                                  style: AppStyles.introButtonText
                                      .copyWith(color: AppColors.titleColor),
                                ),
                                Gap(5.h),
                                Text(
                                  testModel!.subjects!.name!,
                                  style: AppStyles.introButtonText
                                      .copyWith(color: AppColors.titleColor),
                                ),
                              ],
                            ),
                            Gap(20.h),
                            (testModel!.tests!.isEmpty)
                                ? const Center(
                                    child: Text("Testlar topilmadi"),
                                  )
                                : Expanded(
                                    child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2),
                                      itemCount: testModel!.tests!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return gridItem(
                                            context,
                                            testModel!.tests![index],
                                            (index + 1));
                                      },
                                    ),
                                  )
                          ],
                        );
                      },
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

  Widget gridItem(BuildContext context, Tests tests, int testIndex) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TestScreen(
                    testId: tests.id!,
                    subName: tests.subjectName!,
                    testIndex: testIndex,
                    questionCount: tests.questionsCount!,
                  )),
        );
        context.read<TestCubit>().getTestById(tests.id!);
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(9.h),
                height: 132.h,
                width: 132.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(120.r),
                  border: Border.all(
                    color: AppColors.mainColor, //<--- color
                    width: 5.0,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.h),
                  height: 113.h,
                  width: 113.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(120.r),
                  ),
                  child: Image.asset(
                    AppIcons.star,
                    scale: 3.h,
                  ),
                ),
              ),
              Positioned(
                top: 90.h,
                right: 0.w,
                child: Container(
                  height: 42.h,
                  width: 42.w,
                  decoration: BoxDecoration(
                    color: AppColors.subtitleColor,
                    borderRadius: BorderRadius.circular(120.r),
                  ),
                  child: Center(
                    child: Text(
                      "${tests.questionsCount}",
                      style: AppStyles.subtitleTextStyle.copyWith(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Gap(10.h),
          Text(
            "DTM test to’plam #$testIndex",
            style: AppStyles.smsVerBigTextStyle.copyWith(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
