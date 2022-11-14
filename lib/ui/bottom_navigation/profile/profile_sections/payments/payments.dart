import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/enum.dart';

import '../../../../../res/constants.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tarix fani",
          style: AppStyles.introButtonText.copyWith(
            color: Colors.black,
          ),
        ),
        Gap(10.h),
        Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return budgetItem();
              }),
        ),
      ],
    );
  }

  Widget budgetItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.all(8.h),
      height: 55.h,
      width: 331.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 24.h,
            width: 24.w,
            child: Image.asset(Subscriptions.green.iconPath),
          ),
          Gap(11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "11.01.2022",
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 10.sp,
                            color: const Color(0xff161719)),
                      ),
                      // Gap(80.w),
                      Text(
                        "+2 200 000 UZS",
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 14.sp,
                          color: const Color(0xff161719),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(4.h),
                Text(
                  Subscriptions.green.text,
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 14.sp,
                    color: const Color(0xff161719),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
