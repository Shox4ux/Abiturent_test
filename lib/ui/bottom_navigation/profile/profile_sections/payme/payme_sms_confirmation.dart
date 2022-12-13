import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/patment_model/card_model.dart';
import 'package:test_app/res/functions/show_toast.dart';

import '../../../../../core/block/payment_cubit/payment_cubit.dart';
import '../../../../../res/components/custom_card.dart';
import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/components/waiting.dart';
import '../../../../../res/constants.dart';
import '../../../../../res/functions/number_formatter.dart';

class PaymeSmsConfirmation extends StatefulWidget {
  const PaymeSmsConfirmation(this.cardModel, {super.key});

  final CardModel cardModel;

  @override
  State<PaymeSmsConfirmation> createState() => _PaymeSmsConfirmationState();
}

class _PaymeSmsConfirmationState extends State<PaymeSmsConfirmation> {
  var _smsCode = "";
  var _isFilled = false;

  void _checkSmsTrim() {
    if (_smsCode.isEmpty) {
      _isFilled = false;
    } else {
      _isFilled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkSmsTrim();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is OnCardDeleted) {
            showToast(state.message);
          }
          // if (state is OnMadePayment) {
          //   Navigator.pushNamedAndRemoveUntil(
          //       context, RouteNames.main, (route) => false);
          // }
        },
        builder: (context, state) {
          if (state is OnMadePayment) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(40.h),
                CustomSimpleAppBar(
                  isSimple: true,
                  titleText: "Hisobni to’ldirish",
                  style: AppStyles.introButtonText.copyWith(
                    fontSize: 22.sp,
                    color: Colors.white,
                  ),
                  iconColor: Colors.white,
                  isIcon: false,
                ),
                Gap(64.w),
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "To’lov summasi",
                        style: AppStyles.introButtonText.copyWith(
                          color: AppColors.fillingColor.withOpacity(0.6),
                        ),
                      ),
                      Gap(11.h),
                      Text(
                        "${numberFormatter(int.parse(state.paymentResponse.amount!))} UZS",
                        style: AppStyles.introButtonText.copyWith(
                          color: AppColors.fillingColor,
                          fontSize: 34.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(10.h),
                Expanded(
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.r),
                        topLeft: Radius.circular(16.r),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.h),
                              child: CustomCard(widget.cardModel),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: TextField(
                                onSubmitted: (value) {
                                  setState(() {
                                    _smsCode = value;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "SMS-kodni kiriting",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.h),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.h),
                                    borderSide: BorderSide(
                                        color: AppColors.mainColor, width: 2.w),
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
                          ],
                        ),
                        _isFilled
                            ? Padding(
                                padding: EdgeInsets.only(bottom: 24.h),
                                child: ElevatedButton(
                                  style: AppStyles.introUpButton,
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil<void>(
                                      context,
                                      MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              WaitingScreen(
                                                status:
                                                    WarningValues.paymentDone,
                                                alertText: state
                                                    .paymentResponse.message!,
                                                extraText: state
                                                    .paymentResponse.amount!,
                                                buttonText:
                                                    "Obunalar oynasiga o'tish",
                                              )),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: Text(
                                    "Tasdiqlash",
                                    style: AppStyles.introButtonText.copyWith(
                                        color: const Color(0xffFCFCFC)),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(bottom: 24.h),
                                child: ElevatedButton(
                                  style: AppStyles.disabledButton,
                                  onPressed: null,
                                  child: Text(
                                    "Tasdiqlash",
                                    style: AppStyles.introButtonText.copyWith(
                                        color: const Color(0xffFCFCFC)),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        },
      ),
    );
    ;
  }
}
