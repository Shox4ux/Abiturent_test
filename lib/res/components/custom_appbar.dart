import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/group/group.dart';

import '../../core/block/drawer_cubit/drawer_cubit.dart';
import '../../core/domain/user_model/user_model.dart';
import '../../core/helper/database/app_storage.dart';
import '../constants.dart';

UserInfo? user;
final _s = AppStorage();

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key, required this.scaffKey});

  final GlobalKey<ScaffoldState> scaffKey;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

final _cubit = DrawerCubit();

class _CustomAppBarState extends State<CustomAppBar> {
  Future<UserInfo> getUserData() async {
    final e = await _s.getUserInfo();
    if (e.id != null) {
      user = e;
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
        return customAppBar(widget.scaffKey, context, user!.rating.toString(),
            user!.ratingMonth.toString());
      },
    );
  }
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
      children: [
        InkWell(
          onTap: () {
            scafKey.currentState?.openDrawer();
          },
          child: Container(
            height: 17.h,
            width: 23.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppIcons.menu),
              ),
            ),
          ),
        ),
        Gap(100.w),
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
              style: AppStyles.subtitleTextStyle
                  .copyWith(color: const Color(0xffFCFCFC), fontSize: 24.sp),
            ),
          ],
        ),
        Gap(16.w),
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
              style: AppStyles.subtitleTextStyle
                  .copyWith(color: const Color(0xffFCFCFC), fontSize: 24.sp),
            ),
            Gap(29.w),
            InkWell(
              onTap: () {},
              child: Container(
                height: 20.h,
                width: 25.w,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppIcons.group),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
