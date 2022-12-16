import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/block/test_block/test_cubit.dart';
import 'package:test_app/core/domain/test_model/test_model.dart';
import 'package:test_app/core/helper/repos/test_repo.dart';
import 'package:test_app/res/components/custom_dot.dart';
import 'package:test_app/res/components/custom_drawer.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:test_app/ui/test_screens/books.dart';
import '../../../core/block/drawer_cubit/drawer_cubit.dart';
import '../../../res/constants.dart';
import '../../../res/components/custom_appbar.dart';
import '../../test_screens/test.dart';

TestModel? testModel;
DateTime? currentBackPressTime;
final repo = TestRepo();
final GlobalKey<ScaffoldState> scaffKey = GlobalKey<ScaffoldState>();
var currentPage = 1;
const perPage = 10;
final _scrollController = ScrollController();
final _repo = TestRepo();
var currentSubId = 1;

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({
    Key? key,
    required this.testType,
  }) : super(key: key);
  final int testType;

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _scroollListener();
    });
  }

  Future<TestModel?> _getTestsBySubIdWithPagination(int subId) async {
    try {
      final response =
          await _repo.getTestPaginationByType(subId, 1, currentPage, perPage);
      testModel = TestModel.fromJson(response.data);
      return testModel;
    } catch (e) {
      return testModel = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      key: scaffKey,
      drawer: CustomDrawer(mainWidth: screenWidth),
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
                      Gap(10.h),
                      BlocBuilder<DrawerCubit, DrawerState>(
                        builder: (context, state) {
                          if (state is DrawerSubId) {
                            currentSubId = state.subId;
                            print(currentSubId);
                            return FutureBuilder(
                              future:
                                  _getTestsBySubIdWithPagination(state.subId),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: Text("Iltimos kuting..."),
                                  );
                                }
                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Text(
                                        testModel!.subjects!.name!,
                                        style:
                                            AppStyles.introButtonText.copyWith(
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
                                            child: ListView.builder(
                                              controller: _scrollController,
                                              padding: EdgeInsets.only(
                                                bottom: 20.h,
                                                top: 10.h,
                                              ),
                                              itemCount:
                                                  testModel!.tests!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return subjectItem(
                                                  testModel!.tests![index],
                                                  testModel!.books!,
                                                  context,
                                                  (index + 1),
                                                );
                                              },
                                            ),
                                          ),
                                  ],
                                );
                              },
                            );
                          }
                          return FutureBuilder(
                            future: _getTestsBySubIdWithPagination(1),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: Text("Iltimos kuting..."),
                                );
                              }
                              return Column(
                                children: [
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
                                            child: Text("Testlar topilmadi"),
                                          ),
                                        )
                                      : Expanded(
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            padding: EdgeInsets.only(
                                              bottom: 20.h,
                                              top: 10.h,
                                            ),
                                            itemCount: testModel!.tests!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return subjectItem(
                                                testModel!.tests![index],
                                                testModel!.books!,
                                                context,
                                                (index + 1),
                                              );
                                            },
                                          ),
                                        ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
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

  Widget subjectItem(
      Tests tests, List<Books> books, BuildContext context, int testIndex) {
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
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 6.h, horizontal: 11.w),
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

                // for (var i = 0; i < testModel!.books!.length; i++)
                (testModel!.books!.isNotEmpty)
                    ? InkWell(
                        onTap: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => BookScreen(
                                bookList: books,
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
                                style: AppStyles.subtitleTextStyle.copyWith(
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

                context.read<TestCubit>().getTestById(tests.id!);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 16.w),
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
        )
      ]),
    );
  }

  void _scroollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      currentPage = currentPage + 1;
      _getTestsBySubIdWithPagination(currentSubId);
    } else {
      print("object scroll");
    }
  }
}
