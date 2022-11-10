import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/ui/auth/reset_password.dart';

import 'package:test_app/res/components/custom_countdown_timer.dart';
import 'package:test_app/res/components/custom_pinput_widget.dart';

import '../../core/block/auth_block/auth_cubit.dart';
import '../../res/constants.dart';
import '../../res/components/custom_simple_appbar.dart';
import '../../res/navigation/main_navigation.dart';

class SmsVerificationScreen extends StatefulWidget {
  const SmsVerificationScreen({
    Key? key,
    required this.fromWhere,
    required this.phone,
    required this.id,
  }) : super(key: key);
  final String fromWhere;
  final String phone;
  final int id;

  @override
  State<SmsVerificationScreen> createState() => _SmsVerificationScreenState();
}

class _SmsVerificationScreenState extends State<SmsVerificationScreen> {
  String _destinationDecider(String previousPage) {
    if (previousPage == RouteNames.forget) {
      return RouteNames.changePassword;
    }
    return RouteNames.wait;
  }

  var _pinCode = "";
  final _isTime = false;

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

  @override
  Widget build(BuildContext context) {
    _checkFields();
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Good luck man!"),
            ),
          );
          if (widget.fromWhere == RouteNames.forget) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResetPassWord(
                        phone: "998${widget.phone}",
                      )),
            );
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
              RouteNames.wait,
              (Route<dynamic> route) => false,
            );
          }
        }
        if (state is AuthDenied) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
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
                  const CountdownTimer(),
                  Gap(10.h),
                  Text(
                    AppStrings.smsText,
                    style: AppStyles.subtitleTextStyle.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  Gap(6.h),
                  RichText(
                    text: TextSpan(
                      style: AppStyles.subtitleTextStyle,
                      children: [
                        _isTime
                            ? TextSpan(
                                text: "Qayta jo'natish",
                                style: AppStyles.subtitleTextStyle.copyWith(
                                    color: AppColors.subtitleColor,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = null)
                            : TextSpan(
                                text: "Qayta jo'natish",
                                style: AppStyles.subtitleTextStyle.copyWith(
                                    color: AppColors.mainColor,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      launch), // launch function for navigating to other screen
                      ],
                    ),
                  ),
                  Gap(55.h),
                  _isFilled
                      ? BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            if (state is OnProgress) {
                              return const CircularProgressIndicator(
                                color: AppColors.mainColor,
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

  void launch() {
    Navigator.pushNamed(
      context,
      RouteNames.forget,
    );
  }
}
