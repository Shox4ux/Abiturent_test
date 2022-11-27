import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/block/payment_cubit/payment_cubit.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/navigation/main_navigation.dart';

import '../../../../../res/components/custom_card.dart';
import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/functions/number_formatter.dart';

class PaymeInfoConfirmation extends StatefulWidget {
  const PaymeInfoConfirmation({super.key});

  @override
  State<PaymeInfoConfirmation> createState() => _PaymeInfoConfirmationState();
}

class _PaymeInfoConfirmationState extends State<PaymeInfoConfirmation> {
  var _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            if (state is OnMadePayment) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSimpleAppBar(
                    isSimple: true,
                    titleText: "Hisobni to’ldirish",
                    style: AppStyles.introButtonText.copyWith(
                      fontSize: 22.sp,
                      color: Colors.white,
                    ),
                    iconColor: Colors.white,
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
                        Text(
                          "${numberFormatter(int.parse(state.paymentResponse.amount!))} UZS",
                          style: AppStyles.introButtonText.copyWith(
                            color: AppColors.fillingColor,
                            fontSize: 34.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(10.h),
                  Expanded(
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.r),
                          topLeft: Radius.circular(16.r),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10.h),
                                child: CustomCard(
                                  cardNumber: state.paymentResponse.cardPan!,
                                  cardPeriod: state.paymentResponse.cardMonth!,
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isChecked = !_isChecked;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                microseconds: 200),
                                            height: 40.h,
                                            width: 40.w,
                                            decoration: BoxDecoration(
                                              color: _isChecked
                                                  ? AppColors.mainColor
                                                  : AppColors.gray,
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                            ),
                                            child: _isChecked
                                                ? Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 24.h,
                                                  )
                                                : null,
                                          ),
                                        ),
                                        Gap(5.w),
                                        Expanded(
                                          child: Text(
                                            "I confirm my consent to the processing of the payment transaction through",
                                            style: AppStyles.subtitleTextStyle
                                                .copyWith(
                                                    fontSize: 12.sp,
                                                    color: Colors.black),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Gap(10.h),
                                  Image.asset(
                                    AppIcons.big,
                                    scale: 3,
                                  )
                                ],
                              )
                            ],
                          ),
                          _isChecked
                              ? Padding(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  child: ElevatedButton(
                                    style: AppStyles.introUpButton,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, RouteNames.paymeSmsCinfirm);
                                    },
                                    child: Text(
                                      "To’lov amalga oshirish",
                                      style: AppStyles.introButtonText.copyWith(
                                          color: const Color(0xffFCFCFC)),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  child: ElevatedButton(
                                    style: AppStyles.disabledButton,
                                    onPressed: null,
                                    child: Text(
                                      "To’lov amalga oshirish",
                                      style: AppStyles.introButtonText.copyWith(
                                          color: const Color(0xffFCFCFC)),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
