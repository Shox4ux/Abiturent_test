import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/models/intro_data.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Gap(60.h),
          CarouselSlider.builder(
            options: CarouselOptions(
              height: 500.h,
              // autoPlay: true,
              enableInfiniteScroll: false,
              viewportFraction: 1,
              onPageChanged: ((index, reason) {
                setState(() {
                  activeIndex = index;
                });
              }),
            ),
            itemCount: AppIntroImages.introList.length,
            itemBuilder: (context, index, realIndex) =>
                buildSlide(AppIntroImages.introList[index], index),
          ),
          Gap(20.h),
          _DotIndicator(),
          Gap(40.h),
          ElevatedButton(
              style: AppStyles.introUpButton,
              onPressed: () {},
              child: Text(
                AppStrings.introUpButtonText,
                style: AppStyles.introButtonText
                    .copyWith(color: const Color(0xffFCFCFC)),
              )),
          Gap(16.h),
          ElevatedButton(
              style: AppStyles.introUpButton.copyWith(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.secondaryColor)),
              onPressed: () {},
              child: Text(
                "Kirish",
                style: AppStyles.introButtonText
                    .copyWith(color: const Color(0xff7F3DFF)),
              ))
        ],
      ),
    );
  }

  Widget buildSlide(IntroData data, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(children: [
        SizedBox(
          width: 280.w,
          height: 344.h,
          child: Image.asset(
            data.imgPath,
            fit: BoxFit.fitHeight,
          ),
        ),
        Gap(10.h),
        Text(
          data.mainTitle,
          style: AppStyles.mainTextStyle,
          textAlign: TextAlign.center,
        ),
        Gap(10.h),
        Text(
          data.secondaryTitle,
          style: AppStyles.subtitleTextStyle,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }

  Widget _DotIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: AppIntroImages.introList.length,
      effect: JumpingDotEffect(
        jumpScale: 1,
        activeDotColor: AppColors.mainColor,
        dotColor: AppColors.secondaryColor,
        dotHeight: 16.h,
        dotWidth: 16.w,
      ),
    );
  }
}
