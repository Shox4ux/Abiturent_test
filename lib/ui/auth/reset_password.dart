import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/components/custom_simple_appbar.dart';
import 'package:test_app/res/components/waiting.dart';

import '../../core/block/auth_block/auth_cubit.dart';
import '../../res/constants.dart';
import '../../res/navigation/main_navigation.dart';

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
  void _checkFields(BuildContext context) {
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
    _checkFields(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Muvaffaqiyatli ro'yxattan o'tildi"),
            ),
          );

          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const WaitingScreen(
                      status: WarningValues.smsDone,
                      errorText: "",
                      buttonText: "",
                    )),
            (Route<dynamic> route) => false,
          );
        }
        if (state is AuthDenied) {
          (ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error,
              ),
            ),
          ));
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
                      onChanged: (value) {
                        setState(() {
                          _newPassword = value;
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
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
                      onChanged: (value) {
                        setState(() {
                          _confirmation = value;
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
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
