import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/bloc/app_bar_cubit/app_bar_cubit.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import '../../core/bloc/drawer_cubit/drawer_cubit.dart';
import '../../core/bloc/group_cubit/group_cubit.dart';
import '../constants.dart';

class CustomAppBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffKey;
  const CustomAppBar({super.key, required this.scaffKey});
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerCubit, DrawerState>(
      builder: (context, state) {
        if (state is DrawerSubjectsLoadedState) {
          final selectedSubjectId = state.selectedSubjectId;
          context.read<AppBarCubit>().getRatingBySubject(selectedSubjectId);
        }
        return BlocBuilder<AppBarCubit, AppBarState>(
          builder: (context, state) {
            if (state is OnAppBarRatingReceived) {
              final ratingData = state.model;
              return customAppBar(
                widget.scaffKey,
                context,
                ratingData.ratingDay.toString(),
                ratingData.ratingWeek.toString(),
              );
            }
            if (state is OnAppBarRatingError) {
              showToast(state.error);
              return customAppBar(widget.scaffKey, context, "0", "0");
            }
            if (state is OnAppBarRatingEmpty) {
              return customAppBar(widget.scaffKey, context, "0", "0");
            }
            return customAppBar(widget.scaffKey, context, "", "");
          },
        );
      },
    );
  }

  Widget customAppBar(GlobalKey<ScaffoldState> scafKey, BuildContext context,
      String? rating, String? ratingMonth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              scafKey.currentState?.openDrawer();
            },
            icon: Image.asset(
              AppIcons.menu,
              scale: 3,
            ),
          ),
          Row(
            children: [
              Row(
                children: [
                  Container(
                    height: 17.h,
                    width: 23.w,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppIcons.check),
                      ),
                    ),
                  ),
                  Gap(8.w),
                  Text(
                    rating!,
                    style: AppStyles.subtitleTextStyle.copyWith(
                        color: const Color(0xffFCFCFC), fontSize: 24.sp),
                  ),
                ],
              ),
              Gap(20.w),
              Row(
                children: [
                  Container(
                    height: 19.h,
                    width: 19.w,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppIcons.clock),
                      ),
                    ),
                  ),
                  Gap(7.w),
                  Text(
                    ratingMonth!,
                    style: AppStyles.subtitleTextStyle.copyWith(
                        color: const Color(0xffFCFCFC), fontSize: 24.sp),
                  ),
                ],
              ),
              Gap(20.w),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.group);
                  context.read<GroupCubit>().getGroupsByUserId();
                },
                icon: Image.asset(
                  AppIcons.group,
                  height: 20.h,
                  width: 25.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
