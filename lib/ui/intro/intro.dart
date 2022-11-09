import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/models/intro_data.dart';

import '../../res/navigation/main_navigation.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int activeIndex = 0;
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: AppIntroImages.introList.length,
                itemBuilder: (context, index) =>
                    buildSlide(AppIntroImages.introList[index], index),
                onPageChanged: (value) {
                  setState(() {
                    activeIndex = value;
                  });
                },
              ),
            ),
            Gap(20.h),
            dotIndicator(),
            Gap(31.h),
            SizedBox(
              height: 56.h,
              child: ElevatedButton(
                style: AppStyles.introUpButton,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.signup,
                  );
                },
                child: Text(
                  AppStrings.introUpButtonText,
                  style: AppStyles.introButtonText
                      .copyWith(color: const Color(0xffFCFCFC)),
                ),
              ),
            ),
            Gap(16.h),
            ElevatedButton(
              style: AppStyles.introUpButton.copyWith(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.secondaryColor)),
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.signin);
              },
              child: Text(
                "Kirish",
                style: AppStyles.introButtonText
                    .copyWith(color: const Color(0xff7F3DFF)),
              ),
            ),
            Gap((MediaQuery.of(context).padding.bottom == 0) ? 30.h : 0)
          ],
        ),
      ),
    );
  }

  Widget buildSlide(IntroData data, int index) {
    return Container(
      padding: EdgeInsets.all(5.w),
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 324.w,
            child: Image.asset(
              data.imgPath,
              fit: BoxFit.fitHeight,
            ),
          ),
          Gap(20.h),
          Text(
            data.mainTitle,
            style: AppStyles.mainTextStyle.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          Gap(10.h),
          Text(
            data.secondaryTitle,
            style: AppStyles.subtitleTextStyle,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget dotIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: AppIntroImages.introList.length,
      effect: ScrollingDotsEffect(
        spacing: 16.w,
        activeDotScale: 1.8.h,
        activeDotColor: AppColors.mainColor,
        dotColor: AppColors.secondaryColor,
        dotHeight: 10.h,
        dotWidth: 10.w,
      ),
    );
  }
}
