import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/components/custom_simple_appbar.dart';
import 'package:test_app/res/constants.dart';

class RefactorScreen extends StatefulWidget {
  const RefactorScreen({super.key});

  @override
  State<RefactorScreen> createState() => _RefactorScreenState();
}

class _RefactorScreenState extends State<RefactorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomSimpleAppBar(
                titleText: "Tahrirlash",
                style: AppStyles.smsVerBigTextStyle.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
                iconColor: Colors.white,
                isSimple: true),
            Gap(10.h),
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
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 80.w,
                          foregroundImage: const AssetImage(
                            AppIcons.man,
                          ),
                        ),
                        Positioned(
                          top: 110.h,
                          right: 0.w,
                          child: Container(
                            height: 45.h,
                            width: 45.w,
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(120.r),
                            ),
                            child: Image.asset(
                              AppIcons.replace,
                              scale: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(100.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        maxLength: 9,
                        onChanged: (value) {},
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Abiturent FIO",
                          counter: const SizedBox.shrink(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                            borderSide: BorderSide(
                                color: AppColors.textFieldBorderColor,
                                width: 2.w),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        maxLength: 9,
                        onChanged: (value) {},
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Telefon raqami",
                          prefixText: "+998 ",
                          counter: const SizedBox.shrink(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                            borderSide: BorderSide(
                                color: AppColors.textFieldBorderColor,
                                width: 2.w),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        maxLength: 9,
                        onChanged: (value) {},
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Telefon raqami",
                          prefixText: "+998 ",
                          counter: const SizedBox.shrink(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                            borderSide: BorderSide(
                                color: AppColors.textFieldBorderColor,
                                width: 2.w),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
