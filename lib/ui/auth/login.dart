import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/components/waiting.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import '../../core/bloc/auth_cubit/auth_cubit.dart';
import '../../res/constants.dart';
import '../../res/components/custom_simple_appbar.dart';
import '../../res/functions/show_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _textFormat = MaskTextInputFormatter(mask: '## ### ## ##');
  bool isObscure = true;
  var _isAllfilled = false;
  var _phoneNumber = "";
  var _password = "";

  void changeObscureMode() {
    isObscure = !isObscure;
    setState(() {});
  }

  void checkFields() {
    if (_password.length > 5 && _phoneNumber.isNotEmpty) {
      setState(() {
        _isAllfilled = true;
      });
    } else {
      setState(() {
        _isAllfilled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkFields();
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UserActive) {
          showToast("Muvaffaqiyatli tizimga kirildi");
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteNames.main,
            arguments: 2,
            (Route<dynamic> route) => false,
          );
        }
        if (state is AuthDenied) {
          showToast(state.error);
        }
        if (state is OnAuthBlocked) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => WaitingScreen(
                      status: WarningValues.authError,
                      extraText: "",
                      alertText: state.message,
                      buttonText: "Operatorga yuzlanish")),
              (route) => false);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: CustomSimpleAppBar(
                    isIcon: false,
                    isSimple: true,
                    titleText: "Tizimga kirish",
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
                    textInputAction: TextInputAction.next,
                    maxLength: 9,
                    onChanged: (value) {
                      checkFields();
                      setState(() {
                        _phoneNumber = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Telefon raqami",
                      prefixText: "+998 ",
                      counter: const SizedBox.shrink(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.h),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.h),
                        borderSide: BorderSide(
                            color: AppColors.textFieldBorderColor, width: 2.w),
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
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      checkFields();

                      setState(() {
                        _password = value;
                      });
                    },
                    keyboardType: TextInputType.text,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      counter: const SizedBox.shrink(),
                      labelText: "Maxfiy so’z",
                      suffixIcon: GestureDetector(
                        onTap: changeObscureMode,
                        child: Icon(
                          isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
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
                _isAllfilled
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
                                  .authLogin(_phoneNumber, _password);
                            },
                            child: Text(
                              "Kirish",
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
                          "Kirish",
                          style: AppStyles.introButtonText
                              .copyWith(color: const Color(0xffFCFCFC)),
                        ),
                      ),
                Gap(33.h),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.forget,
                    );
                  },
                  child: Text(
                    "Maxfiy so’zni tiklash",
                    style: AppStyles.introButtonText
                        .copyWith(color: AppColors.mainColor),
                  ),
                ),
                Gap(33.h),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Yangi foydalanuvchimisiz ? ",
                      style: AppStyles.subtitleTextStyle,
                    ),
                    RichText(
                      text: TextSpan(
                        style: AppStyles.subtitleTextStyle,
                        children: [
                          TextSpan(
                              text: "Ro’yhatdan o’tish",
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
    );
  }

  void launch() {
    Navigator.pushNamed(context, RouteNames.signup);
  }
}
