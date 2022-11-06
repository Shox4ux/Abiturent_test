import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/ui/components/custom_simple_appbar.dart';
import 'package:test_app/ui/navigation/main_navigation.dart';

import '../../../../../core/block/auth_block/auth_cubit.dart';
import '../../../../../res/constants.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    final items = [
      "1 fani",
      "2 fani",
      "3 fani",
      "4 fani",
    ];
    String? selectedItem = "1 fani";
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: CustomSimpleAppBar(
              isSimple: false,
              titleText: "Guruhlarim",
              iconColor: Colors.white,
              routeText: RouteNames.main,
              style: AppStyles.subtitleTextStyle.copyWith(
                color: Colors.white,
                fontSize: 24.sp,
              ),
            ),
          ),
          Gap(17.h),
          Expanded(
            child: Container(
                padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return groupItem();
                          }),
                    ),
                    Gap(10.h),
                    ElevatedButton(
                      style: AppStyles.introUpButton,
                      onPressed: () {
                        var onChanged;
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              16.r,
                            ),
                          )),
                          context: context,
                          builder: ((context) => Padding(
                                padding: EdgeInsets.only(
                                    top: 20.h,
                                    left: 20.w,
                                    right: 20.w,
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.h),
                                            borderSide: BorderSide(
                                                color: AppColors
                                                    .textFieldBorderColor,
                                                width: 2.w),
                                          ),
                                        ),
                                        value: selectedItem,
                                        items: items
                                            .map((item) => DropdownMenuItem(
                                                value: item, child: Text(item)))
                                            .toList(),
                                        onChanged: (item) {
                                          setState(() {
                                            selectedItem == item;
                                          });
                                        },
                                      ),
                                    ),
                                    Gap(16.h),
                                    TextField(
                                      maxLength: 6,
                                      onChanged: (value) {},
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        counter: const SizedBox.shrink(),
                                        labelText: "Maxfiy so’z",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.h),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2.w),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.h),
                                          borderSide: BorderSide(
                                              color: AppColors
                                                  .textFieldBorderColor,
                                              width: 2.w),
                                        ),
                                      ),
                                    ),
                                    Gap(16.h),
                                    ElevatedButton(
                                      onPressed: null,
                                      style: AppStyles.introUpButton,
                                      child: Text(
                                        "Yaratish",
                                        style: AppStyles.introButtonText
                                            .copyWith(
                                                color: const Color(0xffFCFCFC)),
                                      ),
                                    ),
                                    Gap(16.h),
                                  ],
                                ),
                              )),
                        );
                      },
                      child: Text(
                        "Yangi guruh yaratish",
                        style: AppStyles.introButtonText
                            .copyWith(color: const Color(0xffFCFCFC)),
                      ),
                    ),
                    Gap(10.h),
                  ],
                )),
          ),
        ]),
      ),
    );
  }
}

Widget groupItem() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Gap(6.h),
      Text(
        "Tarix fani",
        style: AppStyles.introButtonText.copyWith(
          color: AppColors.smsVerColor,
        ),
      ),
      Gap(13.h),
      Column(
        children: [
          for (var i = 0; i < 3; i++) groupMemberItem(),
        ],
      )
    ],
  );
}

Widget groupMemberItem() {
  return Padding(
    padding: EdgeInsets.only(bottom: 14.h),
    child: Row(
      children: [
        Container(
          height: 60.h,
          width: 60.w,
          decoration: BoxDecoration(
            color: AppColors.textFieldBorderColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Image.asset(
            AppIcons.members,
            height: 20,
            width: 20,
            scale: 3,
          ),
        ),
        Gap(9.w),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "101 guruhlar",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      color: AppColors.smsVerColor,
                    ),
                  )
                ],
              ),
              Gap(13.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Yaratilgan sana:",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),
                  Text(
                    "13 ishtirokchi",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}
