import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:test_app/res/constants.dart';

enum Subscriptions {
  green(AppIcons.greenSub, "Hisobni Payme orqali to’ldirish"),
  red(AppIcons.redSub, "Tarix fanidan obuna sotib olish"),
  purple(AppIcons.purpleSub, "Rag’batlantirish");

  final String iconPath;
  final String text;

  const Subscriptions(this.iconPath, this.text);
}

enum TestVertions {
  correct(AppColors.greenBackground),
  incorrect(AppColors.error),
  neutral(AppColors.subtitleColor);

  final Color testColor;

  const TestVertions(this.testColor);
}

// enum Selection {
//   selected(AppColors.greenBackground),
//   unselected(AppColors.error);

//   final BoxDecoration decoration;

//   const Selection(this.decoration);
// }

// enum Select {
//   selected,
//   unselected;

// final fun ()=> Widget();


  
// }
