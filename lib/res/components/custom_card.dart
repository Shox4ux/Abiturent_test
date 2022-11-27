import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/number_formatter.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    required this.cardNumber,
    required this.cardPeriod,
    super.key,
  });
  final String cardNumber;
  final String cardPeriod;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Image.asset(AppIcons.card),
        ),
        Positioned(
            top: 110,
            left: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  cardPanFormatter(int.parse(cardNumber)),
                  style: AppStyles.introButtonText.copyWith(fontSize: 22.sp),
                ),
                Text(
                  cardPeriod,
                  style: AppStyles.introButtonText.copyWith(fontSize: 16.sp),
                )
              ],
            ))
      ],
    );
  }
}
