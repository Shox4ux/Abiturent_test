import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/payme/payme_info_confirmation.dart';
import '../../../../../core/block/payment_cubit/payment_cubit.dart';
import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/constants.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../../res/navigation/main_navigation.dart';

class PaymeScreen extends StatefulWidget {
  const PaymeScreen({super.key});

  @override
  State<PaymeScreen> createState() => _PaymeScreenState();
}

class _PaymeScreenState extends State<PaymeScreen> {
  final _amountController = TextEditingController();
  final _cardPeriodController = TextEditingController();
  final _cardPanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is OnCardError) {
            showToast(state.error);
          }
          if (state is OnCardAdded) {
            context.read<PaymentCubit>().getCards();
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => PaymeInfoConfirmation(
                  _amountController.text.replaceAll(",", ""),
                  isConfirmed: false,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OnCardProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(40.h),
              CustomSimpleAppBar(
                isIcon: false,
                isSimple: false,
                titleText: "Hisobni to’ldirish",
                routeText: RouteNames.main,
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
                      inputFormatters: [
                        ThousandsFormatter(),
                      ],
                      decoration: InputDecoration(
                        hintText: "0,00 UZS",
                        hintStyle: AppStyles.introButtonText.copyWith(
                          color: AppColors.fillingColor.withOpacity(0.6),
                          fontSize: 36.sp,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.sp),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.sp),
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
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: [
                              TextField(
                                controller: _cardPanController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                      mask: '#### #### #### ####')
                                ],
                                decoration: InputDecoration(
                                  hintText: "1234 1234 1234 1234",
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
                              Gap(16.h),
                              TextField(
                                controller: _cardPeriodController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  MaskTextInputFormatter(mask: '##/##')
                                ],
                                decoration: InputDecoration(
                                  hintText: "MM/YY",
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 24.h),
                          child: ElevatedButton(
                            style: AppStyles.introUpButton,
                            onPressed: () {
                              context.read<PaymentCubit>().addCard(
                                    _cardPanController.text.replaceAll(" ", ""),
                                    _cardPeriodController.text,
                                  );
                              // context.read<PaymentCubit>().makePayment(
                              //       _cardPeriodController.text,
                              //       _cardPanController.text.replaceAll(" ", ""),
                              //       _amountController.text.replaceAll(",", ""),
                              //     );
                            },
                            child: Text(
                              "Karta qo'shish",
                              style: AppStyles.introButtonText
                                  .copyWith(color: const Color(0xffFCFCFC)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
