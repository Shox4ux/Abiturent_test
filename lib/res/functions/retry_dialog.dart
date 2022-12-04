import 'package:flutter/material.dart';
import '../constants.dart';

showRetryDialog(BuildContext context, Future function, String topic) {
  return showDialog(
    context: context,
    builder: ((context) => AlertDialog(
          title: Text(topic),
          actions: [
            TextButton(
              onPressed: () async {
                function;
              },
              child: const Text(
                "Qaytattan",
                style: TextStyle(
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ],
        )),
  );
}
