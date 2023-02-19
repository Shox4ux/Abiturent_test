import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/core/domain/news_models/news_model_notification.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/components/custom_simple_appbar.dart';
import 'package:url_launcher/link.dart';

class InsideNewsScreen extends StatefulWidget {
  const InsideNewsScreen({Key? key, required this.model}) : super(key: key);
  final NewsWithNotificationModel model;
  @override
  State<InsideNewsScreen> createState() => _InsideNewsScreenState();
}

class _InsideNewsScreenState extends State<InsideNewsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          fit: StackFit.loose,
          children: [
            SizedBox(
              height: 320.h,
              width: double.maxFinite,
              child: FadeInImage.assetNetwork(
                placeholder: AppIcons.newsError,
                image: widget.model.model.imageLink!,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) =>
                    Image.asset(AppIcons.noImage),
              ),
            ),
            Positioned(
              width: size.width,
              top: 210.h,
              child: CustomSimpleAppBar(
                isIcon: false,
                isSimple: true,
                titleText: "Yangiliklar",
                routeText: "routeText",
                style: AppStyles.introButtonText.copyWith(
                  color: Colors.white,
                ),
                iconColor: Colors.white,
              ),
            ),
            Positioned(
              top: 260.h,
              child: Container(
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 17.h, bottom: 7.h),
                width: size.width,
                height: size.height - 260.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25.r),
                    topLeft: Radius.circular(25.r),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 49.h,
                          width: 49.w,
                          decoration: BoxDecoration(
                            color: const Color(0xffEEE5FF),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Image.asset(AppIcons.bell,
                              height: 20, width: 20, scale: 3),
                        ),
                        Gap(9.w),
                        Expanded(
                          child: Text(
                            widget.model.model.title ?? "",
                            style: AppStyles.subtitleTextStyle.copyWith(
                              color: AppColors.mainColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.model.model.createdText ?? "",
                          style: AppStyles.subtitleTextStyle.copyWith(
                            color: AppColors.smsVerColor,
                            fontSize: 10.sp,
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 13.h,
                        horizontal: 23.w,
                      ),
                      height: 388.h,
                      width: size.width,
                      child: Column(
                        children: [
                          (widget.model.model.video != null)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppIcons.y,
                                      scale: 3,
                                    ),
                                    Gap(10.w),
                                    Link(
                                      uri: Uri.parse(widget.model.model.video!),
                                      builder: ((context, followLink) =>
                                          InkWell(
                                            onTap: followLink,
                                            child: Text(
                                              "Video file",
                                              style: AppStyles.subtitleTextStyle
                                                  .copyWith(
                                                color: AppColors.mainColor,
                                              ),
                                            ),
                                          )),
                                    )
                                  ],
                                )
                              : const SizedBox.shrink(),
                          Gap(10.h),
                          Text(
                            widget.model.model.short ?? "",
                            style: AppStyles.introButtonText.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 11.sp,
                            ),
                          ),
                          Gap(10.h),
                          Expanded(
                            child: Text(
                              widget.model.model.content ?? "",
                              style: AppStyles.introButtonText.copyWith(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 11.sp,
                                  overflow: TextOverflow.visible),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
