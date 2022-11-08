import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/fund/filling_budget.dart';
import 'package:test_app/ui/components/custom_simple_appbar.dart';

import '../../../../../res/constants.dart';
import '../../../../navigation/main_navigation.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final TextEditingController _cartNumber = TextEditingController();
  final TextEditingController _period = TextEditingController();
  final TextEditingController _cardNime = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(40.h),
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,
            ),
            child: CustomSimpleAppBar(
              isSimple: true,
              titleText: "Yangi Hisob Yaratish",
              routeText: "profile",
              style: AppStyles.introButtonText.copyWith(
                fontSize: 24.sp,
                color: Colors.white,
              ),
              iconColor: Colors.white,
            ),
          ),
          Gap(64.w),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Joriy Hisob",
                  style: AppStyles.introButtonText.copyWith(
                    color: AppColors.fillingColor.withOpacity(0.6),
                  ),
                ),
                Gap(11.h),
                Text(
                  "0.0 UZS",
                  style: AppStyles.introButtonText.copyWith(
                    color: AppColors.fillingColor,
                    fontSize: 36.sp,
                  ),
                ),
              ],
            ),
          ),
          Gap(22.h),
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
                          controller: _cartNumber,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            MaskTextInputFormatter(mask: '#### #### #### ####')
                          ],
                          decoration: InputDecoration(
                            hintText: "0000 0000 0000 0000",
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
                        Gap(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 65.w,
                              child: TextField(
                                controller: _period,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  MaskTextInputFormatter(mask: '##/##')
                                ],
                                decoration: InputDecoration(
                                  hintText: "00/00",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.h),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.w),
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
                            Text(
                              "Amal qilish muddati",
                              style: AppStyles.introButtonText
                                  .copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                        Gap(10.h),
                        TextField(
                          controller: _cardNime,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Karta nomi",
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
                      ],
                    ),
                  )),
                  Gap(53.h),
                  Gap(114.h),
                  ElevatedButton(
                    style: AppStyles.introUpButton,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymeScreen(
                                  cardName: _cardNime.toString(),
                                  cardNumber: _cartNumber.toString(),
                                  period: _period.toString(),
                                )),
                      );
                    },
                    child: Text(
                      "Karta Qo'shish",
                      style: AppStyles.introButtonText
                          .copyWith(color: const Color(0xffFCFCFC)),
                    ),
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
