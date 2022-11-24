import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/components/custom_card.dart';
import 'package:test_app/res/navigation/main_navigation.dart';

import '../../../../../core/block/payment_cubit/payment_cubit.dart';
import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/constants.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddCardScrenen extends StatefulWidget {
  const AddCardScrenen({super.key});

  @override
  State<AddCardScrenen> createState() => _AddCardScrenenState();
}

class _AddCardScrenenState extends State<AddCardScrenen> {
  var _cartNumber = "";
  var _cardPeriod = "";
  var _cardName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      body: BlocListener<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is OnCardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                ),
              ),
            );
          }
          if (state is OnCardAdded) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.payme,
              (route) => false,
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(40.h),
            CustomSimpleAppBar(
              isSimple: true,
              titleText: "Karta qo'shish",
              routeText: RouteNames.main,
              style: AppStyles.introButtonText.copyWith(
                fontSize: 18.sp,
                color: Colors.white,
              ),
              iconColor: Colors.white,
            ),
            Gap(54.w),
            CustomCard(
              _cardName,
              _cartNumber,
              _cardPeriod,
            ),
            Gap(80.h),
            Expanded(
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25.r),
                    topLeft: Radius.circular(25.r),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.only(top: 20.h),
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          TextField(
                            keyboardType: TextInputType.text,
                            onSubmitted: (value) {
                              setState(() {
                                _cardName = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Karta nomi",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.h),
                                borderSide: BorderSide(width: 2.w),
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
                          Gap(20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 240.w,
                                child: TextField(
                                  onSubmitted: (value) {
                                    setState(() {
                                      _cartNumber = value;
                                    });
                                  },
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                        mask: '#### #### #### ####')
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "0000 0000 0000 0000",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.h),
                                      borderSide: BorderSide(width: 2.w),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.h),
                                      borderSide: BorderSide(
                                          color: AppColors.mainColor,
                                          width: 2.w),
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
                              SizedBox(
                                width: 80.w,
                                child: TextField(
                                  onSubmitted: (value) {
                                    setState(() {
                                      _cardPeriod = value;
                                    });
                                  },
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    MaskTextInputFormatter(mask: '##/##')
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "00/00",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.h),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.h),
                                      borderSide: BorderSide(
                                          color: AppColors.mainColor,
                                          width: 2.w),
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
                        ],
                      ),
                    )),
                    Gap(53.h),
                    BlocBuilder<PaymentCubit, PaymentState>(
                      builder: (context, state) {
                        if (state is OnPayHistoryProgress) {
                          return const CircularProgressIndicator(
                            color: AppColors.mainColor,
                          );
                        }
                        return ElevatedButton(
                          style: AppStyles.introUpButton,
                          onPressed: () {
                            context.read<PaymentCubit>().addCard(
                                _cartNumber.replaceAll(" ", ""), _cardPeriod);
                          },
                          child: Text(
                            "Karta qo'shish",
                            style: AppStyles.introButtonText
                                .copyWith(color: const Color(0xffFCFCFC)),
                          ),
                        );
                      },
                    ),
                    Gap(16.h)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
