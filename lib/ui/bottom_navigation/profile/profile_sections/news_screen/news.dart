import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/news_models/main_news_model.dart';
import 'package:test_app/core/helper/repos/news_repo.dart';
import 'package:test_app/res/components/custom_simple_appbar.dart';
import 'package:test_app/res/navigation/main_navigation.dart';

import '../../../../../core/block/news_bloc/cubit/news_cubit.dart';
import '../../../../../res/constants.dart';

List<MainNewsModel> list = [];

class NewsScreen extends StatelessWidget {
  NewsScreen({Key? key}) : super(key: key);

  final _repo = NewsRepository();

  Future<List<MainNewsModel>> getNews() async {
    final response = await _repo.getMainNews();
    final rowData = response.data as List;
    print(rowData);

    if (response.statusCode == 200) {
      list.clear();
      for (var element in rowData) {
        list.add(MainNewsModel.fromJson(element));
      }
      return list;
    } else {
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, bottom: 17.h),
            child: CustomSimpleAppBar(
              isSimple: true,
              titleText: "Yangiliklar",
              routeText: RouteNames.profile,
              style: AppStyles.subtitleTextStyle.copyWith(
                fontSize: 24.sp,
                color: Colors.white,
              ),
              iconColor: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28.r),
                  topRight: Radius.circular(28.r),
                ),
              ),
              child: FutureBuilder(
                future: getNews(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<dynamic> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text("Iltimos kuting..."));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteNames.innerNews,
                                      arguments: list[index]);
                                },
                                child: newsItem(list[index]),
                              );
                            }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

Widget newsItem(MainNewsModel model) {
  return Container(
    height: 80.h,
    margin: EdgeInsets.only(bottom: 10.h),
    child: Row(
      children: [
        Container(
          height: 77.h,
          width: 74.w,
          margin: EdgeInsets.only(bottom: 10.h),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                11.r,
              ),
            ),
          ),
          child: FadeInImage.assetNetwork(
            placeholder: AppIcons.newsError,
            image: model.imageLink!,
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) =>
                Image.asset(AppIcons.noImage),
          ),
        ),
        Gap(11.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.createdText ?? "unknown",
                style: AppStyles.subtitleTextStyle.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.mainColor,
                ),
              ),
              Gap(4.h),
              Expanded(
                child: Text(
                  model.title ?? "",
                  maxLines: 3,
                  style: AppStyles.subtitleTextStyle.copyWith(
                    fontSize: 12.sp,
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
