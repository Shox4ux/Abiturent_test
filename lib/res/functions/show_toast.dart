import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.SNACKBAR,
    textColor: Colors.white,
    backgroundColor: AppColors.mainColor,
    fontSize: 12.sp,
    toastLength: Toast.LENGTH_SHORT,
  );
}
