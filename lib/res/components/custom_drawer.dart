import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/subject_models/subject_model.dart';
import 'package:test_app/core/helper/repos/subject_repo.dart';
import 'package:test_app/res/constants.dart';

import '../../core/block/drawer_cubit/drawer_cubit.dart';

List<SubjectModel> list = [];
final _repo = SubjectRepo();

final _cubit = DrawerCubit();

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key, required this.mainWidth}) : super(key: key);
  final double mainWidth;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    _cubit.getSubs();
  }

  // Future<List<SubjectModel>> getSubs() async {
  //   try {
  //     final response = await _repo.getSubjects();
  //     final rowData = response.data as List;
  //     final rowList = rowData.map((e) => SubjectModel.fromJson(e)).toList();
  //     list.clear();
  //     list.addAll(rowList);
  //     return list;
  //   } on SocketException catch (e) {
  //     print(e.message);
  //   } on DioError catch (e) {
  //     print(e.response!.data["message"]);
  //   } catch (e) {
  //     print(e);
  //   }
  //   return list;
  // }

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
            BlocBuilder<DrawerCubit, DrawerState>(
              builder: (context, state) {
                if (state is OnDrawerSubsReceived) {
                  return Column(
                    children: [
                      for (int i = 0; i < state.subList.length; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              context.read<DrawerCubit>().savePressedIndex(i);
                              context
                                  .read<DrawerCubit>()
                                  .saveSubId(state.subList[i].id!);
                              Navigator.pop(context);
                            });
                          },
                          child: drawerItem(
                            state.subList[i].name!,
                            context.read<DrawerCubit>().getPressedIndex() == i,
                          ),
                        )
                    ],
                  );
                }
                return const Center(
                  child: Text("Iltimos kuting"),
                );
              },
            )
          ],
        ));
  }
}

Widget drawerItem(String text, bool isPressed) {
  return isPressed ? selected(text) : unSelected(text);
}

Widget selected(String text) {
  return Container(
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
  );
}

Widget unSelected(String text) {
  return Container(
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
