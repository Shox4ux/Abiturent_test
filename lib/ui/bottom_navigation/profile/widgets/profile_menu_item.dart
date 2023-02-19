import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/constants.dart';

class ProfileMenuItem extends StatelessWidget {
  final String imagePath;
  final String text;
  final bool isRed;
  final bool withNotification;
  const ProfileMenuItem(
      {super.key,
      required this.imagePath,
      required this.text,
      required this.isRed,
      required this.withNotification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 16.w),
      child: Row(
        children: [
          withNotification
              ? Stack(
                  children: [
                    _iconHolder(),
                    CircleAvatar(
                      radius: 4.h,
                      backgroundColor: Colors.red,
                    )
                  ],
                )
              : _iconHolder(),
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

  Container _iconHolder() {
    return Container(
      height: 48.h,
      width: 48.w,
      decoration: BoxDecoration(
        color: isRed ? const Color(0xffFFE2E4) : AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: _colorDecider(isRed: isRed),
    );
  }

  Widget _colorDecider({required bool isRed}) {
    return isRed
        ? Image.asset(imagePath, scale: 3.h, color: Colors.red)
        : Image.asset(imagePath, scale: 3.h);
  }
}
