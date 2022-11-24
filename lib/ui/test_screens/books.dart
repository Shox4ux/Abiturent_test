import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/components/custom_simple_appbar.dart';
import 'package:test_app/res/constants.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSimpleAppBar(
                isSimple: true,
                titleText: "Test bo’yicha adabiyotlar",
                iconColor: Colors.white,
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: 4,
                        itemBuilder: (context, index) => bookItem(),
                      ),
                    ),
                    ElevatedButton(
                      style: AppStyles.introUpButton,
                      onPressed: () {},
                      child: Text(
                        "Testlarga o'tish",
                        style: AppStyles.introButtonText
                            .copyWith(color: const Color(0xffFCFCFC)),
                      ),
                    ),
                    Gap(24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bookItem() {
    return Container(
      alignment: Alignment.center,
      height: 70.h,
      width: double.maxFinite,
      child: Row(
        children: [
          Image.asset(
            AppIcons.bd,
            scale: 3.5,
          ),
          Gap(9.w),
          Text(
            '''Kulolchilik charxida ishlangan sopol 
idishlar to’plami kitobi''',
            style: AppStyles.subtitleTextStyle.copyWith(
              color: Colors.black,
              fontSize: 13.sp,
            ),
          )
        ],
      ),
    );
  }
}
