import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:test_app/ui/auth/reset_password.dart';

import 'package:test_app/res/components/custom_countdown_timer.dart';
import 'package:test_app/res/components/custom_pinput_widget.dart';
import 'package:test_app/res/components/waiting.dart';

import '../../core/block/auth_block/auth_cubit.dart';
import '../../res/constants.dart';
import '../../res/components/custom_simple_appbar.dart';
import '../../res/navigation/main_navigation.dart';

class SmsVerificationScreen extends StatefulWidget {
  const SmsVerificationScreen(
      {Key? key,
      required this.fromWhere,
      required this.phone,
      required this.id})
      : super(key: key);
  final String fromWhere;
  final String phone;
  final int id;

  @override
  State<SmsVerificationScreen> createState() => _SmsVerificationScreenState();
}

class _SmsVerificationScreenState extends State<SmsVerificationScreen>
    with TickerProviderStateMixin {
  var _pinCode = "";
  late AnimationController _controller;

  var _isTime = false;
  var _isFilled = false;

  void _checkFields() {
    if (_pinCode.length == 6) {
      setState(() {
        _isFilled = true;
      });
    } else {
      setState(() {
        _isFilled = false;
      });
    }
  }

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
  Duration myDuration = const Duration(minutes: 3);

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    if (countdownTimer != null) {
      setState(() => countdownTimer!.cancel());
    }
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    setState(() => myDuration = const Duration(minutes: 3));
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
    _checkFields();
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    _checkTime("$minutes:$seconds");
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is OnAuthTime) {
          startTimer();
        }
        if (state is AuthGranted) {
          if (widget.fromWhere == RouteNames.forget) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResetPassWord(
                        phone: "998${widget.phone}",
                      )),
            );
          } else {
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => const WaitingScreen(
                        status: WarningValues.smsDone,
                        alertText: "",
                        buttonText: "",
                        extraText: "",
                      )),
              (Route<dynamic> route) => false,
            );
          }
        }
        if (state is AuthDenied) {
          showToast(state.error);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSimpleAppBar(
                    isIcon: false,
                    isSimple: true,
                    titleText: "Abiturentni tasniqlash",
                    routeText: "routeText",
                    style: AppStyles.introButtonText.copyWith(
                      color: AppColors.titleColor,
                    ),
                    iconColor: AppColors.smsVerColor,
                  ),
                  Gap(27.h),
                  Text(
                    "Tasdiqlash uchun SMS kodni kiriting",
                    style: AppStyles.smsVerBigTextStyle,
                  ),
                  Gap(12.h),
                  PinPutWidget(
                    lenth: 6,
                    onChanged: (value) {
                      if (value.length == 6) {
                        setState(() {
                          _isFilled = true;
                        });
                      } else {
                        setState(() {
                          _isFilled = false;
                        });
                      }
                      _pinCode = value;
                    },
                  ),
                  Gap(15.h),
                  Text(
                    "$minutes:$seconds",
                    style: AppStyles.introButtonText.copyWith(
                      color: AppColors.mainColor,
                    ),
                  ),
                  Gap(10.h),
                  Text(
                    "Bizning telegon +998${widget.phone.substring(0, 2)} *** ** ${widget.phone.substring(7, 9)} raqamingizga sms-kod xabarnomasini jo’natdik.",
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
                                .read<AuthCubit>()
                                .forgotPassword(widget.phone);
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
                  Gap(55.h),
                  _isFilled
                      ? BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            if (state is OnAuthProgress) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.mainColor,
                                ),
                              );
                            }
                            return ElevatedButton(
                              style: AppStyles.introUpButton,
                              onPressed: () {
                                if (widget.fromWhere == RouteNames.forget) {
                                  context.read<AuthCubit>().checkResetPassword(
                                        widget.id,
                                        widget.phone,
                                        _pinCode,
                                      );
                                } else {
                                  context.read<AuthCubit>().checkSmsCode(
                                        widget.id,
                                        widget.phone,
                                        _pinCode,
                                      );
                                }
                              },
                              child: Text(
                                "Tasdiqlash",
                                style: AppStyles.introButtonText
                                    .copyWith(color: const Color(0xffFCFCFC)),
                              ),
                            );
                          },
                        )
                      : ElevatedButton(
                          style: AppStyles.disabledButton,
                          onPressed: null,
                          child: Text(
                            "Tasdiqlash",
                            style: AppStyles.introButtonText
                                .copyWith(color: const Color(0xffFCFCFC)),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
