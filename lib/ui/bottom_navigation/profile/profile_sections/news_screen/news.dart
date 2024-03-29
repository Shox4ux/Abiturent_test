import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/bloc/news_cubit/news_cubit.dart';
import 'package:test_app/core/domain/news_models/main_news_model.dart';
import 'package:test_app/core/domain/news_models/news_model_notification.dart';
import 'package:test_app/res/components/custom_simple_appbar.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import '../../../../../res/constants.dart';

List<NewsWithNotificationModel> setList = [];

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Column(children: [
          CustomSimpleAppBar(
            isIcon: false,
            isSimple: true,
            titleText: "Yangiliklar",
            routeText: RouteNames.profile,
            style: AppStyles.subtitleTextStyle.copyWith(
              fontSize: 24.sp,
              color: Colors.white,
            ),
            iconColor: Colors.white,
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
              child: BlocBuilder<NewsCubit, NewsState>(
                builder: (context, state) {
                  if (state is OnNewsProgress) {
                    return const Center(child: Text("Iltimos kuting..."));
                  }
                  if (state is OnNewsError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is OnNewsReceived) {
                    setList = state.newsList;
                    return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: setList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.innerNews,
                                arguments: setList[index],
                              );

                              context.read<NewsCubit>().markOneNewsAsRead(
                                    showcaseList: setList,
                                    model: setList[index],
                                  );
                            },
                            child: setList[index].isNew
                                ? Stack(children: [
                                    newsItem(setList[index].model),
                                    CircleAvatar(
                                      radius: 5.h,
                                      backgroundColor: Colors.red,
                                    )
                                  ])
                                : newsItem(setList[index].model),
                          );
                        });
                  }
                  return const Center(
                      child: Text("Hozircha yangiliklar yo'q..."));
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
        Column(
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
        )
      ],
    ),
  );
}
