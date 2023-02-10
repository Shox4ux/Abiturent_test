import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/user_model/rating_model.dart';
import 'package:test_app/res/components/custom_drawer.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/bloc/drawer_cubit/drawer_cubit.dart';
import '../../../core/bloc/rating_cubit/rating_cubit.dart';
import '../../../res/constants.dart';
import '../../../res/components/custom_appbar.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);
  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    var currentSubjectId = 0;
    final GlobalKey<ScaffoldState> scaffKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;

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

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<RatingCubit>().callUserRating(currentSubjectId);
      },
      child: Scaffold(
        backgroundColor: AppColors.mainColor,
        key: scaffKey,
        drawer: CustomDrawer(mainWidth: screenWidth),
        body: WillPopScope(
          onWillPop: () async {
            return await onWillPop();
          },
          child: SafeArea(
            child: Column(children: [
              CustomAppBar(scaffKey: scaffKey),
              BlocBuilder<DrawerCubit, DrawerState>(
                builder: (context, state) {
                  if (state is DrawerSubjectsLoadedState) {
                    currentSubjectId = state.selectedSubjectId;
                    context
                        .read<RatingCubit>()
                        .callUserRating(currentSubjectId);
                  }
                  return Expanded(
                    child: Container(
                      width: double.maxFinite,
                      padding:
                          EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(28.r),
                          topRight: Radius.circular(28.r),
                        ),
                      ),
                      child: BlocBuilder<RatingCubit, RatingState>(
                        builder: (context, state) {
                          if (state is OnRatingReceived) {
                            final ratingData = state.ratingModel;
                            return _onRating(ratingData);
                          }
                          if (state is OnRatingEmpty) {
                            return _onRatingEmpty(state.ratingModel);
                          }
                          if (state is OnRatingProgress) {
                            return _onProgress();
                          }
                          return _onProgress();
                        },
                      ),
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _onProgress() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget _onRatingEmpty(RatingModel ratingData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Umumiy reyting",
          style: AppStyles.introButtonText.copyWith(
            color: Colors.black,
          ),
        ),
        Row(
          children: [
            Image.asset(
              AppIcons.medlFilled,
              width: 24.w,
              height: 24.h,
            ),
            Gap(10.h),
            Expanded(
              child: Text(
                "${ratingData.subjectText} fani",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Hozircha ishtirokchilar mavjud emas...",
            ),
          ),
        )
      ],
    );
  }

  Widget _onRating(RatingModel ratingData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Umumiy reyting",
          style: AppStyles.introButtonText.copyWith(
            color: Colors.black,
          ),
        ),
        Row(
          children: [
            Image.asset(
              AppIcons.medlFilled,
              width: 24.w,
              height: 24.h,
            ),
            Gap(10.h),
            Expanded(
              child: Text(
                "${ratingData.subjectText} fani",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
        Gap(18.h),
        Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: ratingData.rating!.length,
              itemBuilder: (BuildContext context, int index) {
                return ratingItem("${index + 1}", ratingData.rating![index]);
              }),
        )
      ],
    );
  }

  Widget ratingItem(String index, Rating data) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            index,
            style: AppStyles.subtitleTextStyle.copyWith(
              fontSize: 13.sp,
            ),
          ),
          Gap(8.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "# ${data.userId}",
                        style: AppStyles.subtitleTextStyle.copyWith(
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        data.userFullname!,
                        maxLines: 2,
                        style: AppStyles.subtitleTextStyle
                            .copyWith(color: AppColors.smsVerColor),
                      ),
                      (data.userTelegram != "-")
                          ? InkWell(
                              onTap: () async {
                                await _launcher(
                                    data.userTelegram!.replaceAll("@", ""));
                              },
                              child: Text(
                                "${data.userTelegram}",
                                style: AppStyles.subtitleTextStyle.copyWith(
                                  fontSize: 13.sp,
                                  color: AppColors.mainColor,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                Container(
                  height: 37.h,
                  width: 79.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(13.r),
                    ),
                    color: AppColors.mainColor,
                  ),
                  child: Center(
                    child: Text(
                      "${data.rating} ball",
                      style: AppStyles.subtitleTextStyle.copyWith(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<void> _launcher(String? userTelegram) async {
  final Uri uri = Uri.parse("https://t.me/$userTelegram");
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    showToast("Tizimda nosozlik...");
  }
}
