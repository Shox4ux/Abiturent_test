import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/core/helper/repos/user_repo.dart';
import 'package:test_app/ui/components/custom_drawer.dart';

import '../../../core/block/cubit/user_cubit_cubit.dart';
import '../../../res/constants.dart';
import '../../components/custom_appbar.dart';

List<UserInfo> list = [];

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final _repo = UserRepo();

  Future<List<UserInfo>> callUserRating() async {
    final response = await _repo.getUserRatings();
    final rowData = response.data as List;

    if (response.statusCode == 200) {
      list.clear();
      for (var element in rowData) {
        list.add(UserInfo.fromJson(element));
      }
      return list;
    } else {
      return list;
    }
  }

  @override
  void initState() {
    super.initState();

    callUserRating();
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
          customAppBar(scaffKey, context),
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
                child: FutureBuilder(
                  future: callUserRating(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("Loading...");
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
                        Gap(18.h),
                        Expanded(
                          child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: list.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ratingItem("${index + 1}", list[index]);
                              }),
                        ),
                      ],
                    );
                  },
                )),
          ),
        ]),
      ),
    );
  }

  Widget ratingItem(String index, UserInfo data) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "# ${data.id.toString()}",
                      style: AppStyles.subtitleTextStyle.copyWith(
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      data.fullname!,
                      style: AppStyles.subtitleTextStyle
                          .copyWith(color: AppColors.smsVerColor),
                    ),
                  ],
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
                      "123 ball",
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
