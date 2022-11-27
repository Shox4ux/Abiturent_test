import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:test_app/ui/auth/sms_verification.dart';

import '../../core/block/auth_block/auth_cubit.dart';
import '../../res/components/custom_simple_appbar.dart';
import '../../res/navigation/main_navigation.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // final _textFormat = MaskTextInputFormatter(mask: '## ### ## ##');
  final formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool _isObscure = false;
  bool _isAllFilled = false;
  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (_password.length > 5) {
      setState(() {
        pass_strength = 0;
      });
      return false;
    } else if (_password.length >= 1 && _password.length < 6) {
      setState(() {
        pass_strength = 1 / 2;
      });
      return false;
    } else if (_password.length >= 6) {
      setState(() {
        pass_strength = 1;
      });
      return true;
    } else {
      return false;
    }
  }

  var _fulnameC = "";
  var _phoneC = "";
  var _passwordC = "";
  final TextEditingController _controller = TextEditingController();
  final TextStyle _textStyle = TextStyle();
  final _formKey = GlobalKey<FormState>();
  double pass_strength = 0;

  checkFields() {
    if (_fulnameC.isNotEmpty && _phoneC.isNotEmpty && _passwordC.length > 5) {
      print(_fulnameC);
      print(_phoneC);
      print(_passwordC);

      setState(() {
        _isAllFilled = true;
      });
    } else {
      setState(() {
        _isAllFilled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkFields();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthOnSMS) {
                  showToast("Muvaffaqiyatli ro'yxattan o'tildi");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SmsVerificationScreen(
                        fromWhere: RouteNames.signup,
                        id: state.id,
                        phone: state.phoneNumber,
                      ),
                    ),
                  );
                }
                if (state is AuthDenied) {
                  showToast(state.error);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: CustomSimpleAppBar(
                      isSimple: false,
                      titleText: "Ro’yhatdan o’tish",
                      routeText: RouteNames.intro,
                      style: AppStyles.introButtonText.copyWith(
                        color: AppColors.smsVerColor,
                      ),
                      iconColor: AppColors.smsVerColor,
                    ),
                  ),
                  Gap(56.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _fulnameC = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Abiturent FISH",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.h),
                          borderSide: BorderSide(color: Colors.red, width: 2.w),
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
                  Gap(24.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TextField(
                      // inputFormatters: [_textFormat],
                      maxLength: 9,
                      onChanged: (value) {
                        setState(() {
                          _phoneC = value;
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Telefon raqami",
                        prefixText: "+998 ",
                        counter: const SizedBox.shrink(),
                        prefixStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.h),
                          borderSide: BorderSide(color: Colors.red, width: 2.w),
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
                  Gap(24.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _passwordC = value;
                        });
                      },
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        counter: const SizedBox.shrink(),
                        labelText: "Maxfiy so’z",
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            child: Icon(_isObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.h),
                          borderSide: BorderSide(color: Colors.red, width: 2.w),
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
                  Gap(21.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        _isAllFilled
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isChecked = !_isChecked;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(microseconds: 200),
                                  height: 24.h,
                                  width: 24.w,
                                  decoration: BoxDecoration(
                                    color: _isChecked
                                        ? AppColors.mainColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5.r),
                                    border: Border.all(
                                      color: AppColors.mainColor,
                                      width: 2.w,
                                    ),
                                  ),
                                  child: _isChecked
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16.h,
                                        )
                                      : null,
                                ),
                              )
                            : Container(
                                height: 24.h,
                                width: 24.w,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5.r),
                                  border: Border.all(
                                    color: AppColors.subtitleColor,
                                    width: 2.w,
                                  ),
                                ),
                              ),
                        Gap(14.w),
                        Expanded(
                          child: Text(
                            AppStrings.checkBoxText,
                            style: AppStyles.subtitleTextStyle.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                            maxLines: 2,
                          ),
                        )
                      ],
                    ),
                  ),
                  Gap(27.h),
                  _isChecked
                      ? BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            if (state is OnAuthProgress) {
                              return const CircularProgressIndicator(
                                color: AppColors.mainColor,
                              );
                            }
                            return ElevatedButton(
                              style: AppStyles.introUpButton,
                              onPressed: () {
                                context
                                    .read<AuthCubit>()
                                    .authSignUp(_fulnameC, _phoneC, _passwordC);
                              },
                              child: Text(
                                AppStrings.introUpButtonText,
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
                            AppStrings.introUpButtonText,
                            style: AppStyles.introButtonText
                                .copyWith(color: const Color(0xffFCFCFC)),
                          ),
                        ),
                  Gap(12.h),
                  Text(
                    "yoki",
                    style: AppStyles.subtitleTextStyle,
                  ),
                  Gap(24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Ro’yhatdan o’tganmisiz? ",
                          style: AppStyles.subtitleTextStyle,
                          children: [
                            TextSpan(
                                text: "Kirish",
                                style: AppStyles.subtitleTextStyle.copyWith(
                                    color: AppColors.mainColor,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      launch), // launch function for navigating to other screen
                          ],
                        ),
                      )
                    ],
                  )
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
      RouteNames.signin,
    );
  }
}
