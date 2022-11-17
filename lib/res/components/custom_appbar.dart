import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/navigation/main_navigation.dart';

import '../../core/block/group_block/group_cubit.dart';
import '../../core/domain/user_model/user_model.dart';
import '../../core/helper/database/app_storage.dart';
import '../../core/helper/repos/user_repo.dart';
import '../constants.dart';

UserInfo? user;
final _s = AppStorage();

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key, required this.scaffKey});

  final GlobalKey<ScaffoldState> scaffKey;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

final _repo = UserRepo();

class _CustomAppBarState extends State<CustomAppBar> {
  Future<UserInfo> getUserData() async {
    final e = await _s.getUserInfo();
    if (e.id != null) {
      final rowData = await _repo.getUserProfile(e.id!);

      if (rowData.statusCode == 200) {
        final y = UserInfo.fromJson(rowData.data);

        user = y;

        return user!;
      }
      return user!;
    }
    return user!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return customAppBar(widget.scaffKey, context, "...", "...");
        }
        return customAppBar(
          widget.scaffKey,
          context,
          user!.rating.toString(),
          user!.ratingMonth.toString(),
        );
      },
    );
  }

  Widget customAppBar(
    GlobalKey<ScaffoldState> scafKey,
    BuildContext context,
    String? rating,
    String? ratingMonth,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
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
