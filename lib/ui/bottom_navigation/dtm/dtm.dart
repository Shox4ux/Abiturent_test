import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/components/custom_appbar.dart';
import 'package:test_app/res/components/custom_drawer.dart';
import 'package:test_app/ui/bottom_navigation/rating/rating_screen.dart';
import 'package:test_app/ui/test_screens/test.dart';

import '../../../core/block/drawer_cubit/drawer_cubit.dart';
import '../../../core/block/test_block/test_cubit.dart';
import '../../../core/domain/test_model/test_model.dart';
import '../../../core/helper/repos/test_repo.dart';
import '../../../res/navigation/main_navigation.dart';
import '../../../res/painter.dart';

TestModel? testModel;

class DtmScreen extends StatefulWidget {
  const DtmScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<DtmScreen> createState() => _DtmScreenState();
}

class _DtmScreenState extends State<DtmScreen>
    with SingleTickerProviderStateMixin {
  final repo = TestRepo();

  AnimationController? _animationController;
  Animation<double>? animation;
  final maxProgress = 80.0;

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  void startAnimation() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation = Tween<double>(begin: 0, end: maxProgress)
        .animate(_animationController!)
      ..addListener(() {});
  }

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
    if (_animationController != null) {
      _animationController!.forward();
    }
    final GlobalKey<ScaffoldState> scaffKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffKey,
      backgroundColor: AppColors.mainColor,
      drawer: CustomDrawer(
        mainWidth: screenWidth,
      ),
      body: WillPopScope(
        onWillPop: () async {
          return await onWillPop(context);
        },
        child: SafeArea(
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
                              return const Center(
                                child: Text("Iltimos kuting..."),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(
                                    "DTM testlar",
                                    style: AppStyles.introButtonText.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Gap(10.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(
                                    testModel!.subjects!.name!,
                                    style: AppStyles.introButtonText.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Gap(10.h),
                                (testModel!.tests!.isEmpty)
                                    ? const Expanded(
                                        child: Center(
                                            child: Text("Testlar topilmadi")),
                                      )
                                    : Expanded(
                                        child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2),
                                          itemCount: testModel!.tests!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return gridItem(
                                                context,
                                                testModel!.tests![index],
                                                (index + 1));
                                          },
                                        ),
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
                            return const Center(
                                child: Text("Iltimos kuting..."));
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Text(
                                  "DTM testlar",
                                  style: AppStyles.introButtonText.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Gap(10.h),
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
                                  ? const Expanded(
                                      child: Center(
                                        child: Text("Testlar topilmadi"),
                                      ),
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
                width: 130.w,
                height: 130.h,
                padding: EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(120.r),
                ),
                child: Container(
                  padding: EdgeInsets.all(18.h),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(200.r),
                  ),
                  child: Image.asset(
                    AppIcons.star,
                    scale: 3.h,
                  ),
                ),
              ),
              CustomPaint(
                foregroundPainter: CircleProgress(
                  tests.percent!.toDouble(),
                  8.0,
                ),
              ),
              Positioned(
                top: 90.h,
                right: 0.w,
                child: Container(
                  height: 35.h,
                  width: 35.w,
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
              ),
            ],
          ),
          Text(
            "DTM test to’plam #$testIndex",
            style: AppStyles.smsVerBigTextStyle.copyWith(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
