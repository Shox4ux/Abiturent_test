import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:test_app/ui/auth/sms_verification.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import '../../core/bloc/auth_cubit/auth_cubit.dart';
import '../../res/constants.dart';
import '../../res/components/custom_simple_appbar.dart';

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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
              child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthOnSMS) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SmsVerificationScreen(
                      fromWhere: RouteNames.forgetPassword,
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
                  padding: EdgeInsets.only(left: 20.w),
                  child: CustomSimpleAppBar(
                    isIcon: false,
                    isSimple: true,
                    titleText: "Parolni tiklash",
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
                      "Xavotir olmang, telefon raqamizga sms kod xabarnomasini jo’natamiz!",
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
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Telefon raqami",
                      prefixText: "+998 ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.h),
                        borderSide: BorderSide(color: Colors.red, width: 2.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.h),
                        borderSide: BorderSide(
                            color: AppColors.textFieldBorderColor, width: 2.w),
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
                                color: AppColors.mainColor);
                          }
                          return ElevatedButton(
                            style: AppStyles.introUpButton,
                            onPressed: () {
                              context.read<AuthCubit>().forgotPassword(_phone);
                            },
                            child: Text(
                              "Davom ettirish",
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
                          "Davom ettirish",
                          style: AppStyles.introButtonText
                              .copyWith(color: const Color(0xffFCFCFC)),
                        ),
                      ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
