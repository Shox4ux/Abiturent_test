import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/ui/components/custom_simple_appbar.dart';

import '../../core/block/auth_block/auth_cubit.dart';
import '../../res/constants.dart';

class ResetPassWord extends StatefulWidget {
  const ResetPassWord({Key? key}) : super(key: key);

  @override
  State<ResetPassWord> createState() => _ResetPassWordState();
}

class _ResetPassWordState extends State<ResetPassWord> {
  final formKey = GlobalKey<FormState>();
  var _isAllFilled = false;
  var _newPassword = "";
  var _confirmation = "";
  void _checkFields() {
    if (_newPassword.length == 6 && _confirmation.length == 6) {
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

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
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
                        titleText: "Abiturentni tasniqlash",
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
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counter: const SizedBox.shrink(),
                          labelText: "Yangi maxfiy so’zni kiritish",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.w),
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
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counter: const SizedBox.shrink(),
                          labelText: "Qayta maxfiy so’zni kiritish",
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
                              context
                                  .read<AuthCubit>()
                                  .changePassword(_newPassword, _confirmation);
                            },
                            child: Text(
                              "Saqlash",
                              style: AppStyles.introButtonText
                                  .copyWith(color: const Color(0xffFCFCFC)),
                            ),
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
        );
      },
    );
  }

  void launch() {}
}
