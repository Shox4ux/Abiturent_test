import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/block/group_block/group_cubit.dart';
import 'package:test_app/core/block/payment_cubit/payment_cubit.dart';
import 'package:test_app/core/block/subjecy_bloc/subject_cubit.dart';
import 'package:test_app/core/block/subscription_block/subscription_cubit.dart';
import 'package:test_app/core/block/test_block/test_cubit.dart';
import 'package:test_app/core/domain/p_h_model/payment_history_model.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/group/group.dart';

import '../../../core/block/auth_block/auth_cubit.dart';
import '../../../core/block/user_block/user_cubit_cubit.dart';
import '../../../core/helper/repos/user_repo.dart';
import '../../../res/enum.dart';
import '../../../res/navigation/main_navigation.dart';
import '../../../res/components/waiting.dart';

UserInfo? user;
final _s = AppStorage();
final _c = UserCubit();
final _repo = UserRepo();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isInSubs = false;

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

  String _medalStatus(int meadalID) {
    print(meadalID);
    if (meadalID == 2) {
      return "Oltin";
    }
    if (meadalID == 1) {
      return "Kumush";
    }
    return "Bronza";
  }

  String _medalAsset(int meadalID) {
    print(0);
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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogedOut) {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteNames.signup, (route) => false);
        }
      },
      child: Scaffold(
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
                child: FutureBuilder(
                  future: getUserData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("Kuting..."),
                      );
                    }
                    return BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is OnAuthProgress) {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.mainColor),
                          );
                        }
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  radius: 48.w,
                                  foregroundImage: const AssetImage(
                                    AppIcons.man,
                                  ),
                                ),
                                Gap(10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "ID #${user!.id}",
                                        style: AppStyles.subtitleTextStyle
                                            .copyWith(
                                          fontSize: 14.sp,
                                          color: const Color(0xff0D0E0F),
                                        ),
                                      ),
                                      Text(
                                        "${user!.fullname}",
                                        overflow: TextOverflow.visible,
                                        style: AppStyles.introButtonText
                                            .copyWith(
                                                fontSize: 24.sp,
                                                color: const Color(0xff161719)),
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(48.w),
                                Column(
                                  children: [
                                    Text(
                                      _medalStatus(user!.medalId!),
                                      style: AppStyles.subtitleTextStyle,
                                    ),
                                    Gap(11.h),
                                    SizedBox(
                                        width: 48.w,
                                        height: 48.h,
                                        child: Image.asset(
                                            _medalAsset(user!.medalId!)))
                                  ],
                                )
                              ],
                            ),
                            Gap(19.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 10.w),
                              height: 52.h,
                              decoration: BoxDecoration(
                                  color: AppColors.greenBackground,
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          text: "${user!.balance}",
                                          style: AppStyles.introButtonText
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 28.sp),
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
                        );
                      },
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }

  Widget body() {
    return isInSubs ? subs() : menu(context);
  }

  Widget subs() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isInSubs = false;
                  });
                },
                child: Image.asset(
                  AppIcons.sim,
                  scale: 3,
                ),
              ),
              Gap(10.w),
              Text(
                "Mening hisoblarim",
                style: AppStyles.introButtonText.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Gap(9.h),
          Expanded(
            child: BlocBuilder<PaymentCubit, PaymentState>(
              builder: (context, state) {
                if (state is OnPayHistoryError) {
                  return Center(
                    child: Text(state.error),
                  );
                }
                if (state is OnPayHistoryProgress) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.mainColor),
                  );
                }

                if (state is OnPayHistoryReceived) {
                  return ListView.separated(
                    padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
                    itemCount: state.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (state.list[index].type == 2) {
                        return Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: bonusHistoryItem(state.list[index]));
                      }
                      if (state.list[index].type == 1) {
                        return Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: outHistoryItem(state.list[index]));
                      }
                      return Padding(
                          padding: EdgeInsets.only(bottom: 5.h),
                          child: inHistoryItem(state.list[index]));
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 6.h),
                  );
                }

                return const Center(child: Text("Hozircha bu oyna bo'sh"));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget menu(BuildContext context) {
    return Container(
      height: 410.h,
      width: 331.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(children: [
        InkWell(
          onTap: () async {
            setState(() {
              isInSubs = true;
            });

            context.read<PaymentCubit>().getPaymentHistory();
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
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.subscripts,
            );

            context.read<SubscriptionCubit>().getScripts();
          },
          child: rowItem(AppIcons.purpleDone, "Mening obunalarim", false),
        ),
        spacer(),
        InkWell(
          onTap: () {
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      const WaitingScreen(status: WarningValues.warning)),
              (Route<dynamic> route) => false,
            );

            context.read<GroupCubit>().getGroupsByUserId();
          },
          child: rowItem(AppIcons.purpleDone, "Mening guruhlarim", false),
        ),
        spacer(),
        InkWell(
          onTap: () {
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      const WaitingScreen(status: WarningValues.warning)),
              (Route<dynamic> route) => false,
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

Widget inHistoryItem(PaymentHistory item) {
  return AspectRatio(
    aspectRatio: 331 / 55,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 11.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0, 5),
          ),
        ],
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
                        item.createdDate!,
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 10.sp,
                            color: const Color(0xff161719)),
                      ),
                      Text(
                        "+${item.amount} UZS",
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
                Expanded(
                  child: Text(
                    item.content!,
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14.sp,
                      color: const Color(0xff161719),
                    ),
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

Widget outHistoryItem(PaymentHistory item) {
  return AspectRatio(
    aspectRatio: 331 / 55,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 11.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 24.h,
            width: 24.w,
            child: Image.asset(Subscriptions.red.iconPath),
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
                        item.createdDate!,
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 10.sp,
                            color: const Color(0xff161719)),
                      ),
                      Text(
                        "-${item.amount} UZS",
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
                Expanded(
                  child: Text(
                    item.content!,
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14.sp,
                      color: const Color(0xff161719),
                    ),
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

Widget bonusHistoryItem(PaymentHistory item) {
  return AspectRatio(
    aspectRatio: 331 / 55,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 11.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 24.h,
            width: 24.w,
            child: Image.asset(Subscriptions.purple.iconPath),
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
                        item.createdDate!,
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 10.sp,
                            color: const Color(0xff161719)),
                      ),
                      Text(
                        "${item.amount} UZS",
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
