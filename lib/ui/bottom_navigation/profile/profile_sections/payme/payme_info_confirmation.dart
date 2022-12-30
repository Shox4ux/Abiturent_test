import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/payme/payme_sms_confirmation.dart';
import 'package:url_launcher/link.dart';

import '../../../../../core/bloc/payment_cubit/payment_cubit.dart';
import '../../../../../res/components/custom_card.dart';
import '../../../../../res/components/custom_simple_appbar.dart';

class PaymeInfoConfirmation extends StatefulWidget {
  const PaymeInfoConfirmation(
    this.paymentAmount, {
    super.key,
    required this.isConfirmed,
  });

  final bool isConfirmed;
  final String? paymentAmount;

  @override
  State<PaymeInfoConfirmation> createState() => _PaymeInfoConfirmationState();
}

class _PaymeInfoConfirmationState extends State<PaymeInfoConfirmation> {
  @override
  void initState() {
    super.initState();
    if (widget.paymentAmount != null) {
      _amountController.text = widget.paymentAmount!;
      _check(_amountController.text);
    }
  }

  var _isChecked = false;
  var currentIndex;
  final _amountController = TextEditingController();
  var _isNotEmpty = false;

  void _check(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _isNotEmpty = true;
        print(_isNotEmpty);
      });
    } else {
      setState(() {
        _isNotEmpty = false;
        print(_isNotEmpty);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: BlocConsumer<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is OnCardDeleted) {
              showToast(state.message);
              context.read<PaymentCubit>().getCards();
            }
            if (state is OnCardsEmpty) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.payme,
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is OnCardsReceived) {
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSimpleAppBar(
                      isIcon: true,
                      isSimple: true,
                      titleText: "Hisobni to’ldirish",
                      style: AppStyles.introButtonText.copyWith(
                        fontSize: 22.sp,
                        color: Colors.white,
                      ),
                      iconColor: Colors.white,
                    ),
                    Gap(54.w),
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
                            controller: _amountController,
                            onChanged: (value) {
                              _check(value);
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
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16.r),
                            topLeft: Radius.circular(16.r),
                          ),
                        ),
                        child: _decider(state, context),
                      ),
                    ),
                  ],
                ),
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

  Widget _decider(OnCardsReceived state, BuildContext context) {
    if (widget.isConfirmed) {
      return itConfirmed(state, context);
    } else {
      return notConfirmed(state, context);
    }
  }

  Widget itConfirmed(OnCardsReceived state, BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 245.h,
                child: ListView.builder(
                  itemCount: state.models.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    currentIndex = index;
                    return Padding(
                      padding: EdgeInsets.all(10.h),
                      child: CustomCard(state.models[index]),
                    );
                  },
                ),
              ),
              Gap(60.h),
              Column(
                children: [
                  const Text("Powered by"),
                  Image.asset(
                    AppIcons.big,
                    scale: 4,
                  )
                ],
              )
            ],
          ),
          _isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: ElevatedButton(
                    style: AppStyles.introUpButton,
                    onPressed: () {
                      context.read<PaymentCubit>().makePayment(
                          state.models[currentIndex].cardMonth!,
                          state.models[currentIndex].cardPan!,
                          _amountController.text.replaceAll(",", ""));

                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              PaymeSmsConfirmation(state.models[currentIndex]),
                        ),
                      );
                    },
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
    );
  }

  Widget notConfirmed(OnCardsReceived state, BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 245.h,
                child: ListView.builder(
                  itemCount: state.models.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    currentIndex = index;
                    return Padding(
                      padding: EdgeInsets.all(10.h),
                      child: CustomCard(state.models[index]),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 60.w),
                        child: Link(
                          uri:
                              Uri.parse("https://cdn.payme.uz/terms/main.html"),
                          builder: ((context, followLink) => InkWell(
                                onTap: followLink,
                                child: Text(
                                  "Публичная оферта",
                                  style: AppStyles.subtitleTextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )),
                        ),
                      ),
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
                    ],
                  ),
                  Gap(40.h),
                  Column(
                    children: [
                      const Text("Powered by"),
                      Image.asset(
                        AppIcons.big,
                        scale: 4.5,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
          (_isChecked && _isNotEmpty)
              ? Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: ElevatedButton(
                    style: AppStyles.introUpButton,
                    onPressed: () {
                      if (_isChecked) {
                        context.read<PaymentCubit>().cardConfirm(true);
                      }
                      context.read<PaymentCubit>().makePayment(
                          state.models[currentIndex].cardMonth!,
                          state.models[currentIndex].cardPan!,
                          _amountController.text.replaceAll(",", ""));

                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              PaymeSmsConfirmation(state.models[currentIndex]),
                        ),
                      );
                    },
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
    );
  }
}
