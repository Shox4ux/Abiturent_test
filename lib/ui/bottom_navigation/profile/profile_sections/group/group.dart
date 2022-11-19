import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/block/group_block/group_cubit.dart';
import 'package:test_app/core/domain/group_model/group_item.dart';
import 'package:test_app/core/domain/group_model/group_model.dart';
import 'package:test_app/res/components/custom_simple_appbar.dart';
import 'package:test_app/res/navigation/main_navigation.dart';

import '../../../../../core/domain/subject_models/subject_model.dart';
import '../../../../../core/helper/repos/subject_repo.dart';
import '../../../../../res/constants.dart';

List<SubjectModel> subjectList = [];
List<String> subNameList = [];
String? groupName;

String hintText = "Fanni tanlang";

final _repo = SubjectRepo();
final groupsList = [];

class GroupScreen extends StatefulWidget {
  const GroupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  String? dropValue;

  @override
  void initState() {
    super.initState();
    getSubsTitle();
  }

  Future<List<SubjectModel>> getSubsTitle() async {
    final response = await _repo.getSubjects();
    final rowData = response.data as List;
    if (response.statusCode == 200) {
      subjectList.clear();
      for (var element in rowData) {
        subjectList.add(SubjectModel.fromJson(element));
      }
      subNameList.clear();
      for (var y in subjectList) {
        subNameList.add(y.name!);
      }
      dropValue = subNameList.first;
      return subjectList;
    } else {
      return subjectList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state is OnSuccess) {
          Navigator.of(context).pushNamed(
            RouteNames.addMembers,
          );
        }
        if (state is OnError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }

        if (state is OnGroupTapped) {
          Navigator.of(context).pushNamed(
            RouteNames.addMembers,
          );
        }
      },
      child: Scaffold(
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
                  width: double.maxFinite,
                  padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
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
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.mainColor,
                          ),
                        );
                      }
                      if (state is OnGroupsReceived) {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 20),
                                itemCount: state.groupList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                      onTap: () {
                                        context
                                            .read<GroupCubit>()
                                            .getGroupMembers(
                                                state.groupList[index].id!);
                                      },
                                      child: groupItem(state.groupList[index]));
                                },
                              ),
                            ),
                            Gap(10.h),
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
                                  builder: ((context) =>
                                      StatefulBuilder(builder: (context, sts) {
                                        return Padding(
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
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 4.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 2.w),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.r),
                                                ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    // Initial Value
                                                    isExpanded: true,
                                                    value: dropValue,
                                                    // Down Arrow Icon
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    // Array list of items
                                                    items: subNameList
                                                        .map((String items) {
                                                      return DropdownMenuItem(
                                                        value: items,
                                                        child: Text(items),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      dropValue = newValue!;
                                                      sts.call(() {});
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Gap(16.h),
                                              TextField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    groupName = value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  counter:
                                                      const SizedBox.shrink(),
                                                  labelText: "Guruh nomi",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.h),
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 2.w),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.h),
                                                    borderSide: BorderSide(
                                                        color: AppColors
                                                            .textFieldBorderColor,
                                                        width: 2.w),
                                                  ),
                                                ),
                                              ),
                                              Gap(16.h),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  context
                                                      .read<GroupCubit>()
                                                      .creatGroup(
                                                          dropValue!,
                                                          subjectList,
                                                          groupName!);
                                                },
                                                style: AppStyles.introUpButton,
                                                child: Text(
                                                  "Yaratish",
                                                  style: AppStyles
                                                      .introButtonText
                                                      .copyWith(
                                                          color: const Color(
                                                              0xffFCFCFC)),
                                                ),
                                              ),
                                              Gap(16.h),
                                            ],
                                          ),
                                        );
                                      })),
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
                        );
                      }
                      return const Center(
                        child: Text("Iltimos kuting..."),
                      );
                    },
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}

// Widget groupItem(GroupModel groupItem) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Gap(6.h),
//       Text(
//         "${groupItem.group!.subjectTitle} fani",
//         style: AppStyles.introButtonText.copyWith(
//           color: AppColors.smsVerColor,
//         ),
//       ),
//       Gap(13.h),
//       Column(
//         children: [
//           for (var i = 0; i < 3; i++) groupMemberItem(),
//         ],
//       )
//     ],
//   );
// }

Widget groupItem(GroupItem item) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    item.title!,
                    style: AppStyles.subtitleTextStyle.copyWith(
                      color: AppColors.smsVerColor,
                    ),
                  ),
                  Gap(10.w),
                  Text(
                    "${item.memberCount} ishtirokchi",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              Gap(13.h),
              Row(
                children: [
                  Text(
                    "Yaratilgan sana:",
                    style: AppStyles.subtitleTextStyle.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),
                  Gap(10.w),
                  Text(
                    item.created!,
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
