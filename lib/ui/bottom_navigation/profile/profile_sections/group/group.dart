import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/block/group_block/group_cubit.dart';
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
  const GroupScreen({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  String? dropValue;

  Future<List<dynamic>> getGroups() async {
    return groupsList;
  }

  Future<List<SubjectModel>> getSubsTitle() async {
    final response = await _repo.getSubjects();
    final rowData = response.data as List;
//
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
      //

//

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
                      if (state is OnGroupsReceived) {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 20),
                                itemCount: state.groupList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return groupItem();
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
                                            BlocBuilder<GroupCubit, GroupState>(
                                              builder: (context, state) {
                                                if (state is OnProgress) {
                                                  return const CircularProgressIndicator(
                                                    color: AppColors.mainColor,
                                                  );
                                                }
                                                return ElevatedButton(
                                                  onPressed: () async {
                                                    // context
                                                    //     .read<GroupCubit>()
                                                    //     .creatGroup(
                                                    //         widget.userId,
                                                    //         dropValue!,
                                                    //         subList,
                                                    //         groupTitle);

                                                    Navigator.pushNamed(
                                                      context,
                                                      RouteNames.addMembers,
                                                    );
                                                  },
                                                  style:
                                                      AppStyles.introUpButton,
                                                  child: Text(
                                                    "Yaratish",
                                                    style: AppStyles
                                                        .introButtonText
                                                        .copyWith(
                                                            color: const Color(
                                                                0xffFCFCFC)),
                                                  ),
                                                );
                                              },
                                            ),
                                            Gap(16.h),
                                          ],
                                        ),
                                      )),
                                );
                                ;
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
                        child: Text("Loading..."),
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

DropdownMenuItem dropItems(String value) {
  return DropdownMenuItem(child: Text(value));
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
