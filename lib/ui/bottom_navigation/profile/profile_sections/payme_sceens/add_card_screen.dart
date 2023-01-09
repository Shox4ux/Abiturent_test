import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/functions/show_toast.dart';
import '../../../../../core/bloc/payment_cubit/payment_cubit.dart';
import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/constants.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../../res/navigation/main_navigation.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _cardPeriodController = TextEditingController();
  final _cardPanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is OnCardError) {
            showToast(state.error);
          }
          if (state is OnCardAdded) {
            Navigator.pushNamed(context, RouteNames.confirmCard);
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: CustomSimpleAppBar(
                  isIcon: false,
                  isSimple: true,
                  titleText: "Hisobni to’ldirish",
                  routeText: RouteNames.main,
                  style: AppStyles.introButtonText.copyWith(
                    fontSize: 22.sp,
                    color: Colors.white,
                  ),
                  iconColor: Colors.white,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: 20.w, left: 20.w, bottom: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "To’lov summasi",
                          style: AppStyles.introButtonText.copyWith(
                              color: AppColors.fillingColor.withOpacity(0.6),
                              fontSize: 16.sp),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "0 ",
                                style: AppStyles.introButtonText.copyWith(
                                    color: AppColors.fillingColor,
                                    fontSize: 48.sp),
                              ),
                              TextSpan(
                                text: "UZS",
                                style: AppStyles.introButtonText.copyWith(
                                    color: AppColors.fillingColor,
                                    fontSize: 42.sp),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: screenSize.height * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.r),
                        topLeft: Radius.circular(16.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: _addCardPart(),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _addCardPart() {
    return Column(
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
                  MaskTextInputFormatter(mask: '#### #### #### ####')
                ],
                decoration: InputDecoration(
                  hintText: "1234 1234 1234 1234",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.h),
                    borderSide: BorderSide(width: 2.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.h),
                    borderSide:
                        BorderSide(color: AppColors.mainColor, width: 2.w),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.h),
                    borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor, width: 2.w),
                  ),
                ),
              ),
              Gap(16.h),
              TextField(
                textInputAction: TextInputAction.done,
                controller: _cardPeriodController,
                keyboardType: TextInputType.phone,
                inputFormatters: [MaskTextInputFormatter(mask: '##/##')],
                decoration: InputDecoration(
                  hintText: "MM/YY",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.h),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.h),
                    borderSide:
                        BorderSide(color: AppColors.mainColor, width: 2.w),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.h),
                    borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor, width: 2.w),
                  ),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            if (state is OnCardProgress) {
              return const CircularProgressIndicator.adaptive();
            }
            return Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: ElevatedButton(
                style: AppStyles.introUpButton,
                onPressed: () {
                  context.read<PaymentCubit>().addCard(
                        _cardPanController.text.replaceAll(" ", ""),
                        _cardPeriodController.text,
                      );
                },
                child: Text(
                  "Karta qo'shish",
                  style: AppStyles.introButtonText
                      .copyWith(color: const Color(0xffFCFCFC)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
