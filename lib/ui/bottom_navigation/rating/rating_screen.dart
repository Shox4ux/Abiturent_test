import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/user_model/rating_model.dart';
import 'package:test_app/core/helper/repos/user_repo.dart';
import 'package:test_app/res/components/custom_drawer.dart';
import '../../../core/block/drawer_cubit/drawer_cubit.dart';
import '../../../res/constants.dart';
import '../../../res/components/custom_appbar.dart';

RatingModel? ratingModel;

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final _repo = UserRepo();

  @override
  void initState() {
    super.initState();
  }

  Future<RatingModel> callUserRating(int subId) async {
    try {
      final response = await _repo.getUsersRatings(subId);
      final rowData = RatingModel.fromJson(response.data);
      ratingModel = rowData;
      return ratingModel!;
    } on SocketException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
    return ratingModel!;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffKey = GlobalKey<ScaffoldState>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      key: scaffKey,
      drawer: CustomDrawer(mainWidth: screenWidth),
      body: SafeArea(
        child: Column(children: [
          CustomAppBar(scaffKey: scaffKey),
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28.r),
                  topRight: Radius.circular(28.r),
                ),
              ),
              child: BlocBuilder<DrawerCubit, DrawerState>(
                builder: (context, state) {
                  if (state is DrawerSubId) {
                    return FutureBuilder(
                      future: callUserRating(state.subId),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: Text("Iltimos kuting..."));
                        }
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
                                Text(
                                  "${ratingModel!.subjectText} fani",
                                  style: AppStyles.subtitleTextStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                            Gap(18.h),
                            Expanded(
                              child: ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  itemCount: ratingModel!.rating!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ratingItem("${index + 1}",
                                        ratingModel!.rating![index]);
                                  }),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text("Fanni tanlang"),
                  );
                },
              ),
            ),
          ),
        ]),
      ),
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
