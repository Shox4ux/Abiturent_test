import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:test_app/ui/auth/sms_verification.dart';
import '../../core/bloc/auth_cubit/auth_cubit.dart';
import '../../res/components/custom_simple_appbar.dart';
import '../../res/navigation/main_navigation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool _isObscure = false;
  bool _isAllFilled = false;
  var _fulnameC = "";
  var _phoneC = "";
  var _passwordC = "";
  final TextEditingController _controller = TextEditingController();

  void _checkFields() {
    if (_fulnameC.isNotEmpty && _phoneC.isNotEmpty && _passwordC.length > 5) {
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
    _checkFields();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthOnSMS) {
                  showToast("Ro'yxatdan muvaffaqiyatli  o'tildi");

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
                      isIcon: false,
                      isSimple: true,
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
                        _checkFields();
                        setState(() {
                          _fulnameC = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "O'quvchi FISH",
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
                      maxLength: 9,
                      onChanged: (value) {
                        _checkFields();
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
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        _checkFields();
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
                              : Icons.visibility_outlined),
                        ),
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
                              onPressed: () async {
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
