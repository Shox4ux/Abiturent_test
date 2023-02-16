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

class InsideGroup extends StatefulWidget {
  const InsideGroup({super.key});

  @override
  State<InsideGroup> createState() => _InsideGroupState();
}

class _InsideGroupState extends State<InsideGroup> {
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
            child: BlocBuilder<GroupCubit, GroupState>(
              builder: (context, state) {
                if (state is OnProgress) {
                  return const Center(child: Text("Iltimos kuting..."));
                }
                if (state is OnInsideGroup) {
                  final isAdmin = state.isAdmin;
                  return _onInsideGroup(state.group, isAdmin, context);
                }
                return const Center(child: Text("Iltimos kuting..."));
              },
            ),
          )),
        ]),
      ),
    );
  }

  Widget _onInsideGroup(Group group, bool isAdmin, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    AppIcons.tab,
                    scale: 3,
                  ),
                  Gap(10.w),
                  Text(group.subjectTitle!,
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
                  Text("${group.membersCount} ishtirokchi",
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
              itemCount: group.membersArray!.length,
              itemBuilder: (BuildContext context, int index) {
                return memberItem(
                  "${index + 1}",
                  group.membersArray![index],
                  isAdmin,
                  group.ownerId!,
                );
              }),
        ),
        isAdmin
            ? Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: ElevatedButton(
                  style: AppStyles.introUpButton,
                  onPressed: () {
                    openBottomSheet(context, group.id!);
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

Widget memberItem(String index, MembersArray data, bool isAdmin, int ownerId) {
  if (isAdmin) {
    if (ownerId == data.userId) {
      return _unDeletableMember(ownerId, data, index);
    } else {
      return _deletableMember(ownerId, data, index);
    }
  } else {
    return _unDeletableMember(ownerId, data, index);
  }
}

Container _unDeletableMember(
    int ownerId, MembersArray memberData, String index) {
  final isOwner = ownerId == memberData.userId;
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
                  isOwner
                      ? Row(
                          children: [
                            Text(
                              "# ${memberData.userId.toString()}",
                              style: AppStyles.subtitleTextStyle.copyWith(
                                fontSize: 13.sp,
                              ),
                            ),
                            Gap(10.h),
                            Image.asset(AppIcons.crown, scale: 8),
                          ],
                        )
                      : Text(
                          "# ${memberData.userId.toString()}",
                          style: AppStyles.subtitleTextStyle.copyWith(
                            fontSize: 13.sp,
                          ),
                        ),
                  Text(
                    memberData.fullname!,
                    style: AppStyles.subtitleTextStyle
                        .copyWith(color: AppColors.smsVerColor),
                  ),
                  Gap(5.h),
                  (memberData.telegramLink != "-")
                      ? InkWell(
                          onTap: () {
                            _launcher(
                                memberData.telegramLink!.replaceAll("@", ""));
                          },
                          child: Text(
                            "${memberData.telegramLink}",
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
                    "${memberData.rating} ball",
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

Slidable _deletableMember(int userId, MembersArray memberData, String index) {
  final isOwner = userId == memberData.userId;
  return Slidable(
    endActionPane: ActionPane(
      motion: const StretchMotion(),
      children: [
        SlidableAction(
          onPressed: ((context) {
            alertDialog(context, userId, memberData);
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
                    isOwner
                        ? Row(
                            children: [
                              Text(
                                "# ${memberData.userId.toString()}",
                                style: AppStyles.subtitleTextStyle.copyWith(
                                  fontSize: 13.sp,
                                ),
                              ),
                              Gap(10.h),
                              Image.asset(AppIcons.crown, scale: 8),
                            ],
                          )
                        : Text(
                            "# ${memberData.userId.toString()}",
                            style: AppStyles.subtitleTextStyle.copyWith(
                              fontSize: 13.sp,
                            ),
                          ),
                    Text(
                      memberData.fullname!,
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
                      "${memberData.rating} ball",
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
          title: const Text("Ishtirokchini chiqarmoqchimisiz?"),
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
