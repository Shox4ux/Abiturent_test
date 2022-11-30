import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/block/group_block/group_cubit.dart';
import 'package:test_app/core/block/payment_cubit/payment_cubit.dart';
import 'package:test_app/core/block/subscription_block/subscription_cubit.dart';
import 'package:test_app/core/domain/p_h_model/payment_history_model.dart';
import 'package:test_app/core/domain/user_model/stat_model.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/number_formatter.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/refactor/refactor.dart';

import '../../../core/block/auth_block/auth_cubit.dart';
import '../../../core/helper/repos/user_repo.dart';
import '../../../res/enum.dart';
import '../../../res/navigation/main_navigation.dart';

UserInfo? user;
final _s = AppStorage();
final _repo = UserRepo();
List<StatModel>? stats;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isInSubs = false;
  bool isStats = true;

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

  Future<List<StatModel>> getStatistics() async {
    try {
      if (user!.id != null) {
        final response = await _repo.getStats(user!.id!);

        if (response.statusCode == 200) {
          final rowData = response.data as List;

          final rowList = rowData.map((e) => StatModel.fromJson(e)).toList();
          stats = rowList;
          return stats!;
        }
      }
      return stats!;
    } catch (e) {
      print(e);
      return stats!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogedOut) {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteNames.signin, (route) => false);
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
                        child: Text("Iltimos kuting..."),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.mainColor,
                                  radius: 50.w,
                                  child: Icon(
                                    Icons.person,
                                    size: 64.h,
                                    color: Colors.white,
                                  ),
                                ),
                                Gap(10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                isStats
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isStats = false;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.settings,
                                          color: AppColors.mainColor,
                                          size: 28.h,
                                        ),
                                      )
                                    : const SizedBox.shrink()
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
                                          text: numberFormatter(user!.balance),
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
                            Gap(20.h),
                            FutureBuilder(
                              future: getStatistics(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.mainColor,
                                    ),
                                  );
                                }
                                return body(stats!);
                              },
                            )
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

  Widget statistics(List<StatModel> statList) {
    if (statList.isEmpty) {
      return const Center(
        child: Text("Obuna sotil oling"),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: statList.length,
        itemBuilder: (context, index) {
          return statisticsItem(statList[index]);
        },
      ),
    );
  }

  Widget body(List<StatModel> statList) {
    if (isStats) {
      return statistics(statList);
    }
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
                    padding: EdgeInsets.only(
                        bottom: 20.h, top: 10.h, right: 10.w, left: 10.w),
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
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isStats = true;
                });
              },
              child: Image.asset(
                AppIcons.sim,
                scale: 3,
              ),
            ),
          ],
        ),
        Gap(5.h),
        Container(
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
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        RefactorScreen(user: user!),
                  ),
                );
              },
              child: rowItem(AppIcons.edit, "Tahrirlash", false),
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
                Navigator.pushNamed(context, RouteNames.group);
                context.read<GroupCubit>().getGroupsByUserId();
              },
              child: rowItem(AppIcons.purpleDone, "Mening guruhlarim", false),
            ),
            spacer(),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteNames.payme);
              },
              child: rowItem(AppIcons.payme, "Hisobni to’ldirish", false),
            ),
            spacer(),
            InkWell(
              onTap: () {
                logOutBottomSheet(context);
              },
              child: rowItem(AppIcons.logout, "Tizimdan chiqish", true),
            ),
          ]),
        ),
      ],
    );
  }

  logOutBottomSheet(BuildContext context) {
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
                        Navigator.pop(context);
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
  }

  Widget rowItem(String imagePath, String text, bool isRed) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 16.w),
      child: Row(
        children: [
          Container(
            height: 48.h,
            width: 48.w,
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

Widget statisticsItem(StatModel statModel) {
  return Container(
    margin: EdgeInsets.only(bottom: 5.h),
    padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 17.w),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14.r)),
    child: Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              statModel.medalImg!,
              width: 36.w,
              height: 36.h,
            ),
            Gap(10.h),
            Text(
              statModel.medalName!,
              style: AppStyles.subtitleTextStyle.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        Gap(40.w),
        Expanded(
          child: Column(
            children: [
              Text(
                "${statModel.subjectText}",
                style: AppStyles.introButtonText.copyWith(
                  color: Colors.black,
                  fontSize: 24.sp,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Umumiy:",
                        style: AppStyles.introButtonText.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        "${statModel.rating}",
                        style: AppStyles.introButtonText
                            .copyWith(color: Colors.green, fontSize: 24.sp),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "So’ngi haftalik:",
                        style: AppStyles.introButtonText.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        "${statModel.ratingWeek}",
                        style: AppStyles.introButtonText
                            .copyWith(color: Colors.black, fontSize: 24.sp),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
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
                        "+${numberFormatter(item.amount)} UZS",
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
                        "-${numberFormatter(item.amount)} UZS",
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
                        "${numberFormatter(item.amount)} UZS",
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
