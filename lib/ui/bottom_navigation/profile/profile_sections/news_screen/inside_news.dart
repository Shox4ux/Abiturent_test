import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/news_models/main_news_model.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/components/custom_simple_appbar.dart';

class InsideNewsScreen extends StatefulWidget {
  const InsideNewsScreen({
    Key? key,
    required this.model,
  }) : super(key: key);
  final MainNewsModel model;
  @override
  State<InsideNewsScreen> createState() => _InsideNewsScreenState();
}

class _InsideNewsScreenState extends State<InsideNewsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Stack(
          children: [
            SizedBox(
              height: 212.h,
              width: double.maxFinite,
              //Change here after showing
              child: Image.asset(
                AppIcons.news,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 120,
              child: CustomSimpleAppBar(
                isSimple: true,
                titleText: "Yangiliklar",
                routeText: "routeText",
                style: AppStyles.introButtonText.copyWith(
                  color: Colors.white,
                ),
                iconColor: Colors.white,
              ),
            ),
            Positioned(
              top: 180,
              child: Container(
                padding: EdgeInsets.only(
                  left: 11.w,
                  right: 11.w,
                  top: 17.h,
                  bottom: 7.h,
                ),
                height: 93.h,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25.r),
                    topLeft: Radius.circular(25.r),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 49.h,
                          width: 49.w,
                          decoration: BoxDecoration(
                            color: const Color(0xffEEE5FF),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Image.asset(
                            AppIcons.bell,
                            height: 20,
                            width: 20,
                            scale: 3,
                          ),
                        ),
                        Gap(9.w),
                        Expanded(
                          child: Text(
                            widget.model.title ?? "",
                            style: AppStyles.subtitleTextStyle.copyWith(
                              color: AppColors.mainColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.model.createdText ?? "",
                          style: AppStyles.subtitleTextStyle.copyWith(
                            color: AppColors.smsVerColor,
                            fontSize: 10.sp,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: 280,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 13.h,
                    horizontal: 23.w,
                  ),
                  height: 388.h,
                  width: 330.w,
                  child: Expanded(
                    child: Text(
                      widget.model.short ?? "",
                      textAlign: TextAlign.justify,
                      style: AppStyles.introButtonText.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
