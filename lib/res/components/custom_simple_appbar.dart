import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import '../../core/bloc/group_cubit/group_cubit.dart';
import '../../core/bloc/subscription_cubit/subscription_cubit.dart';
import '../constants.dart';

class CustomSimpleAppBar extends StatelessWidget {
  CustomSimpleAppBar(
      {Key? key,
      required this.titleText,
      this.routeText,
      required this.style,
      required this.iconColor,
      required this.isSimple,
      this.isImportant,
      this.isScript,
      required this.isIcon})
      : super(key: key);

  final String titleText;
  String? routeText;
  final TextStyle style;
  final Color iconColor;
  final bool isSimple;
  final bool isIcon;
  bool? isImportant;

  bool? isScript = false;

  @override
  Widget build(BuildContext context) {
    return isIcon
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (isSimple && isImportant != null) {
                          context.read<GroupCubit>().getGroupsByUserId();
                          Navigator.pushNamed(context, RouteNames.group);
                          return;
                        }
                        if (isSimple) {
                          Navigator.pop(context);
                          return;
                        }
                        if (isScript!) {
                          context.read<SubscriptionCubit>().getScripts();
                          Navigator.pop(context);
                          return;
                        }
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          routeText!,
                          (route) => false,
                        );
                      },
                      icon: Image.asset(
                        AppIcons.arrowBack,
                        color: iconColor,
                        height: 24.h,
                        width: 24.w,
                      ),
                    ),
                    Gap(10.w),
                    Expanded(
                      child: Text(
                        titleText,
                        style: style,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.payme);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: const Icon(
                    size: 30,
                    Icons.add_card,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )
        : Row(
            children: [
              IconButton(
                onPressed: () {
                  if (isSimple && isImportant != null) {
                    context.read<GroupCubit>().getGroupsByUserId();
                    Navigator.pushNamed(context, RouteNames.group);
                    return;
                  }
                  if (isSimple) {
                    Navigator.pop(context);
                    return;
                  }
                  Navigator.pushNamed(
                    context,
                    routeText!,
                  );
                },
                icon: Image.asset(
                  AppIcons.arrowBack,
                  color: iconColor,
                  height: 24.h,
                  width: 24.w,
                ),
              ),
              Gap(10.w),
              Expanded(
                child: Text(
                  titleText,
                  style: style,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          );
  }
}
