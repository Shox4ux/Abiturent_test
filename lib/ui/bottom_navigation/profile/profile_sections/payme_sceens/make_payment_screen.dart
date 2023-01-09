import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:test_app/core/domain/patment_model/on_payment_done.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import '../../../../../core/bloc/auth_cubit/auth_cubit.dart';
import '../../../../../core/bloc/payment_cubit/payment_cubit.dart';
import '../../../../../res/components/custom_card.dart';
import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/constants.dart';
import '../../../../../res/functions/number_formatter.dart';

class MakePaymentScreen extends StatefulWidget {
  const MakePaymentScreen({super.key});

  @override
  State<MakePaymentScreen> createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  var _isNotEmpty = false;
  final _amountController = TextEditingController();
  int? _currentCardIndex;
  void _check(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _isNotEmpty = true;
      });
    } else {
      setState(() {
        _isNotEmpty = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is OnCardDeleted) {
            context.read<PaymentCubit>().getCards();
          }
          if (state is OnCardsEmpty) {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteNames.main, (route) => false);
          }
          if (state is OnMadePayment) {}
        },
        builder: (context, state) {
          if (state is OnMadePayment) {
            return onPaymentDone(context, state.onPaymentDone);
          }
          return onPayment();
        },
      ),
    );
    ;
  }

  Widget onPayment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(40.h),
        CustomSimpleAppBar(
          isIcon: true,
          isSimple: false,
          titleText: "Hisobni to’ldirish",
          style: AppStyles.introButtonText.copyWith(
            fontSize: 22.sp,
            color: Colors.white,
          ),
          iconColor: Colors.white,
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
              TextField(
                keyboardType: TextInputType.number,
                controller: _amountController,
                onChanged: (value) {
                  _check(value);
                },
                inputFormatters: [
                  ThousandsFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: "0 UZS",
                  hintStyle: AppStyles.introButtonText.copyWith(
                    color: AppColors.fillingColor.withOpacity(0.6),
                    fontSize: 36.sp,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
                style: AppStyles.introButtonText.copyWith(
                  color: AppColors.fillingColor,
                  fontSize: 36.sp,
                ),
              )
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
            child: BlocBuilder<PaymentCubit, PaymentState>(
              builder: (context, state) {
                if (state is OnCardsReceived) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 245.h,
                        child: ListView.builder(
                          itemCount: state.models.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            _currentCardIndex = index;
                            return Padding(
                              padding: EdgeInsets.all(10.h),
                              child: CustomCard(state.models[index]),
                            );
                          },
                        ),
                      ),
                      _isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(bottom: 24.h),
                              child: ElevatedButton(
                                style: AppStyles.introUpButton,
                                onPressed: () {
                                  context.read<PaymentCubit>().makePayment(
                                        state.models[_currentCardIndex!].id,
                                        _amountController.text,
                                      );
                                },
                                child: Text(
                                  "To’lov amalga oshirish",
                                  style: AppStyles.introButtonText
                                      .copyWith(color: const Color(0xffFCFCFC)),
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(bottom: 24.h),
                              child: ElevatedButton(
                                style: AppStyles.disabledButton,
                                onPressed: null,
                                child: Text(
                                  "To’lov amalga oshirish",
                                  style: AppStyles.introButtonText
                                      .copyWith(color: const Color(0xffFCFCFC)),
                                ),
                              ),
                            ),
                    ],
                  );
                }
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              },
            ),
          ),
        ),
      ],
    );
  }
}

Widget onPaymentDone(BuildContext context, OnPaymentDone onPaymentDone) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 76.h),
              width: 312.w,
              height: 312.h,
              child: Image.asset(
                AppIcons.bi,
                color: AppColors.greenBackground,
                scale: 3,
              ),
            ),
            Gap(18.h),
            Text(
              "Hisobingiz to’ldirildi: ",
              textAlign: TextAlign.center,
              style: AppStyles.smsVerBigTextStyle.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        _amountProcessing(onPaymentDone.receipt?.amount) ?? "",
                    style: AppStyles.introButtonText
                        .copyWith(color: Colors.black, fontSize: 48.sp),
                  ),
                  TextSpan(
                    text: " UZS",
                    style: AppStyles.introButtonText
                        .copyWith(color: Colors.black, fontSize: 36.sp),
                  )
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(bottom: 24.h),
          child: ElevatedButton(
              style: AppStyles.introUpButton,
              onPressed: () async {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.main,
                  (route) => false,
                );
                await context.read<AuthCubit>().getUserData();
              },
              child: Text(
                "Bosh sahifa",
                style: AppStyles.introButtonText
                    .copyWith(color: const Color(0xffFCFCFC)),
              )),
        ),
      ],
    ),
  );
}

String? _amountProcessing(num? amount) {
  var processedNum = numberFormatter(amount);
  var formattedAmount = processedNum.substring(0, processedNum.length - 2);
  return formattedAmount;
}
