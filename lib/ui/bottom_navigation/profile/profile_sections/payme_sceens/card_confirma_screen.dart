import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/patment_model/card_model.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import 'package:url_launcher/link.dart';
import '../../../../../core/bloc/payment_cubit/payment_cubit.dart';
import '../../../../../res/components/custom_card.dart';
import '../../../../../res/components/custom_simple_appbar.dart';

class CardConfirmationSceen extends StatefulWidget {
  const CardConfirmationSceen({super.key});

  @override
  State<CardConfirmationSceen> createState() => _CardConfirmationSceenState();
}

class _CardConfirmationSceenState extends State<CardConfirmationSceen>
    with TickerProviderStateMixin {
  var _isChecked = false;
  var _isReadyToSms = false;
  var _isTime = false;
  final _smsCodeController = TextEditingController();

  void _checkTime(String time) {
    if (time == "00:00") {
      setState(() {
        _isTime = true;
        stopTimer();
      });
    } else {
      setState(() {
        _isTime = false;
      });
    }
  }

  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 1);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    countdownTimer!.cancel();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    if (countdownTimer != null) {
      setState(() {
        countdownTimer!.cancel();
      });
    }
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    setState(() => myDuration = const Duration(minutes: 1));
  }

  // Step 6
  void setCountDown() {
    setState(() {
      const reduceSecondsBy = 1;
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    _checkTime("$minutes:$seconds");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: BlocListener<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is OnCardDeleted) {
              showToast(state.message);
              Navigator.pop(context);
            }
            if (state is OnCardConfirmed) {
              Navigator.pushNamed(context, RouteNames.makePayment);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSimpleAppBar(
                isIcon: false,
                isSimple: false,
                titleText: "Hisobni to’ldirish",
                style: AppStyles.introButtonText.copyWith(
                  fontSize: 22.sp,
                  color: Colors.white,
                ),
                iconColor: Colors.white,
              ),
              Gap(54.w),
              Padding(
                padding: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "To’lov summasi",
                      style: AppStyles.introButtonText.copyWith(
                          color: AppColors.fillingColor.withOpacity(0.6),
                          fontSize: 16.sp),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "0 ",
                            style: AppStyles.introButtonText.copyWith(
                                color: AppColors.fillingColor, fontSize: 48.sp),
                          ),
                          TextSpan(
                            text: "UZS",
                            style: AppStyles.introButtonText.copyWith(
                                color: AppColors.fillingColor, fontSize: 42.sp),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.r),
                      topLeft: Radius.circular(16.r),
                    ),
                  ),
                  child: BlocBuilder<PaymentCubit, PaymentState>(
                    builder: (context, state) {
                      if (state is OnCardAdded) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.h),
                                  child: CustomCard(
                                    state.model.card!,
                                  ),
                                ),
                                _decider(state.model, minutes, seconds),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 24.h),
                              child: (_isChecked)
                                  ? ElevatedButton(
                                      style: AppStyles.introUpButton,
                                      onPressed: () {
                                        if (_isReadyToSms == false) {
                                          setState(() {
                                            _isReadyToSms = true;
                                          });
                                        } else {
                                          context
                                              .read<PaymentCubit>()
                                              .verifyCardSmsCode(
                                                  state.model.card!.id!,
                                                  _smsCodeController.text);
                                        }
                                      },
                                      child: Text(
                                        "Tasdiqlash",
                                        style: AppStyles.introButtonText
                                            .copyWith(
                                                color: const Color(0xffFCFCFC)),
                                      ),
                                    )
                                  : ElevatedButton(
                                      style: AppStyles.disabledButton,
                                      onPressed: null,
                                      child: Text(
                                        "Tasdiqlash",
                                        style: AppStyles.introButtonText
                                            .copyWith(
                                                color: const Color(0xffFCFCFC)),
                                      ),
                                    ),
                            )
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _decider(CardModel model, String minutes, String seconds) {
    return _isReadyToSms ? onCardSms(model, minutes, seconds) : notConfirmed();
  }

  Widget onCardSms(CardModel model, String minutes, String seconds) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$minutes:$seconds",
            style: AppStyles.introButtonText.copyWith(
              color: AppColors.mainColor,
            ),
          ),
          Gap(10.h),
          Text(
            "Biz ${model.phone!.phone} telefon raqamiga sms-kod xabarnomasini jo’natdik.",
            style: AppStyles.subtitleTextStyle.copyWith(
              color: Colors.black,
            ),
          ),
          Gap(6.h),
          _isTime
              ? InkWell(
                  onTap: () {
                    setState(
                      () => myDuration = const Duration(minutes: 3),
                    );
                    startTimer();
                    context
                        .read<PaymentCubit>()
                        .refreshCardSms(model.card!.id!);
                  },
                  child: Text(
                    "Qayta jo'natish",
                    style: AppStyles.subtitleTextStyle.copyWith(
                        color: AppColors.mainColor,
                        decoration: TextDecoration.underline),
                  ),
                )
              : Text(
                  "Qayta jo'natish",
                  style: AppStyles.subtitleTextStyle.copyWith(
                      color: AppColors.subtitleColor,
                      decoration: TextDecoration.underline),
                ),
          Gap(10.h),
          TextField(
            controller: _smsCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "sms-code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.h),
                borderSide: BorderSide(width: 2.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.h),
                borderSide: BorderSide(color: AppColors.mainColor, width: 2.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.h),
                borderSide: BorderSide(
                    color: AppColors.textFieldBorderColor, width: 2.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget notConfirmed() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Link(
              uri: Uri.parse("https://cdn.payme.uz/terms/main.html"),
              builder: ((context, followLink) => InkWell(
                    onTap: followLink,
                    child: Text(
                      "Ommaviy taklif",
                      style: AppStyles.subtitleTextStyle.copyWith(
                        color: AppColors.mainColor,
                        fontSize: 12.sp,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )),
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
                        color:
                            _isChecked ? AppColors.mainColor : AppColors.gray,
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
                  Gap(10.w),
                  Expanded(
                    child: Text(
                      "Payme orqali toʻlov tranzaksiyasini qayta ishlashga roziligimni tasdiqlayman",
                      style: AppStyles.subtitleTextStyle
                          .copyWith(fontSize: 12.sp, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            Gap(40.h),
            const Text("Tomonidan qo'llab quvvatlanadi"),
            Image.asset(
              AppIcons.big,
              scale: 4.5,
            )
          ],
        ),
      ],
    );
  }
}
