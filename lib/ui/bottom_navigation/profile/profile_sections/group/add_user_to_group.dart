import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/group_model/group_member_model.dart';

import '../../../../../core/block/group_block/group_cubit.dart';
import '../../../../../core/domain/user_model/user_model.dart';
import '../../../../../core/helper/repos/user_repo.dart';
import '../../../../../res/constants.dart';
import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/navigation/main_navigation.dart';

class AddUserToGroup extends StatefulWidget {
  const AddUserToGroup({super.key});

  @override
  State<AddUserToGroup> createState() => _AddUserToGroupState();
}

class _AddUserToGroupState extends State<AddUserToGroup> {
  final _repo = UserRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: CustomSimpleAppBar(
              isSimple: true,
              titleText: "Ishtirokchi qo’shish",
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
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
                child: BlocConsumer<GroupCubit, GroupState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    if (state is OnGroupMembersReceived) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.w, right: 20.w, top: 20.h),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      AppIcons.tab,
                                      scale: 2,
                                    ),
                                    Gap(15.w),
                                    Text("ishtirokchi",
                                        style: AppStyles.subtitleTextStyle
                                            .copyWith(color: Colors.black))
                                  ],
                                ),
                                Gap(20.w),
                                Row(
                                  children: [
                                    Image.asset(
                                      AppIcons.user,
                                      scale: 2,
                                    ),
                                    Gap(15.w),
                                    Text("ishtirokchi",
                                        style: AppStyles.subtitleTextStyle
                                            .copyWith(color: Colors.black))
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                padding: EdgeInsets.only(
                                  bottom: 20.h,
                                  top: 30.h,
                                  left: 20.w,
                                  right: 10.w,
                                ),
                                itemCount: state.membersList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ratingItem(
                                      "${index + 1}", state.membersList[index]);
                                }),
                          ),
                          ElevatedButton(
                            style: AppStyles.introUpButton,
                            onPressed: () {
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
                                          Gap(16.h),
                                          TextField(
                                            maxLength: 6,
                                            onChanged: (value) {},
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              counter: const SizedBox.shrink(),
                                              labelText:
                                                  "Ishtirokchi ID raqami",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.h),
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 2.w),
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
                                            onPressed: () {},
                                            style: AppStyles.introUpButton,
                                            child: Text(
                                              "Ishtirokchi qo’shish",
                                              style: AppStyles.introButtonText
                                                  .copyWith(
                                                      color: const Color(
                                                          0xffFCFCFC)),
                                            ),
                                          ),
                                          Gap(16.h),
                                        ],
                                      ),
                                    )),
                              );
                            },
                            child: Text(
                              "Ishtirokchi qo’shish",
                              style: AppStyles.introButtonText
                                  .copyWith(color: const Color(0xffFCFCFC)),
                            ),
                          ),
                          Gap(10.h),
                        ],
                      );
                    }

                    if (state is OnProgress) {
                      return const Center(
                        child: Text("Iltimos kuting..."),
                      );
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 20.h),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    AppIcons.tab,
                                    scale: 2,
                                  ),
                                  Gap(15.w),
                                  Text("Tarix fani",
                                      style: AppStyles.subtitleTextStyle
                                          .copyWith(color: Colors.black))
                                ],
                              ),
                              Gap(20.w),
                              Row(
                                children: [
                                  Image.asset(
                                    AppIcons.user,
                                    scale: 2,
                                  ),
                                  Gap(15.w),
                                  Text("ishtirokchi",
                                      style: AppStyles.subtitleTextStyle
                                          .copyWith(color: Colors.black))
                                ],
                              )
                            ],
                          ),
                        ),
                        const Expanded(
                            child: Center(child: Text('Ishtirokchilar yo'))),
                        ElevatedButton(
                          style: AppStyles.introUpButton,
                          onPressed: () {
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
                                        Gap(16.h),
                                        TextField(
                                          maxLength: 6,
                                          onChanged: (value) {},
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            counter: const SizedBox.shrink(),
                                            labelText: "Ishtirokchi ID raqami",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.h),
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 2.w),
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
                                          onPressed: () {},
                                          style: AppStyles.introUpButton,
                                          child: Text(
                                            "Ishtirokchi qo’shish",
                                            style: AppStyles.introButtonText
                                                .copyWith(
                                                    color: const Color(
                                                        0xffFCFCFC)),
                                          ),
                                        ),
                                        Gap(16.h),
                                      ],
                                    ),
                                  )),
                            );
                          },
                          child: Text(
                            "Ishtirokchi qo’shish",
                            style: AppStyles.introButtonText
                                .copyWith(color: const Color(0xffFCFCFC)),
                          ),
                        ),
                        Gap(10.h),
                      ],
                    );
                  },
                )),
          ),
        ]),
      ),
    );
  }
}

Widget ratingItem(String index, GroupMemberModel data) {
  return Container(
    margin: EdgeInsets.only(bottom: 10.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          index,
          style: AppStyles.subtitleTextStyle.copyWith(
            fontSize: 13.sp,
          ),
        ),
        Gap(8.w),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "# ${data.id.toString()}",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),
                  Text(
                    data.fullname!,
                    style: AppStyles.subtitleTextStyle
                        .copyWith(color: AppColors.smsVerColor),
                  ),
                ],
              ),
              Container(
                height: 37.h,
                width: 79.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(13.r),
                  ),
                  color: AppColors.mainColor,
                ),
                child: Center(
                  child: Text(
                    "${data.rating} ball",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(6.w),
        Container(
          height: 32.h,
          width: 47.w,
          padding: EdgeInsets.all(5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(13.r),
            ),
            color: Colors.red,
          ),
          child: Center(
            child: Image.asset(
              AppIcons.delete,
              scale: 2,
            ),
          ),
        ),
      ],
    ),
  );
}
