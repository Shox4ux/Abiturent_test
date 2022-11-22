import 'package:awesome_card/credit_card.dart';
import 'package:awesome_card/extra/card_type.dart';
import 'package:awesome_card/style/card_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
      body: Column(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CreditCard(
                height: 210.h,
                cardNumber: _cartNumber,
                cardExpiry: _cardPeriod,
                cardHolderName: _cardName,
                frontTextColor: Colors.black,
                bankName: _cardName,
                cardType: CardType
                    .masterCard, // Optional if you want to override Card Type
                showBackSide: false,
                frontBackground: CardBackgrounds.white,
                showShadow: true,
                textExpDate: 'Exp. Date',
                textName: 'Name',
                textExpiry: 'MM/YY', backBackground: CardBackgrounds.black,
              )
            ],
          ),
          Gap(60.h),
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
                  Gap(20.h),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        Text(
                          "Karta qo’shish",
                          style: AppStyles.introButtonText
                              .copyWith(color: Colors.grey),
                        ),
                        Gap(10.h),
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
                        Gap(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 260.w,
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
                          print(_cardName);
                          print(_cartNumber.replaceAll(" ", ""));
                          print(_cardPeriod);

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => PaymeScreen(
                          //             cardName: _cardNime.text,
                          //             cardNumber: _cartNumber.text,
                          //             period: _period.text,
                          //           )),
                          // );
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
    );
  }
}
