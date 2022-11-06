import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/ui/navigation/main_navigation.dart';

import '../../core/block/auth_block/auth_cubit.dart';
import '../../res/constants.dart';
import '../components/custom_simple_appbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var _phone = "";
  var _isAllFilled = false;

  void checkFields() {
    if (_phone.isNotEmpty) {
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

    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthGranted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteNames.smsVerification,
                        arguments: RouteNames.forget,
                        (Route<dynamic> route) => false);
                  }
                  if (state is AuthDenied) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.error),
                    ));
                  }
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: CustomSimpleAppBar(
                          isSimple: true,
                          titleText: "Maxfiy so’zni tiklash",
                          routeText: "routeText",
                          style: AppStyles.introButtonText.copyWith(
                            color: AppColors.titleColor,
                          ),
                          iconColor: AppColors.smsVerColor,
                        ),
                      ),
                      Gap(58.h),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            "Xavotir olmang.Telefon raqamingizga sms kod xabarnomasini jo’natamiz!",
                            style: AppStyles.introButtonText.copyWith(
                              color: Colors.black,
                              fontSize: 24.sp,
                            ),
                          )),
                      Gap(24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _phone = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Telefon raqam",
                            prefixText: "+998 ",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.h),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2.w),
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
                          ? ElevatedButton(
                              style: AppStyles.introUpButton,
                              onPressed: () {
                                context.read<AuthCubit>().forgotPassword(
                                      _phone,
                                    );
                              },
                              child: Text(
                                "Davom ettirish",
                                style: AppStyles.introButtonText
                                    .copyWith(color: const Color(0xffFCFCFC)),
                              ),
                            )
                          : ElevatedButton(
                              style: AppStyles.disabledButton,
                              onPressed: null,
                              child: Text(
                                "Davom ettirish",
                                style: AppStyles.introButtonText
                                    .copyWith(color: const Color(0xffFCFCFC)),
                              ),
                            ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// 