import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/constants.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../../res/navigation/main_navigation.dart';

class PaymeScreen extends StatefulWidget {
  const PaymeScreen({
    super.key,
    required this.cardName,
    required this.cardNumber,
    required this.period,
  });
  final String cardName;
  final String cardNumber;
  final String period;
  @override
  State<PaymeScreen> createState() => _PaymeScreenState();
}

class _PaymeScreenState extends State<PaymeScreen> {
  final textFormat = MaskTextInputFormatter(mask: '### ### ### ### ###');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.sp),
                                image: DecorationImage(
                                    image: AssetImage(
                                  AppIcons.card,
                                ))),
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Gap(60.h),
                                Text(
                                  widget.cardName,
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 25.sp),
                                ),
                                Gap(60.h),
                                Text(
                                  widget.cardNumber,
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 25.sp),
                                ),
                                Gap(10.h),
                                Container(
                                  margin: EdgeInsets.only(right: 70.w),
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    widget.period,
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 25.sp),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
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
                )),
          ),
        ],
      ),
    );
  }
}
