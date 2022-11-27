import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:test_app/res/components/custom_card.dart';
import 'package:test_app/res/functions/number_formatter.dart';
import 'package:test_app/res/functions/show_toast.dart';
import '../../../../../core/block/payment_cubit/payment_cubit.dart';
import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/constants.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../../res/navigation/main_navigation.dart';

class PaymeScreen extends StatefulWidget {
  const PaymeScreen({super.key});

  @override
  State<PaymeScreen> createState() => _PaymeScreenState();
}

class _PaymeScreenState extends State<PaymeScreen> {
  var _amount = "";
  var _cardPeriod = "";
  var _cardPan = "";
  var _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      body: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          if (state is OnCardProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          return BlocListener<PaymentCubit, PaymentState>(
            listener: (context, state) {
              if (state is OnCardError) {
                showToast(state.error);
              }
              if (state is OnMadePayment) {
                Navigator.pushNamed(
                  context,
                  RouteNames.paymeInfoConfirm,
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(40.h),
                CustomSimpleAppBar(
                  isSimple: false,
                  titleText: "Hisobni to’ldirish",
                  routeText: RouteNames.main,
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
                      TextField(
                        keyboardType: TextInputType.number,
                        onSubmitted: (value) {
                          setState(() {
                            _amount = value;
                          });
                        },
                        inputFormatters: [
                          ThousandsFormatter(),
                        ],
                        decoration: InputDecoration(
                          hintText: "0,00 UZS",
                          hintStyle: AppStyles.introButtonText.copyWith(
                            color: AppColors.fillingColor.withOpacity(0.6),
                            fontSize: 36.sp,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.sp),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.sp),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                        style: AppStyles.introButtonText.copyWith(
                          color: AppColors.fillingColor,
                          fontSize: 36.sp,
                        ),
                      )
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
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              children: [
                                TextField(
                                  onSubmitted: (value) {
                                    setState(() {
                                      _cardPan = value;
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                        mask: '#### #### #### ####')
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "1234 1234 1234 1234",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.h),
                                      borderSide: BorderSide(width: 2.w),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.h),
                                      borderSide: BorderSide(
                                          color: AppColors.mainColor,
                                          width: 2.w),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.h),
                                      borderSide: BorderSide(
                                          color: AppColors.textFieldBorderColor,
                                          width: 2.w),
                                    ),
                                  ),
                                ),
                                Gap(16.h),
                                TextField(
                                  onSubmitted: (value) {
                                    setState(() {
                                      _cardPeriod = value;
                                    });
                                  },
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    MaskTextInputFormatter(mask: '##/##')
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "MM/YY",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.h),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.h),
                                      borderSide: BorderSide(
                                          color: AppColors.mainColor,
                                          width: 2.w),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.h),
                                      borderSide: BorderSide(
                                          color: AppColors.textFieldBorderColor,
                                          width: 2.w),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 24.h),
                            child: ElevatedButton(
                              style: AppStyles.introUpButton,
                              onPressed: () {
                                context.read<PaymentCubit>().makePayment(
                                      _cardPeriod,
                                      _cardPan.replaceAll(" ", ""),
                                      _amount.replaceAll(",", ""),
                                    );
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.paymeInfoConfirm,
                                );
                              },
                              child: Text(
                                "Karta qo'shish",
                                style: AppStyles.introButtonText
                                    .copyWith(color: const Color(0xffFCFCFC)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget enterPaymentInfo(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is OnMadePayment) {
          Navigator.pushNamed(
            context,
            RouteNames.paymeInfoConfirm,
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(40.h),
          CustomSimpleAppBar(
            isSimple: false,
            titleText: "Hisobni to’ldirish",
            routeText: RouteNames.main,
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
                TextField(
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    setState(() {
                      _amount = value;
                    });
                  },
                  inputFormatters: [
                    ThousandsFormatter(),
                  ],
                  decoration: InputDecoration(
                    hintText: "0,00 UZS",
                    hintStyle: AppStyles.introButtonText.copyWith(
                      color: AppColors.fillingColor.withOpacity(0.6),
                      fontSize: 36.sp,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.sp),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.sp),
                    ),
                  ),
                  style: AppStyles.introButtonText.copyWith(
                    color: AppColors.fillingColor,
                    fontSize: 36.sp,
                  ),
                )
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
              child: Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          TextField(
                            onSubmitted: (value) {
                              setState(() {
                                _cardPan = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              MaskTextInputFormatter(
                                  mask: '#### #### #### ####')
                            ],
                            decoration: InputDecoration(
                              hintText: "1234 1234 1234 1234",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.h),
                                borderSide: BorderSide(width: 2.w),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.h),
                                borderSide: BorderSide(
                                    color: AppColors.mainColor, width: 2.w),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.h),
                                borderSide: BorderSide(
                                    color: AppColors.textFieldBorderColor,
                                    width: 2.w),
                              ),
                            ),
                          ),
                          Gap(16.h),
                          TextField(
                            onSubmitted: (value) {
                              setState(() {
                                _cardPeriod = value;
                              });
                            },
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              MaskTextInputFormatter(mask: '##/##')
                            ],
                            decoration: InputDecoration(
                              hintText: "MM/YY",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.h),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.h),
                                borderSide: BorderSide(
                                    color: AppColors.mainColor, width: 2.w),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.h),
                                borderSide: BorderSide(
                                    color: AppColors.textFieldBorderColor,
                                    width: 2.w),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: ElevatedButton(
                        style: AppStyles.introUpButton,
                        onPressed: () {
                          context.read<PaymentCubit>().makePayment(
                                _cardPeriod,
                                _cardPan.replaceAll(" ", ""),
                                _amount.replaceAll(",", ""),
                              );
                        },
                        child: Text(
                          "Karta qo'shish",
                          style: AppStyles.introButtonText
                              .copyWith(color: const Color(0xffFCFCFC)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paymeSmsConfirm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(40.h),
        CustomSimpleAppBar(
          isSimple: false,
          titleText: "Hisobni to’ldirish",
          routeText: RouteNames.main,
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
                "${numberFormatter(10000)} UZS",
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
                        cardNumber: _cardPan,
                        cardPeriod: _cardPeriod,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: TextField(
                        onSubmitted: (value) {
                          setState(() {
                            _cardPeriod = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "SMS-kodni kiriting",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                            borderSide: BorderSide(
                                color: AppColors.mainColor, width: 2.w),
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
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: ElevatedButton(
                    style: AppStyles.introUpButton,
                    onPressed: () {},
                    child: Text(
                      "Tasdiqlash",
                      style: AppStyles.introButtonText
                          .copyWith(color: const Color(0xffFCFCFC)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget confirmGivenInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(40.h),
        CustomSimpleAppBar(
          isSimple: false,
          titleText: "Hisobni to’ldirish",
          routeText: RouteNames.main,
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
                "${numberFormatter(10000)} UZS",
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
                        cardNumber: _cardPan,
                        cardPeriod: _cardPeriod,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isChecked = !_isChecked;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(microseconds: 200),
                                  height: 40.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color: _isChecked
                                        ? AppColors.mainColor
                                        : AppColors.gray,
                                    borderRadius: BorderRadius.circular(16.r),
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
                                  style: AppStyles.subtitleTextStyle.copyWith(
                                      fontSize: 12.sp, color: Colors.black),
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
                          onPressed: () {},
                          child: Text(
                            "To’lov amalga oshirish",
                            style: AppStyles.introButtonText
                                .copyWith(color: const Color(0xffFCFCFC)),
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
                            style: AppStyles.introButtonText
                                .copyWith(color: const Color(0xffFCFCFC)),
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
}
