import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:test_app/core/bloc/dtm_cubit/dtm_cubit.dart';
import 'package:test_app/core/bloc/inner_test_cubit/inside_test_cubit.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/components/custom_appbar.dart';
import 'package:test_app/res/components/custom_drawer.dart';
import 'package:test_app/ui/bottom_navigation/training_tests/test_screens/test.dart';
import '../../../core/bloc/auth_cubit/auth_cubit.dart';
import '../../../core/bloc/drawer_cubit/drawer_cubit.dart';
import '../../../core/domain/test_model/test_model.dart';
import '../../../core/helper/repos/test_repo.dart';
import '../../../res/functions/show_toast.dart';
import '../../../res/functions/will_pop_function.dart';
import '../../../res/components/custom_circle_painter.dart';

int? _currentSubjectId;

class DtmScreen extends StatefulWidget {
  const DtmScreen({Key? key}) : super(key: key);
  @override
  State<DtmScreen> createState() => _DtmScreenState();
}

class _DtmScreenState extends State<DtmScreen>
    with SingleTickerProviderStateMixin {
  final repo = TestRepo();

  AnimationController? _animationController;
  Animation<double>? animation;
  final maxProgress = 80.0;
  final dtmTestType = 0;
  bool isTestEnd = false;

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

  Future<void> _startPagination() async {
    await context
        .read<DtmCubit>()
        .getDtmTestBySubIdWithPagination(_currentSubjectId!);
  }

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
    if (_animationController != null) {
      _animationController!.forward();
    }
    final GlobalKey<ScaffoldState> scaffKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        key: scaffKey,
        backgroundColor: AppColors.mainColor,
        drawer: CustomDrawer(
          mainWidth: screenWidth,
        ),
        body: WillPopScope(
          onWillPop: () async {
            return await onWillPop();
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(scaffKey: scaffKey),
                BlocBuilder<DrawerCubit, DrawerState>(
                  builder: (context, state) {
                    if (state is DrawerSubjectsLoadedState) {
                      _currentSubjectId = state.index + 2;
                      _startPagination();
                    }
                    return Expanded(
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.only(top: 14.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(28.r),
                              topRight: Radius.circular(28.r),
                            )),
                        child: BlocBuilder<DtmCubit, DtmState>(
                            builder: (context, state) {
                          if (state is OnDtmTestReceived) {
                            final subjectData = state.subjectData;
                            final testList = state.testList;
                            isTestEnd = state.isTestEnded;
                            return _onDtmTest(subjectData, testList);
                          }
                          if (state is OnDtmTestProgress) {
                            return _onProgress();
                          }
                          return _onProgress();
                        }),
                      ),
                    );
                  },
                )
              ],
            ),
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

  Widget _onDtmTest(Subjects subjectData, List<Tests> testList) {
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
            subjectData.name!,
            style: AppStyles.introButtonText.copyWith(
              color: Colors.black,
            ),
          ),
        ),
        Gap(10.h),
        (testList.isEmpty)
            ? const Flexible(child: Center(child: Text("Testlar topilmadi")))
            : Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: testList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return gridItem(testList[index], (index + 1));
                          }),
                    ),
                    isTestEnd
                        ? const Text("Boshqa testlar mavjud emas")
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: ElevatedButton(
                              style: AppStyles.introUpButton,
                              onPressed: () async {
                                await context
                                    .read<DtmCubit>()
                                    .startDtmPagination(_currentSubjectId!);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppIcons.down,
                                    scale: 3,
                                    color: Colors.white,
                                  ),
                                  Gap(10.w),
                                  Text(
                                    "Ko’proq testlar",
                                    style: AppStyles.introButtonText.copyWith(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget gridItem(Tests tests, int testIndex) {
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
        context.read<InnerTestCubit>().getTestById(tests.id!);
      },
      child: Column(
        children: [
          Stack(
            children: [
              CircularPercentIndicator(
                center: Container(
                  width: 125.w,
                  height: 125.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(120.r),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(18.h),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Image.asset(
                      AppIcons.star,
                      scale: 3,
                    ),
                  ),
                ),
                radius: 70.r,
                animation: true,
                animationDuration: 1200,
                lineWidth: 8,
                percent: (tests.percent! / 100).toDouble(),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: AppColors.backgroundColor,
                progressColor: Colors.green,
              ),
              // CustomPaint(
              //   foregroundPainter: CircleProgress(
              //     tests.percent!.toDouble(),
              //     7.0,
              //     54.r,
              //   ),
              // ),
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
