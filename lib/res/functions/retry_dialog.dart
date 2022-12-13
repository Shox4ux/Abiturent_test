import 'package:flutter/material.dart';
import '../constants.dart';

showRetryDialog(BuildContext context, Future function, String alertText) {
  return showDialog(
    context: context,
    builder: ((context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () async {
                function;
              },
              child: Text(
                alertText,
                style: const TextStyle(
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ],
        )),
  );
}
