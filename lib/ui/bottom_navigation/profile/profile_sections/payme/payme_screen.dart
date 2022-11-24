import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/block/payment_cubit/payment_cubit.dart';
import 'package:test_app/res/components/custom_card.dart';
import '../../../../../res/components/custom_dot_indicators.dart';
import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/constants.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../../res/navigation/main_navigation.dart';

class PaymeScreen extends StatefulWidget {
  const PaymeScreen({
    super.key,
  });

  @override
  State<PaymeScreen> createState() => _PaymeScreenState();
}

class _PaymeScreenState extends State<PaymeScreen> {
  final textFormat = MaskTextInputFormatter(mask: '### ### ### ### ###');
  int activeIndex = 0;
  final _controller = PageController();

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
              titleText: "Hisobni to’ldirish",
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
                  "To’lov summasi",
                  style: AppStyles.introButtonText.copyWith(
                    color: AppColors.fillingColor.withOpacity(0.6),
                  ),
                ),
                Gap(11.h),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [textFormat],
                  decoration: InputDecoration(
                      hintText: "0.0 UZS",
                      hintStyle: AppStyles.introButtonText.copyWith(
                        color: AppColors.fillingColor.withOpacity(0.6),
                        fontSize: 36.sp,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.sp))),
                  style: AppStyles.introButtonText.copyWith(
                    color: AppColors.fillingColor,
                    fontSize: 36.sp,
                  ),
                )
              ],
            ),
          ),
          Gap(22.h),
          Expanded(
            child: Container(
                padding: EdgeInsets.only(top: 20.h),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<PaymentCubit, PaymentState>(
                      builder: (context, state) {
                        if (state is OnCardAdded) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 220.h,
                                child: PageView.builder(
                                  controller: _controller,
                                  itemCount: 4,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomCard("", "", ""),
                                  ),
                                  onPageChanged: (value) {
                                    setState(() {
                                      activeIndex = value;
                                    });
                                  },
                                ),
                              ),
                              Gap(10.h),
                              CustomDotIndicator(
                                activeIndex: activeIndex,
                                itemCount: 4,
                              )
                            ],
                          );
                        }
                        return const Center(
                            child: Text("Hozircha hechnara yo"));
                      },
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          style: AppStyles.introUpButton,
                          onPressed: () {
                            // Navigator.pushNamed(
                            //   context,
                            //   RouteNames.smsVerification,
                            //   arguments: "+998912222222",
                            // );
                          },
                          child: Text(
                            "To’lov amalga oshirish",
                            style: AppStyles.introButtonText
                                .copyWith(color: const Color(0xffFCFCFC)),
                          ),
                        ),
                        Gap(10.h),
                        ElevatedButton(
                          style: AppStyles.introUpButton,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.addCard,
                            );
                          },
                          child: Text(
                            "Karta qo'shish",
                            style: AppStyles.introButtonText
                                .copyWith(color: const Color(0xffFCFCFC)),
                          ),
                        ),
                      ],
                    ),
                    Gap(16.h)
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
