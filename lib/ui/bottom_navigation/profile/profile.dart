import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/res/constants.dart';

import '../../../core/block/auth_block/auth_cubit.dart';
import '../../../res/enum.dart';
import '../../navigation/main_navigation.dart';

UserInfo? userInfo;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isInSubs = false;

  String _medalStatus(int meadalID) {
    if (meadalID == 2) {
      return "Oltin";
    }
    if (meadalID == 1) {
      return "Kumush";
    }
    return "Bronza";
  }

  String _medalAsset(int meadalID) {
    if (meadalID == 2) {
      return AppIcons.gold;
    }
    if (meadalID == 1) {
      return AppIcons.silver;
    }
    return AppIcons.bronze;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          setState(() {
            isInSubs = false;
          });
          return false;
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is UserActive) {
                    userInfo = state.userInfo;
                    print("profile");
                  }
                  if (state is LogedOut) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Good luck man!",
                        ),
                      ),
                    );
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteNames.signup, (Route<dynamic> route) => false);
                  }

                  if (state is AuthDenied) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                      ),
                    );
                  }
                },
                child: Column(
                  children: [
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 42.w,
                            foregroundImage: const AssetImage(
                              AppIcons.man,
                            ),
                          ),
                          Gap(5.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ID #${userInfo!.id}",
                                style: AppStyles.subtitleTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  color: const Color(0xff0D0E0F),
                                ),
                              ),
                              Gap(4.h),
                              Text(
                                "${userInfo!.fullname}",
                                style: AppStyles.introButtonText.copyWith(
                                    fontSize: 24.sp,
                                    color: const Color(0xff161719)),
                              ),
                            ],
                          ),
                          Gap(48.w),
                          Column(
                            children: [
                              Text(
                                _medalStatus(userInfo!.medalId!),
                                style: AppStyles.subtitleTextStyle,
                              ),
                              Gap(11.h),
                              SizedBox(
                                  width: 48.w,
                                  height: 48.h,
                                  child: Image.asset(
                                      _medalAsset(userInfo!.medalId!)))
                            ],
                          )
                        ],
                      ),
                    ),
                    Gap(19.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      height: 52.h,
                      decoration: BoxDecoration(
                          color: AppColors.greenBackground,
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40.h,
                            width: 52.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Image.asset(
                              AppIcons.greenPocket,
                              scale: 3.h,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: "UZS ",
                              style: AppStyles.introButtonText.copyWith(
                                  color: Colors.white, fontSize: 14.sp),
                              children: [
                                TextSpan(
                                  text: "${userInfo!.balance}",
                                  style: AppStyles.introButtonText.copyWith(
                                      color: Colors.white, fontSize: 28.sp),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Gap(25.h),
                    body()
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget body() {
    return isInSubs ? subs() : menu();
  }

  Widget subs() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mening hisoblarim",
            style: AppStyles.introButtonText.copyWith(
              color: Colors.black,
            ),
          ),
          Gap(9.h),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 20.h),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return subcriptionsItem();
              },
              separatorBuilder: (context, index) => SizedBox(height: 6.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget menu() {
    return Container(
      height: 410.h,
      width: 331.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(children: [
        InkWell(
          onTap: () {
            setState(() {
              print("object true");
              isInSubs = true;
            });
          },
          child: rowItem(AppIcons.purplePocket, "Mening hisoblarim", false),
        ),
        spacer(),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.news,
            );
          },
          child: rowItem(AppIcons.gallery, "Yangiliklar", false),
        ),
        spacer(),
        InkWell(
          onTap: () {},
          child: rowItem(AppIcons.purpleDone, "Mening obunalarim", false),
        ),
        spacer(),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.group,
            );
          },
          child: rowItem(AppIcons.purpleDone, "Mening guruhlarim", false),
        ),
        spacer(),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.group,
            );
          },
          child: rowItem(AppIcons.payme, "Hisobni to’ldirish", false),
        ),
        spacer(),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  16.r,
                ),
              )),
              context: context,
              builder: ((context) => Padding(
                    padding: EdgeInsets.all(20.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 36.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                              color: const Color(0xffD3BDFF),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.r),
                                topLeft: Radius.circular(20.r),
                              )),
                        ),
                        Gap(20.h),
                        Text(
                          "Tizimda chiqish xoxlaysizmi ?",
                          style: AppStyles.introButtonText.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Gap(20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 56.h,
                                width: 150.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16.r),
                                  ),
                                ),
                                child: Text(
                                  "Yo'q",
                                  style: AppStyles.introButtonText
                                      .copyWith(color: AppColors.mainColor),
                                ),
                              ),
                            ),
                            Gap(16.w),
                            InkWell(
                              onTap: () async {
                                await context.read<AuthCubit>().authLogOut();
                              },
                              child: Container(
                                height: 56.h,
                                width: 150.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16.r),
                                  ),
                                ),
                                child: Text(
                                  "Ha",
                                  style: AppStyles.introButtonText
                                      .copyWith(color: AppColors.fillingColor),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            );
          },
          child: rowItem(AppIcons.logout, "Tizimdan chiqish", true),
        ),
      ]),
    );
  }

  Widget rowItem(String imagePath, String text, bool isRed) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 16.w),
      child: Row(
        children: [
          Container(
            height: 52.h,
            width: 52.w,
            decoration: BoxDecoration(
              color: isRed ? const Color(0xffFFE2E4) : AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Image.asset(
              imagePath,
              scale: 3.h,
            ),
          ),
          Gap(9.w),
          Text(
            text,
            style: AppStyles.subtitleTextStyle.copyWith(
              color: const Color(0xff292B2D),
            ),
          )
        ],
      ),
    );
  }

  Widget spacer() {
    return Container(
      color: AppColors.backgroundColor,
      height: 2.h,
      width: double.maxFinite,
    );
  }
}

Widget subcriptionsItem() {
  return AspectRatio(
    aspectRatio: 331 / 55,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 11.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 24.h,
            width: 24.w,
            child: Image.asset(Subscriptions.green.iconPath),
          ),
          Gap(11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "11.01.2022",
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 10.sp,
                            color: const Color(0xff161719)),
                      ),
                      // Gap(80.w),
                      Text(
                        "+2 200 000 UZS",
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 14.sp,
                          color: const Color(0xff161719),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(4.h),
                Text(
                  Subscriptions.green.text,
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 14.sp,
                    color: const Color(0xff161719),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
