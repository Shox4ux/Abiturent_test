import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/block/test_block/test_cubit.dart';
import '../../core/block/drawer_cubit/drawer_cubit.dart';
import '../../res/constants.dart';
import '../bottom_navigation/dtm/dtm.dart';
import '../bottom_navigation/mistakes/mistakes_screen.dart';
import '../bottom_navigation/profile/profile.dart';
import '../bottom_navigation/rating/rating_screen.dart';
import '../bottom_navigation/subjects/subject_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 2;
  final _cubit = TestCubit();
  final _cubit1 = DrawerCubit();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // context.read<SubjectCubit>().getSubjects();
    print("object_uri");
    final screens = [
      SubjectsScreen(
        testType: selectedIndex,
      ),
      const DtmScreen(),
      const ProfileScreen(),
      const MistakesScreen(),
      const RatingScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) async {
            setState(() {
              selectedIndex = index;
              print(selectedIndex);
            });

            if (index == 2) {
              print("Profile");
              // await _cubit.updateProfile();
            }

            if (index == 3) {
              await _cubit.getErrorResult();
            }
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
                  AppIcons.test,
                ),
                activeIcon: bottomBarIcon(
                  AppIcons.testFilled,
                ),
                label: "Testlar"),
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
                label: "Profil"),
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
