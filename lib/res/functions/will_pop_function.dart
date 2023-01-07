import 'package:flutter/cupertino.dart';
import 'package:test_app/res/functions/show_toast.dart';

Future<bool> onWillPop(BuildContext context) {
  DateTime now = DateTime.now();
  DateTime? currentBackPressTime;
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
    currentBackPressTime = now;
    showToast("Darturdan chiqich uchun tugmani ikki marta bosing");
    return Future.value(false);
  } else {
    return Future.value(true);
  }
}
