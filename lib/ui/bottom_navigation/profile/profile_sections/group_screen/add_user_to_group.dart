import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/bloc/group_cubit/group_cubit.dart';
import '../../../../../core/domain/group_model/group_model.dart';
import '../../../../../res/constants.dart';
import '../../../../../res/components/custom_simple_appbar.dart';
import '../../../../../res/functions/show_toast.dart';
import '../../../../../res/navigation/main_navigation.dart';

class AddUserToGroup extends StatefulWidget {
  const AddUserToGroup({super.key});

  @override
  State<AddUserToGroup> createState() => _AddUserToGroupState();
}

class _AddUserToGroupState extends State<AddUserToGroup> {
  bool? isEmpty;
  var isAdmin = false;

  String? memberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Column(children: [
          CustomSimpleAppBar(
            isIcon: false,
            isSimple: true,
            isImportant: true,
            titleText: "Ishtirokchilar",
            iconColor: Colors.white,
            routeText: RouteNames.group,
            style: AppStyles.subtitleTextStyle.copyWith(
              color: Colors.white,
              fontSize: 24.sp,
            ),
          ),
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
              listener: (context, state) {},
              builder: (context, state) {
                if (state is OnProgress) {
                  return const Center(child: Text("Iltimos kuting..."));
                }

                if (state is OnGroupAdded) {
                  return Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  AppIcons.tab,
                                  scale: 2,
                                ),
                                Gap(15.w),
                                Text(state.model.group!.subjectTitle!,
                                    style: AppStyles.subtitleTextStyle
                                        .copyWith(color: Colors.black))
                              ],
                            ),
                            Gap(5.h),
                            Row(
                              children: [
                                Image.asset(
                                  AppIcons.user,
                                  scale: 2,
                                ),
                                Gap(15.w),
                                Text(
                                    "${state.model.group!.membersCount} ishtirokchi",
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
                            itemCount: state.model.group!.membersArray!.length,
                            itemBuilder: (BuildContext context, int index) {
                              isAdmin = (state.userId ==
                                      state.model.group!.membersArray![index]
                                          .userId &&
                                  state.model.group!.membersArray![index]
                                          .type ==
                                      0);

                              return memberItem(
                                  "${index + 1}",
                                  state.model.group!.membersArray![index],
                                  (state.userId ==
                                          state.model.group!
                                              .membersArray![index].userId &&
                                      state.model.group!.membersArray![index]
                                              .type ==
                                          0),
                                  context,
                                  state.userId);
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: ElevatedButton(
                          style: AppStyles.introUpButton,
                          onPressed: () {
                            openBottomSheet(context, state.model.group!.id!);
                          },
                          child: Text(
                            "Ishtirokchilar qo'shish",
                            style: AppStyles.introButtonText
                                .copyWith(color: const Color(0xffFCFCFC)),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                if (state is OnGroupTapped) {
                  return Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  AppIcons.tab,
                                  scale: 3,
                                ),
                                Gap(10.w),
                                Text(state.group.subjectTitle!,
                                    style: AppStyles.subtitleTextStyle
                                        .copyWith(color: Colors.black))
                              ],
                            ),
                            Gap(5.h),
                            Row(
                              children: [
                                Image.asset(
                                  AppIcons.user,
                                  scale: 3,
                                ),
                                Gap(10.w),
                                Text("${state.group.membersCount} ishtirokchi",
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
                            itemCount: state.group.membersArray!.length,
                            itemBuilder: (BuildContext context, int index) {
                              isAdmin = (state.userId ==
                                      state.group.membersArray![index].userId &&
                                  state.group.membersArray![index].type == 0);

                              return memberItem(
                                  "${index + 1}",
                                  state.group.membersArray![index],
                                  (state.userId ==
                                          state.group.membersArray![index]
                                              .userId &&
                                      state.group.membersArray![index].type ==
                                          0),
                                  context,
                                  state.userId);
                            }),
                      ),
                      isAdmin
                          ? Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: ElevatedButton(
                                style: AppStyles.introUpButton,
                                onPressed: () {
                                  openBottomSheet(context, state.group.id!);
                                },
                                child: Text(
                                  "Ishtirokchi qo’shish",
                                  style: AppStyles.introButtonText
                                      .copyWith(color: const Color(0xffFCFCFC)),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  );
                }
                return const Center(child: Text("Hozircha bu oyna bo'sh"));
              },
            ),
          )),
        ]),
      ),
    );
  }

  Future<dynamic> openBottomSheet(BuildContext context, int groupId) {
    return showModalBottomSheet(
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
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(16.h),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      memberId = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    counter: const SizedBox.shrink(),
                    labelText: "Ishtirokchi ID raqami",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.h),
                      borderSide: BorderSide(color: Colors.red, width: 2.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.h),
                      borderSide: BorderSide(
                          color: AppColors.textFieldBorderColor, width: 2.w),
                    ),
                  ),
                ),
                Gap(16.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<GroupCubit>().addMember(memberId!, groupId);
                  },
                  style: AppStyles.introUpButton,
                  child: Text(
                    "Ishtirokchi qo’shish",
                    style: AppStyles.introButtonText
                        .copyWith(color: const Color(0xffFCFCFC)),
                  ),
                ),
                Gap(16.h),
              ],
            ),
          )),
    );
  }
}

Widget memberItem(String index, MembersArray data, bool isAdmin,
    BuildContext context, int userId) {
  if (isAdmin) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$index)",
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
                    Row(
                      children: [
                        Text(
                          "# ${data.userId.toString()}",
                          style: AppStyles.subtitleTextStyle.copyWith(
                            fontSize: 13.sp,
                          ),
                        ),
                        Gap(10.h),
                        Image.asset(AppIcons.crown, scale: 8),
                      ],
                    ),
                    Text(
                      data.fullname!,
                      style: AppStyles.subtitleTextStyle
                          .copyWith(color: AppColors.smsVerColor),
                    ),
                    Gap(5.h),
                    (data.telegramLink != "-")
                        ? InkWell(
                            onTap: () {
                              _launcher(data.telegramLink!);
                            },
                            child: Text(
                              "${data.telegramLink}",
                              style: AppStyles.subtitleTextStyle.copyWith(
                                fontSize: 13.sp,
                                color: AppColors.mainColor,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.h),
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
        ],
      ),
    );
  }
  return Slidable(
    endActionPane: ActionPane(
      motion: const StretchMotion(),
      children: [
        SlidableAction(
          onPressed: ((context) {
            alertDialog(context, userId, data);
          }),
          icon: Icons.delete,
          backgroundColor: Colors.red,
        )
      ],
    ),
    child: Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
                      "# ${data.userId.toString()}",
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
                  padding: EdgeInsets.all(8.h),
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
        ],
      ),
    ),
  );
}

Future<void> _launcher(String? userTelegram) async {
  final Uri uri = Uri.parse("https://t.me/$userTelegram");
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    showToast("Tizimda nosozlik...");
  }
}

Future<dynamic> alertDialog(
    BuildContext context, int userId, MembersArray data) {
  return showDialog(
    context: context,
    builder: ((context) => AlertDialog(
          title: const Text("Ishtirokchini chiqarmoqchimisiz"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<GroupCubit>().deleteMember(
                          userId,
                          data.id!,
                        );
                  },
                  child: const Text(
                    "Ha",
                    style: TextStyle(
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
              ],
            )
          ],
        )),
  );
}
