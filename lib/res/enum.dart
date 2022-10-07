import 'package:test_app/res/constants.dart';

enum Subscriptions {
  green(AppIcons.greenSub, "Hisobni Payme orqali to’ldirish"),
  red(AppIcons.redSub, "Tarix fanidan obuna sotib olish"),
  purple(AppIcons.purpleSub, "Rag’batlantirish");

  final String iconPath;
  final String text;

  const Subscriptions(this.iconPath, this.text);
}
