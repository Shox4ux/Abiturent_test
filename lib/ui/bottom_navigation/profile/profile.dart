import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/p_h_model/payment_history_model.dart';
import 'package:test_app/core/domain/user_model/stat_model.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/number_formatter.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/refactor/refactor.dart';
import 'package:test_app/ui/main_screen/main_screen.dart';
import '../../../core/bloc/auth_cubit/auth_cubit.dart';
import '../../../core/bloc/drawer_cubit/drawer_cubit.dart';
import '../../../core/bloc/group_cubit/group_cubit.dart';
import '../../../core/bloc/payment_cubit/payment_cubit.dart';
import '../../../core/helper/repos/user_repo.dart';
import '../../../res/enum.dart';
import '../../../res/functions/show_toast.dart';
import '../../../res/navigation/main_navigation.dart';

UserInfo? userData;
final _repo = UserRepo();
List<StatModel>? stats;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isInSubs = false;
  bool isStats = false;
  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 1)) {
      currentBackPressTime = now;
      showToast("Darturdan chiqich uchun tugmani ikki marta bosing");
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Future<List<StatModel>> getStatistics(int? userId) async {
    try {
      if (userId != null) {
        final response = await _repo.getStats(userId);

        if (response.statusCode == 200) {
          final rowData = response.data as List;

          final rowList = rowData.map((e) => StatModel.fromJson(e)).toList();
          stats = rowList;
          return stats!;
        }
      }
      return stats!;
    } catch (e) {
      return stats!;
    }
  }

  @override
  void initState() {
    isStats = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LogedOut) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteNames.signin, (route) => false);
            }
          },
        ),
        BlocListener<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is OnCardsEmpty) {
              Navigator.pushNamed(context, RouteNames.addCard);
            }
            if (state is OnCardsReceived) {
              print(OnCardsReceived);
              Navigator.pushNamed(context, RouteNames.makePayment);
            }
          },
        ),
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<AuthCubit>().getUserData();
        },
        child: Scaffold(
          body: WillPopScope(
            onWillPop: onWillPop,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is OnUserDataProgress) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    if (state is UserActive) {
                      userData = state.userInfo;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push<void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          RefactorScreen(user: userData!),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 100.h,
                                  width: 100.w,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                  child: FadeInImage.assetNetwork(
                                    image: userData!.image ?? "",
                                    fit: BoxFit.cover,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) => Icon(
                                      Icons.person,
                                      size: 64.h,
                                      color: AppColors.mainColor,
                                    ),
                                    placeholder: AppIcons.info,
                                  ),
                                ),
                              ),
                              Gap(10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ID #${userData!.id}",
                                      style:
                                          AppStyles.subtitleTextStyle.copyWith(
                                        fontSize: 14.sp,
                                        color: const Color(0xff0D0E0F),
                                      ),
                                    ),
                                    Text(
                                      "${userData!.fullname}",
                                      overflow: TextOverflow.visible,
                                      style: AppStyles.introButtonText.copyWith(
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
                          GestureDetector(
                            onTap: () async {
                              await context.read<PaymentCubit>().getCards();
                            },
                            child: Container(
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
                                          text: numberFormatter(
                                              userData!.balance),
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
                          ),
                          Gap(20.h),
                          FutureBuilder(
                            future: getStatistics(userData!.id),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.mainColor,
                                  ),
                                );
                              }
                              return Expanded(child: body(stats!));
                            },
                          )
                        ],
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget body(List<StatModel> statList) {
    if (isStats) {
      return statistics(statList);
    }
    return isInSubs ? subs() : menu(context);
  }

  Widget statistics(List<StatModel> statList) {
    if (statList.isEmpty) {
      return const Center(
        child: Text("Fanlarga obuna bo'linmagan..."),
      );
    }
    return ListView.builder(
      itemCount: statList.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              context
                  .read<DrawerCubit>()
                  .chooseStatisticSubjectIdForIndex(statList[index].subjectId!);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(0),
                ),
              );
            },
            child: statisticsItem(statList[index]));
      },
    );
  }

  Widget subs() {
    return Column(
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
                  child: CircularProgressIndicator(color: AppColors.mainColor),
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
              child: Image.asset(AppIcons.sim, scale: 3),
            ),
          ],
        ),
        Gap(5.h),
        Expanded(
          child: ListView(
            children: [
              Container(
                width: 331.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: SingleChildScrollView(
                  child: Column(children: [
                    InkWell(
                      onTap: () async {
                        setState(() {
                          isInSubs = true;
                        });

                        context.read<PaymentCubit>().getPaymentHistory();
                      },
                      child: rowItem(
                          AppIcons.purplePocket, "Mening hisoblarim", false),
                    ),
                    spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                RefactorScreen(user: userData!),
                          ),
                        );
                      },
                      child: rowItem(AppIcons.edit, "Tahrirlash", false),
                    ),
                    spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.news);
                      },
                      child: rowItem(AppIcons.gallery, "Yangiliklar", false),
                    ),
                    spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.subscripts);
                      },
                      child: rowItem(
                          AppIcons.purpleDone, "Mening obunalarim", false),
                    ),
                    spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.group);
                        context.read<GroupCubit>().getGroupsByUserId();
                      },
                      child: rowItem(
                          AppIcons.purpleDone, "Mening guruhlarim", false),
                    ),
                    spacer(),
                    InkWell(
                      onTap: () {
                        context.read<PaymentCubit>().getCards();
                      },
                      child:
                          rowItem(AppIcons.payme, "Hisobni to’ldirish", false),
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
              ),
            ],
          ),
        )
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

Widget statisticsItem(StatModel statModel) {
  return Container(
    margin: EdgeInsets.only(bottom: 10.h),
    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
    ),
    child: Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              statModel.medalImg!,
              width: 48.w,
              height: 48.h,
            ),
            Gap(10.h),
            Text(
              statModel.medalName!,
              style: AppStyles.subtitleTextStyle.copyWith(fontSize: 12.sp),
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
                  fontSize: 18.sp,
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
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        "${statModel.rating}",
                        style: AppStyles.introButtonText
                            .copyWith(color: Colors.green, fontSize: 18.sp),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "So’ngi haftalik:",
                        style: AppStyles.introButtonText.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        "${statModel.ratingWeek}",
                        style: AppStyles.introButtonText
                            .copyWith(color: Colors.black, fontSize: 18.sp),
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
  return Container(
    height: 90.h,
    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
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
        Gap(8.w),
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
              Expanded(
                child: Text(
                  item.content!,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12.sp,
                    color: const Color(0xff161719),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget outHistoryItem(PaymentHistory item) {
  return Container(
    height: 90.h,
    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
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
        Gap(8.w),
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
                    fontWeight: FontWeight.w300,
                    fontSize: 12.sp,
                    color: const Color(0xff161719),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget bonusHistoryItem(PaymentHistory item) {
  return Container(
    height: 90.h,
    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
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
        Gap(8.w),
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
                  fontWeight: FontWeight.w300,
                  fontSize: 12.sp,
                  color: const Color(0xff161719),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
