import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/ui/components/custom_simple_appbar.dart';

import '../../../../../res/constants.dart';
import '../../../../navigation/main_navigation.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PaymeScreen extends StatelessWidget {
  PaymeScreen({Key? key}) : super(key: key);
  final textFormat = MaskTextInputFormatter(mask: '### ### ### ### ###');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(40.h),
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,
            ),
            child: CustomSimpleAppBar(
              isSimple: true,
              titleText: "Hisobni to’ldirish",
              routeText: "profile",
              style: AppStyles.introButtonText.copyWith(
                fontSize: 24.sp,
                color: Colors.white,
              ),
              iconColor: Colors.white,
            ),
          ),
          Gap(64.w),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To’lov summasi",
                  style: AppStyles.introButtonText.copyWith(
                    color: AppColors.fillingColor.withOpacity(0.6),
                  ),
                ),
                Gap(11.h),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [textFormat],
                  decoration: InputDecoration(
                      hintText: "0.0 UZS",
                      hintStyle: AppStyles.introButtonText.copyWith(
                        color: AppColors.fillingColor.withOpacity(0.6),
                        fontSize: 36.sp,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.sp))),
                  style: AppStyles.introButtonText.copyWith(
                    color: AppColors.fillingColor,
                    fontSize: 36.sp,
                  ),
                )
                // Text(
                //   "100 000 UZS",
                //   style: AppStyles.introButtonText.copyWith(
                //     color: AppColors.fillingColor,
                //     fontSize: 36.sp,
                //   ),
                // ),
              ],
            ),
          ),
          Gap(22.h),
          Expanded(
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25.r),
                  topLeft: Radius.circular(25.r),
                ),
              ),
              child: card2Part(context),
            ),
          ),
        ],
      ),
    );
  }
}

Widget fillInfo(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
      top: 12.h,
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Telefon raqami",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.h),
                borderSide: BorderSide(color: Colors.red, width: 2.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.h),
                borderSide: BorderSide(
                    color: AppColors.textFieldBorderColor, width: 2.w),
              ),
            ),
          ),
        ),
        Gap(24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Telefon raqami",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.h),
                borderSide: BorderSide(color: Colors.red, width: 2.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.h),
                borderSide: BorderSide(
                    color: AppColors.textFieldBorderColor, width: 2.w),
              ),
            ),
          ),
        ),
        Gap(230.h),
        ElevatedButton(
          style: AppStyles.introUpButton,
          onPressed: () {
            Navigator.pushNamed(
              context,
              RouteNames.smsVerification,
              arguments: "+998912222222",
            );
          },
          child: Text(
            "Karda qo’shish",
            style: AppStyles.introButtonText
                .copyWith(color: const Color(0xffFCFCFC)),
          ),
        ),
        Gap(16.h)
      ],
    ),
  );
}

Widget cardPart(BuildContext context) {
  return Column(
    children: [
      Gap(20.h),
      Expanded(
        child: ListView.builder(
          reverse: false,
          itemCount: 15,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return cardItem();
          },
        ),
      ),
      Gap(230.h),
      ElevatedButton(
        style: AppStyles.introUpButton,
        onPressed: () {
          Navigator.pushNamed(
            context,
            RouteNames.smsVerification,
            arguments: "+998912222222",
          );
        },
        child: Text(
          "To’lov amalga oshirish",
          style: AppStyles.introButtonText
              .copyWith(color: const Color(0xffFCFCFC)),
        ),
      ),
      Gap(16.h)
    ],
  );
}

Widget card2Part(BuildContext context) {
  return Column(
    children: [
      Gap(20.h),
      Expanded(
        child: ListView.builder(
          reverse: false,
          itemCount: 15,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return cardItem();
          },
        ),
      ),
      Gap(53.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: TextField(
          keyboardType: TextInputType.phone,
          inputFormatters: [MaskTextInputFormatter(mask: '+### ### ## ##')],
          decoration: InputDecoration(
            hintText: "Telefon raqami",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.h),
              borderSide: BorderSide(color: Colors.red, width: 2.w),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.h),
              borderSide:
                  BorderSide(color: AppColors.textFieldBorderColor, width: 2.w),
            ),
          ),
        ),
      ),
      Gap(114.h),
      ElevatedButton(
        style: AppStyles.introUpButton,
        onPressed: () {
          Navigator.pushNamed(
            context,
            RouteNames.smsVerification,
            arguments: "+998912222222",
          );
        },
        child: Text(
          "To’lov amalga oshirish",
          style: AppStyles.introButtonText
              .copyWith(color: const Color(0xffFCFCFC)),
        ),
      ),
      Gap(16.h)
    ],
  );
}

Widget cardItem() {
  return Container(
    margin: EdgeInsets.only(left: 24.w),
    height: 200.h,
    width: 330.w,
    child: Image.asset(
      AppIcons.card,
      fit: BoxFit.cover,
    ),
  );
}
