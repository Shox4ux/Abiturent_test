import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:test_app/core/bloc/inner_test_cubit/inside_test_cubit.dart';
import 'package:test_app/res/components/custom_dot.dart';
import 'package:test_app/res/components/custom_drawer.dart';
import 'package:test_app/ui/bottom_navigation/training_tests/test_screens/books.dart';
import '../../../core/bloc/auth_cubit/auth_cubit.dart';
import '../../../core/bloc/drawer_cubit/drawer_cubit.dart';
import '../../../core/bloc/test_cubit/test_cubit.dart';
import '../../../core/domain/test_model/test_model.dart';
import '../../../res/constants.dart';
import '../../../res/components/custom_appbar.dart';
import '../../../res/functions/show_toast.dart';
import 'test_screens/test.dart';

final GlobalKey<ScaffoldState> scaffKey = GlobalKey<ScaffoldState>();
int? _currentSubjectId;
bool _isPagingEnd = false;

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({Key? key}) : super(key: key);
  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  Future<void> _startPagination() async {
    await context
        .read<TestCubit>()
        .getTestBySubIdWithPagination(_currentSubjectId!);
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
    final screenWidth = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<TestCubit>().onRefresh(_currentSubjectId!);
      },
      child: Scaffold(
        backgroundColor: AppColors.mainColor,
        key: scaffKey,
        drawer: CustomDrawer(mainWidth: screenWidth),
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
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                "Mashg'ulot uchun testlar",
                                style: AppStyles.introButtonText.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            BlocBuilder<TestCubit, TestState>(
                              builder: (context, state) {
                                if (state is OnTestProgress) {
                                  return const Expanded(
                                    child: Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    ),
                                  );
                                }
                                if (state is OnTestSuccess) {
                                  final subjectData = state.subjectData;
                                  final testList = state.testList;
                                  _isPagingEnd = state.isTestEnded;

                                  return _testBody(subjectData, testList);
                                }
                                return const Expanded(
                                  child: Center(
                                    child: Text("Iltimos kuting..."),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
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

  Widget _testBody(Subjects subjectData, List<Tests> testList) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Text(
              subjectData.name!,
              style: AppStyles.introButtonText.copyWith(
                color: Colors.black,
              ),
            ),
          ),
          Gap(10.h),
          (testList.isEmpty)
              ? const Expanded(
                  child: Center(
                    child: Text("Testlar topilmadi"),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
                    itemCount: testList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < testList.length) {
                        return subjectItem(
                            testList[index], context, (index + 1));
                      } else {
                        return _isPagingEnd
                            ? const Center(
                                child: Text("Boshqa test mavjud emas"))
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: ElevatedButton(
                                  style: AppStyles.introUpButton,
                                  onPressed: () async {
                                    await context
                                        .read<TestCubit>()
                                        .startTestPagination(
                                            _currentSubjectId!);
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
                                        style:
                                            AppStyles.introButtonText.copyWith(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget subjectItem(Tests tests, BuildContext context, int testIndex) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
      width: 333.w,
      height: 90.h,
      padding: EdgeInsets.only(right: 12.w, top: 13.h, left: 9.w),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 6.h, horizontal: 11.w),
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
                      Gap(20.w),
                      (tests.books!.isNotEmpty)
                          ? InkWell(
                              onTap: () {
                                Navigator.push<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        BookScreen(
                                      bookList: tests.books!,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 11.w),
                                height: 32.h,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(120.r),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      AppIcons.book,
                                    ),
                                    Gap(9.w),
                                    Text(
                                      "qo’llanmalar",
                                      style:
                                          AppStyles.subtitleTextStyle.copyWith(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
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
                            questionCount: tests.questionsCount!,
                          ),
                        ),
                      );
                      context.read<InnerTestCubit>().getTestById(tests.id!);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 11.h, horizontal: 16.w),
                      height: 32.h,
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
              ),
              Gap(10.h),
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                animation: true,
                lineHeight: 5.0,
                animationDuration: 2000,
                percent: (tests.percent! / 100).toDouble(),
                barRadius: Radius.circular(16.r),
                progressColor: AppColors.mainColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
