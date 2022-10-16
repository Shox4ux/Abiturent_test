import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/ui/bottom_navigation/dtm/dtm.dart';
import 'package:test_app/ui/bottom_navigation/mistakes/mistakes_screen.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile.dart';
import 'package:test_app/ui/bottom_navigation/rating/rating_screen.dart';

import 'package:test_app/ui/bottom_navigation/subjects/subject_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final screens = [
      const SubjectsScreen(),
      const DtmScreen(),
      const ProfileScreen(),
      const MistakesScreen(),
      const RatingScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
              print(selectedIndex);
            });
          },
          currentIndex: selectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.mainColor,
          unselectedItemColor: AppColors.mainColor,
          selectedLabelStyle: AppStyles.subtitleTextStyle.copyWith(
            color: AppColors.mainColor,
            fontSize: 10.sp,
          ),
          unselectedLabelStyle:
              AppStyles.subtitleTextStyle.copyWith(fontSize: 10.sp),
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: bottomBarIcon(
                  AppIcons.sub,
                ),
                activeIcon: bottomBarIcon(
                  AppIcons.subFilled,
                ),
                label: "Fanlar"),
            BottomNavigationBarItem(
                icon: bottomBarIcon(
                  AppIcons.dtm,
                ),
                activeIcon: bottomBarIcon(
                  AppIcons.dtmFilled,
                ),
                label: "Testlar"),
            BottomNavigationBarItem(
                icon: bottomBarIcon(
                  AppIcons.profile,
                ),
                activeIcon: bottomBarIcon(
                  AppIcons.profileFilled,
                ),
                label: "Profile"),
            BottomNavigationBarItem(
                icon: bottomBarIcon(
                  AppIcons.mistakes,
                ),
                activeIcon: bottomBarIcon(
                  AppIcons.mistakesFilled,
                ),
                label: "Xatolar"),
            BottomNavigationBarItem(
                icon: bottomBarIcon(
                  AppIcons.medl,
                ),
                activeIcon: bottomBarIcon(
                  AppIcons.medlFilled,
                ),
                label: "Reyting"),
          ]),
    );
  }
}

Widget mainAppBar() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
    child: Row(
      children: [
        Container(
          height: 17.h,
          width: 23.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppIcons.menu),
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
              "1340",
              style: AppStyles.subtitleTextStyle
                  .copyWith(color: const Color(0xffFCFCFC), fontSize: 24.sp),
            )
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
              "4",
              style: AppStyles.subtitleTextStyle
                  .copyWith(color: const Color(0xffFCFCFC), fontSize: 24.sp),
            ),
            Gap(29.w),
            Container(
              height: 20.h,
              width: 25.w,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppIcons.group),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget bottomBarIcon(String iconPath) {
  return Padding(
    padding: EdgeInsets.only(bottom: 5.h),
    child: Image.asset(
      height: 30.h,
      width: 50.w,
      iconPath,
    ),
  );
}
