import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/bloc/inner_test_cubit/inside_test_cubit.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/components/custom_appbar.dart';
import 'package:test_app/res/components/custom_drawer.dart';
import 'package:test_app/ui/test_screens/test.dart';
import '../../../core/bloc/drawer_cubit/drawer_cubit.dart';
import '../../../core/bloc/test_cubit/test_cubit.dart';
import '../../../core/domain/test_model/test_model.dart';
import '../../../core/helper/repos/test_repo.dart';
import '../../../res/functions/will_pop_function.dart';
import '../../../res/painter.dart';

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
  var currentPage = 1;

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
          child: BlocBuilder<DrawerCubit, DrawerState>(
            builder: (context, state) {
              if (state is DrawerSubjectsLoadedState) {
                _currentSubjectId = state.index + 2;
                context.read<TestCubit>().getTestBySubIdWithPagination(
                    subId: _currentSubjectId!,
                    type: ApiValues.dtmTestType,
                    page: currentPage);
              }
              return Column(
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
                      child: BlocBuilder<TestCubit, TestState>(
                          builder: (context, state) {
                        if (state is OnTestSuccess) {
                          final subjectData = state.subjectData;
                          final testList = state.testList;
                          return _onDtmTest(subjectData, testList);
                        }
                        if (state is OnTestProgress) {
                          return _onProgress();
                        }
                        return _onProgress();
                      }),
                    ),
                  )
                ],
              );
            },
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

  Column _onDtmTest(Subjects subjectData, List<Tests> testList) {
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
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: testList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return gridItem(context, testList[index], (index + 1));
                  },
                ),
              ),
      ],
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
        context.read<InnerTestCubit>().getTestById(tests.id!);
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
