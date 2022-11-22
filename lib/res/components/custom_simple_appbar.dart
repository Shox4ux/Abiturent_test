import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/navigation/main_navigation.dart';

import '../../core/block/group_block/group_cubit.dart';
import '../constants.dart';

class CustomSimpleAppBar extends StatefulWidget {
  CustomSimpleAppBar(
      {Key? key,
      required this.titleText,
      this.routeText,
      required this.style,
      required this.iconColor,
      required this.isSimple,
      this.isImportant})
      : super(key: key);

  final String titleText;
  String? routeText;
  final TextStyle style;
  final Color iconColor;
  final bool isSimple;
  bool? isImportant;

  @override
  State<CustomSimpleAppBar> createState() => _CustomSimpleAppBarState();
}

class _CustomSimpleAppBarState extends State<CustomSimpleAppBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (widget.isSimple && widget.isImportant != null) {
              context.read<GroupCubit>().getGroupsByUserId();
              Navigator.pushNamed(context, RouteNames.group);
              return;
            }
            if (widget.isSimple) {
              Navigator.pop(context);
              return;
            }
            Navigator.pushNamed(
              context,
              widget.routeText!,
            );
          },
          icon: Image.asset(
            AppIcons.arrowBack,
            color: widget.iconColor,
            height: 24.h,
            width: 24.w,
          ),
        ),
        Gap(10.w),
        Text(
          widget.titleText,
          style: widget.style,
        )
      ],
    );
  }
}
