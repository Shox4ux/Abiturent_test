import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';

class CustomCard extends StatelessWidget {
  CustomCard(
    this.cardName,
    this.cardNumber,
    this.cardPeriod, {
    super.key,
  });
  String? cardName;
  String? cardNumber;
  String? cardPeriod;
  @override
  Widget build(BuildContext context) {
    return cardItem();
  }

  Widget cardItem() {
    return Container(
      height: 230.h,
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.only(left: 20.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 3,
              spreadRadius: 1,
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cardNumber ?? "XXXX XXXX XXXX XXXX",
            style: AppStyles.mainTextStyle
                .copyWith(fontSize: 24.sp, color: Colors.black),
          ),
          Gap(10.h),
          Row(
            children: [
              Text(
                cardPeriod ?? "MM/YY",
                style: AppStyles.mainTextStyle
                    .copyWith(fontSize: 16.sp, color: Colors.black),
              ),
              Gap(20.h),
              Text(
                cardName ?? "Card Name",
                style: AppStyles.mainTextStyle
                    .copyWith(fontSize: 18.sp, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
