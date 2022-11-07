import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';

import '../../res/constants.dart';
import '../bottom_navigation/dtm/dtm.dart';
import '../bottom_navigation/mistakes/mistakes_screen.dart';
import '../bottom_navigation/profile/profile.dart';
import '../bottom_navigation/rating/rating_screen.dart';
import '../bottom_navigation/subjects/subject_screen.dart';

class MainScreen1 extends StatefulWidget {
  const MainScreen1({super.key, required this.userInfo});
  final UserInfo userInfo;

  @override
  State<MainScreen1> createState() => _MainScreen1State();
}

class _MainScreen1State extends State<MainScreen1> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // context.read<SubjectCubit>().getSubjects();
    print("object_uri");
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
          unselectedItemColor: AppColors.subtitleColor,
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
