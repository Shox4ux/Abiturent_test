import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';
import '../../core/bloc/drawer_cubit/drawer_cubit.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key, required this.mainWidth}) : super(key: key);
  final double mainWidth;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: widget.mainWidth * 0.7,
      child: ColoredBox(
        color: AppColors.mainColor,
        child: SafeArea(
          child: ColoredBox(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    if (state is DrawerInitial || state is OnDrawerProgress) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }
                    if (state is DrawerSubjectsLoadedState) {
                      final selectedIndex = state.selectedSubjectIndex;
                      final subjectList = state.subjectList;

                      return Expanded(
                        child: ListView.builder(
                          itemCount: subjectList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                context.read<DrawerCubit>().chooseSubject(
                                    index, subjectList[index].id!);
                                Navigator.pop(context);
                              },
                              child: drawerItem(
                                subjectList[index].name!,
                                _decider(selectedIndex, index),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const Center(
                      child: Text("Horizcha buyer bo'sh"),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool _decider(int? state, int i) {
  if (state == null) {
    return 0 == i;
  } else {
    return state == i;
  }
}

Widget drawerItem(String text, bool isSelected) {
  return isSelected ? selected(text) : unSelected(text);
}

Widget selected(String text) {
  return Container(
    margin: EdgeInsets.only(bottom: 10.h, right: 30.w),
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
    width: double.maxFinite,
    decoration: const BoxDecoration(color: AppColors.mainColor),
    child: Text(
      text,
      textAlign: TextAlign.start,
      style: AppStyles.introButtonText.copyWith(
        color: Colors.white,
        fontSize: 16.sp,
      ),
    ),
  );
}

Widget unSelected(String text) {
  return Container(
    margin: EdgeInsets.only(bottom: 10.h, right: 30.w),
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
    width: double.maxFinite,
    child: Text(
      text,
      style: AppStyles.introButtonText.copyWith(
        color: Colors.black,
        fontSize: 16.sp,
      ),
    ),
  );
}
