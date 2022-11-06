import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/models/test_model.dart';
import 'package:test_app/ui/components/custom_dot.dart';

import '../components/custom_simple_appbar.dart';
import '../navigation/main_navigation.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var _questionNumber = 1;
  int? _selectedIndex;
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
                titleText: "Tarix fani: To’plam #11",
                routeText: RouteNames.profile,
                style: AppStyles.subtitleTextStyle.copyWith(
                  fontSize: 24.sp,
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
                child: Column(
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
                        SubjectList.tests[0].question,
                        style: AppStyles.subtitleTextStyle.copyWith(
                          fontSize: 24.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Gap(57.h),
                    Column(
                      children: [
                        for (var i = 0;
                            i < SubjectList.tests[0].options.length;
                            i++)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_selectedIndex == i) {
                                  _selectedIndex = null;
                                } else {
                                  _selectedIndex = i;
                                }

                                print(i);
                              });
                            },
                            child: testItem(SubjectList.tests[0].options[i],
                                (i == _selectedIndex)),
                          ),
                      ],
                    ),
                    Gap(168.h),
                    Container(
                      height: 56.h,
                      width: 343.w,
                      margin: EdgeInsets.only(
                        bottom: 10.h,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.r),
                          color: AppColors.mainColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Builder(builder: (context) {
                            if (_questionNumber > 1) {
                              return InkWell(
                                onTap: () {
                                  if (_questionNumber > 1) {
                                    setState(() {
                                      _questionNumber = _questionNumber - 1;
                                    });
                                  }
                                },
                                child: Image.asset(
                                  AppIcons.arrowBack,
                                  scale: 2.5,
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                          Text(
                            "Keyingi savol",
                            style: AppStyles.introButtonText
                                .copyWith(color: Colors.white),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _questionNumber = _questionNumber + 1;
                              });
                            },
                            child: Image.asset(
                              AppIcons.arrowForward,
                              scale: 2.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget testItem(TestOptionModel model, bool isPressed) {
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
                    model.optionText,
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

  Container ordinary(TestOptionModel model) {
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
        model.optionText,
        style: AppStyles.subtitleTextStyle.copyWith(
          color: Colors.black,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
