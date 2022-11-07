import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:test_app/ui/navigation/main_navigation.dart';

import '../../core/block/auth_block/auth_cubit.dart';
import '../../res/constants.dart';
import '../components/custom_simple_appbar.dart';

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
    if (_password.isNotEmpty && _phoneNumber.isNotEmpty) {
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
          print("from login: ${state.userInfo.fullname}");

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Successfully logged in!")));
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteNames.main,
            (Route<dynamic> route) => false,
          );
        }
        if (state is AuthDenied) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
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
                    isSimple: false,
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
                    // inputFormatters: [_textFormat],
                    maxLength: 12,
                    onChanged: (value) {
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
                Gap(24.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  child: TextField(
                    maxLength: 6,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    keyboardType: TextInputType.number,
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
                          if (state is OnProgress) {
                            return const CircularProgressIndicator(
                              color: AppColors.mainColor,
                            );
                          }
                          return ElevatedButton(
                            style: AppStyles.introUpButton,
                            onPressed: () async {
                              await context
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
