import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/subject_models/subject_model.dart';
import 'package:test_app/core/helper/repos/subject_repo.dart';
import 'package:test_app/res/constants.dart';

import '../../core/block/subjecy_bloc/subject_cubit.dart';

List<SubjectModel> list = [];
final _repo = SubjectRepo();

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key, required this.mainWidth}) : super(key: key);
  final double mainWidth;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int? index = 0;

  Future<List<SubjectModel>> getSubs() async {
    final response = await _repo.getSubjects();
    final rowData = response.data as List;

    if (response.statusCode == 200) {
      list.clear();
      for (var element in rowData) {
        list.add(SubjectModel.fromJson(element));
      }
      return list;
    } else {
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: widget.mainWidth * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(50.h),
            Container(
              padding: EdgeInsets.only(left: 20.w),
              alignment: Alignment.centerLeft,
              height: 50.h,
              width: double.maxFinite,
              decoration: const BoxDecoration(
                color: AppColors.mainColor,
              ),
              child: Text(
                "Fanlar",
                style: AppStyles.introButtonText.copyWith(
                  fontSize: 24.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Gap(20.h),
            FutureBuilder(
              future: getSubs(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                }
                return Column(
                  children: [
                    for (int i = 0; i < list.length; i++)
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              index = i;
                              print(i);
                            });
                          },
                          child: drawerItem(list[i].name!, index == i))
                  ],
                );
              },
            )
          ],
        ));
  }

  Widget drawerItem(String text, bool isPressed) {
    return isPressed
        ? Container(
            margin: EdgeInsets.only(bottom: 10.h, right: 30.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            height: 40.h,
            width: double.maxFinite,
            decoration: const BoxDecoration(color: AppColors.mainColor),
            child: Text(
              text,
              style: AppStyles.introButtonText.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.only(bottom: 10.h, right: 30.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            height: 40.h,
            width: double.maxFinite,
            child: Text(
              text,
              style: AppStyles.introButtonText.copyWith(
                color: Colors.black,
                fontSize: 18.sp,
              ),
            ),
          );
  }
}
