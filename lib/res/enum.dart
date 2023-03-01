import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:test_app/res/constants.dart';

enum Subscriptions {
  income(AppIcons.greenSub, "+"),
  expense(AppIcons.redSub, "-"),
  bonus(AppIcons.purpleSub, "");

  final String iconPath;
  final String indicator;

  const Subscriptions(this.iconPath, this.indicator);
}

enum TestVertions {
  correct(AppColors.greenBackground),
  incorrect(AppColors.error),
  neutral(AppColors.subtitleColor);

  final Color testColor;

  const TestVertions(this.testColor);
}

enum ImageEnum {
  bronze(
    AppIcons.bronze
  ),
  silver(
    AppIcons.silver
  ),
  gold(
    AppIcons.gold
  );

  final String iconPath;

  const ImageEnum(this.iconPath);
}
