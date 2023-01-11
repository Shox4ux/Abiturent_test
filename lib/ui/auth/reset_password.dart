import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/components/custom_simple_appbar.dart';
import 'package:test_app/res/components/waiting.dart';
import 'package:test_app/res/functions/show_toast.dart';
import '../../core/bloc/auth_cubit/auth_cubit.dart';
import '../../res/constants.dart';

class ResetPassWord extends StatefulWidget {
  const ResetPassWord({
    Key? key,
    required this.phone,
  }) : super(key: key);
  final String phone;

  @override
  State<ResetPassWord> createState() => _ResetPassWordState();
}

class _ResetPassWordState extends State<ResetPassWord> {
  final formKey = GlobalKey<FormState>();
  var _isAllFilled = false;
  var _newPassword = "";
  var _confirmation = "";

  var _isObscure1 = true;
  var _isObscure2 = true;

  void _checkFields() {
    if (_newPassword.length > 5 && _confirmation == _newPassword) {
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

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthGranted) {
          showToast("Maxfiy so'z muvaffaqiyatli o'zgartirildi");
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const WaitingScreen(
                      status: WarningValues.smsDone,
                      alertText: "",
                      extraText: "",
                      buttonText: "",
                    )),
            (Route<dynamic> route) => false,
          );
        }
        if (state is AuthDenied) {
          showToast(state.error);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: CustomSimpleAppBar(
                      isIcon: false,
                      isSimple: true,
                      titleText: "Abiturentni tasdiqlash",
                      routeText: "routeText",
                      style: AppStyles.introButtonText.copyWith(
                        color: AppColors.titleColor,
                      ),
                      iconColor: AppColors.smsVerColor,
                    ),
                  ),
                  Gap(72.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: TextField(
                      obscureText: _isObscure2,
                      onChanged: (value) {
                        _checkFields();

                        setState(() {
                          _newPassword = value;
                        });
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscure2 = !_isObscure2;
                            });
                          },
                          child: Icon(_isObscure2
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        ),
                        counter: const SizedBox.shrink(),
                        labelText: "Yangi maxfiy so’zni kiritish",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.h),
                          borderSide: BorderSide(color: Colors.red, width: 2.w),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.h),
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
                      obscureText: _isObscure1,
                      onChanged: (value) {
                        _checkFields();
                        setState(() {
                          _confirmation = value;
                        });
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscure1 = !_isObscure1;
                            });
                          },
                          child: Icon(_isObscure1
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        ),
                        counter: const SizedBox.shrink(),
                        labelText: "Qayta maxfiy so’zni kiritish",
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
                  Gap(27.h),
                  _isAllFilled
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
                                context.read<AuthCubit>().changePassword(
                                      widget.phone,
                                      _newPassword,
                                      _confirmation,
                                    );
                              },
                              child: Text(
                                "Saqlash",
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
                            "Saqlash",
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

  void launch() {}
}
