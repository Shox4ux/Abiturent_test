import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/p_h_model/payment_history_model.dart';
import 'package:test_app/res/enum.dart';
import 'package:test_app/res/functions/number_formatter.dart';

class PaymentHistoryWidget extends StatelessWidget {
  const PaymentHistoryWidget(
      {super.key, required this.item, required this.type});
  final PaymentHistory item;
  final Subscriptions type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      padding: EdgeInsets.all(10.h),
      margin: EdgeInsets.only(bottom: 5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 5.0, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: Image.asset(type.iconPath),
                  ),
                  Gap(10.w),
                  Text(
                    item.createdDate!,
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 10.sp,
                        color: const Color(0xff161719)),
                  ),
                ],
              ),
              Text(
                "${type.indicator}${numberFormatter(item.amount)} UZS",
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14.sp,
                  color: const Color(0xff161719),
                ),
              ),
            ],
          ),
          Gap(4.h),
          Expanded(
            child: Text(
              item.content!,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14.sp,
                color: const Color(0xff161719),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
