import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/number_formatter.dart';
import '../../core/bloc/payment_cubit/payment_cubit.dart';
import '../../core/domain/patment_model/card_model.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
    this.cardModel, {
    super.key,
  });
  final CardModel cardModel;
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
          top: 110,
          left: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                cardPanFormatter(int.parse(cardModel.cardPan!)),
                style: AppStyles.introButtonText.copyWith(fontSize: 22.sp),
              ),
              Text(
                cardModel.cardMonth!,
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
                            cardModel.cardPan!,
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
