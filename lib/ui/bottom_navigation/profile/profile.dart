import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/bloc/news_cubit/news_cubit.dart';
import 'package:test_app/core/bloc/statistics_cubit/statistics_cubit.dart';
import 'package:test_app/core/bloc/user_cubit/user_cubit.dart';
import 'package:test_app/core/domain/p_h_model/payment_history_model.dart';
import 'package:test_app/core/domain/user_model/stat_model.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/number_formatter.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/refactor/refactor.dart';
import 'package:test_app/ui/bottom_navigation/profile/widgets/payment_history_widger.dart';
import 'package:test_app/ui/bottom_navigation/profile/widgets/profile_menu_item.dart';
import 'package:test_app/ui/bottom_navigation/profile/widgets/statistics_widget.dart';
import 'package:test_app/ui/main_screen/main_screen.dart';
import '../../../core/bloc/auth_cubit/auth_cubit.dart';
import '../../../core/bloc/drawer_cubit/drawer_cubit.dart';
import '../../../core/bloc/group_cubit/group_cubit.dart';
import '../../../core/bloc/payment_cubit/payment_cubit.dart';
import '../../../res/enum.dart';
import '../../../res/functions/show_toast.dart';
import '../../../res/navigation/main_navigation.dart';

UserInfo? userData;

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
      showToast("Dasturdan chiqich uchun tugmani ikki marta bosing");
      return Future.value(false);
    } else {
      return Future.value(true);
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
            if (state is OnLogOut) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteNames.signin, (route) => false);
            }
          },
        ),
        BlocListener<UserCubit, UserState>(
          listener: (context, state) {
            if (state is OnUserDeleted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteNames.intro, (route) => false);
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
                                      icon: context
                                              .watch<NewsCubit>()
                                              .shouldNotifyProfile
                                          ? Stack(
                                              children: [
                                                Icon(
                                                  Icons.settings,
                                                  color: AppColors.mainColor,
                                                  size: 28.h,
                                                ),
                                                CircleAvatar(
                                                  radius: 3.h,
                                                  backgroundColor: Colors.red,
                                                )
                                              ],
                                            )
                                          : Icon(
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
                          BlocBuilder<StatisticsCubit, StatisticsState>(
                            builder: (context, state) {
                              if (state is OnStatsSuccess) {
                                return Expanded(
                                  child: body(state.statsList),
                                );
                              }
                              if (state is OnStatsProgress) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.mainColor,
                                  ),
                                );
                              }
                              if (state is OnStatsError) {
                                return isInSubs
                                    ? Center(child: Text(state.message))
                                    : menu(context);
                              }

                              return const Center(
                                child: Text(
                                    "Fanlarga bo`yicha obunalar mavjud emas..."),
                              );
                            },
                          ),
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
      return statList.isNotEmpty
          ? statistics(statList)
          : const Center(
              child: Text("Fanlarga bo`yicha obunalar mavjud emas..."),
            );
    } else {
      return isInSubs ? subs() : menu(context);
    }
  }

  Widget statistics(List<StatModel> statList) {
    return ListView.builder(
      itemCount: statList.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              context.read<DrawerCubit>().chooseStatisticSubjectIdForIndex(
                  index, statList[index].subjectId!);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(0),
                ),
              );
            },
            child: StatisticsWidget(statModel: statList[index]));
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
                final historyList = state.list;
                return ListView.separated(
                  padding: EdgeInsets.only(
                      bottom: 20.h, top: 10.h, right: 10.w, left: 10.w),
                  itemCount: historyList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return historyItem(historyList[index], index);
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 6.h),
                );
              }

              return const Center(child: Text("Hozircha bu oyna bo'sh..."));
            },
          ),
        ),
      ],
    );
  }

  Widget historyItem(PaymentHistory historyItem, int index) {
    if (historyItem.type == PaymentHistoryConsts.income) {
      return PaymentHistoryWidget(
          item: historyItem, type: Subscriptions.income);
    }
    if (historyItem.type == PaymentHistoryConsts.expense) {
      return PaymentHistoryWidget(
          item: historyItem, type: Subscriptions.expense);
    }
    return PaymentHistoryWidget(item: historyItem, type: Subscriptions.bonus);
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
                      child: const ProfileMenuItem(
                        imagePath: AppIcons.purplePocket,
                        text: "Mening hisoblarim",
                        isRed: false,
                        withNotification: false,
                      ),
                      // child: rowItem(
                      //     AppIcons.purplePocket, "Mening hisoblarim", false),
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
                      child: const ProfileMenuItem(
                        imagePath: AppIcons.edit,
                        text: "Tahrirlash",
                        isRed: false,
                        withNotification: false,
                      ),
                    ),
                    spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.news);
                      },
                      child: context.watch<NewsCubit>().shouldNotifyProfile
                          ? const ProfileMenuItem(
                              imagePath: AppIcons.gallery,
                              text: "Yangiliklar",
                              isRed: false,
                              withNotification: true,
                            )
                          : const ProfileMenuItem(
                              imagePath: AppIcons.gallery,
                              text: "Yangiliklar",
                              isRed: false,
                              withNotification: false,
                            ),
                    ),
                    spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.subscripts);
                      },
                      child: const ProfileMenuItem(
                        imagePath: AppIcons.purpleDone,
                        text: "Mening obunalarim",
                        isRed: false,
                        withNotification: false,
                      ),
                    ),
                    spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.group);
                        context.read<GroupCubit>().getGroupsByUserId();
                      },
                      child: const ProfileMenuItem(
                        imagePath: AppIcons.purpleDone,
                        text: "Mening guruhlarim",
                        isRed: false,
                        withNotification: false,
                      ),
                    ),
                    spacer(),
                    InkWell(
                      onTap: () {
                        context.read<PaymentCubit>().getCards();
                      },
                      child: const ProfileMenuItem(
                        imagePath: AppIcons.payme,
                        text: "Hisobni to’ldirish",
                        isRed: false,
                        withNotification: false,
                      ),
                    ),
                    spacer(),
                    InkWell(
                      onTap: () {
                        alertBottomSheet(context, isLogout: true);
                      },
                      child: const ProfileMenuItem(
                        imagePath: AppIcons.logout,
                        text: "Tizimdan chiqish",
                        isRed: true,
                        withNotification: false,
                      ),
                    ),
                    spacer(),
                    InkWell(
                      onTap: () {
                        alertBottomSheet(context, isLogout: false);
                      },
                      child: const ProfileMenuItem(
                        imagePath: AppIcons.delete,
                        text: "Akauntni o`chirish",
                        isRed: true,
                        withNotification: false,
                      ),
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

  alertBottomSheet(BuildContext context, {required bool isLogout}) {
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
                  isLogout
                      ? "Tizimdan chiqish xoxlaysizmi ?"
                      : "Barcha ma`lumotlaringiz (obunalar, guruhlar, ratinglar...) o`chirilishga rozilig berasizmi?",
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

                        if (isLogout) {
                          await context.read<AuthCubit>().authLogOut();
                        } else {
                          await context.read<UserCubit>().deleteUser();
                        }
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

  Widget rowItem({
    required String imagePath,
    required String text,
    required bool isRed,
    required bool withNotification,
  }) {
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
            child: isRed
                ? Image.asset(imagePath, scale: 3.h, color: Colors.red)
                : Image.asset(imagePath, scale: 3.h),
          ),
          Gap(9.w),
          Text(text,
              style: AppStyles.subtitleTextStyle
                  .copyWith(color: const Color(0xff292B2D)))
        ],
      ),
    );
  }

  Widget spacer() {
    return Container(
        color: AppColors.backgroundColor, height: 2.h, width: double.maxFinite);
  }
}
