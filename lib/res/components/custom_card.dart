import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/domain/patment_model/card_list_model.dart';
import 'package:test_app/res/constants.dart';
import '../../core/bloc/payment_cubit/payment_cubit.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(this.cardModel, {super.key});
  final CardListModel cardModel;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Image.asset(AppIcons.card),
        ),
        Positioned(
          top: 30.h,
          right: 10.w,
          child: Container(
            width: 150.w,
            height: 30.h,
            decoration: BoxDecoration(
                color: cardModel.cardStatus == 1 ? Colors.green : Colors.red),
            child: Center(
                child: Text(
              cardModel.cardStatusText ?? "",
              style: AppStyles.introButtonText.copyWith(
                color: Colors.white,
              ),
            )),
          ),
        ),
        Positioned(
          top: 120.h,
          left: 40.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                cardModel.cardPan ?? "",
                style: AppStyles.introButtonText.copyWith(fontSize: 24.sp),
              ),
              Text(
                cardModel.cardMonth ?? "",
                style: AppStyles.introButtonText.copyWith(fontSize: 16.sp),
              )
            ],
          ),
        ),
        Positioned(
          top: 175,
          left: 310,
          child: GestureDetector(
            onTap: () {
              alertDialog(context);
            },
            child: Container(
              height: 32.h,
              width: 32.w,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(200.h),
              ),
              child: Image.asset(
                AppIcons.delete,
                scale: 3,
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<dynamic> alertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text("Kartani o'chirmoqchimisiz?"),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<PaymentCubit>().deleteCard(
                            cardModel.id!,
                          );
                      context.read<PaymentCubit>().getCards();
                    },
                    child: const Text(
                      "Ha",
                      style: TextStyle(
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Yo'q",
                      style: TextStyle(
                        color: AppColors.mainColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
