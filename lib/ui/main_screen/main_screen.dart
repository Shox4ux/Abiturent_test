import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../res/constants.dart';
import '../bottom_navigation/dtm_test/dtm.dart';
import '../bottom_navigation/mistakes/mistakes_screen.dart';
import '../bottom_navigation/profile/profile.dart';
import '../bottom_navigation/rating/rating_screen.dart';
import '../bottom_navigation/training_tests/subject_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen(this.pageIndex, {super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
  final int? pageIndex;
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 2;
  late StreamSubscription subscription;
  var isInternetConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
    selectedIndex = widget.pageIndex ?? 2;
  }

  getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      isInternetConnected = await InternetConnectionChecker().hasConnection;
      if (!isInternetConnected && isAlertSet == false) {
        showDialogBox();
        setState(() {
          isAlertSet = true;
        });
      }
    });
  }

  showDialogBox() {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Tarmoqda nosozlik"),
        content: const Text("Iltimos internetga ulanishni tekshiring"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context, "Cancel");
              setState(() {
                isAlertSet = false;
              });
              isInternetConnected =
                  await InternetConnectionChecker().hasConnection;
              if (!isInternetConnected && isAlertSet == false) {
                showDialogBox();
                setState(() {
                  isAlertSet = true;
                });
              }
            },
            child: Text(
              "Qaytattan",
              style: AppStyles.mainTextStyle.copyWith(
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

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
          onTap: (int index) async {
            setState(() {
              selectedIndex = index;
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
