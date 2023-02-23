import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_user_consent/sms_user_consent.dart';
import 'package:test_app/res/constants.dart';

class PinPutWidget extends StatefulWidget {
  const PinPutWidget({
    super.key,
    required this.lenth,
    required this.onChanged,
    this.selectedPinSize,
    this.style,
    this.unselectedPinSize,
  });
  final int lenth;
  final ValueChanged<String> onChanged;
  final TextStyle? style;
  final Size? unselectedPinSize;
  final Size? selectedPinSize;

  @override
  State<PinPutWidget> createState() => _PinPutWidgetState();
}

class _PinPutWidgetState extends State<PinPutWidget>
    with WidgetsBindingObserver {
  String code = '';
  final _pinController = TextEditingController();
  late SmsUserConsent smsUserConsent;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

//-----------------------sms auto fill code----------------------//

    // smsUserConsent = SmsUserConsent(
    //   phoneNumberListener: () => setState(() {}),
    //   smsListener: () => setState(
    //     () {
    //       code = smsUserConsent.receivedSms ?? "";
    //       if (code.length > 6) {
    //         var result = "";
    //         for (var j = 0; j < code.length; j++) {
    //           if (double.tryParse(code[j]) != null) {
    //             result += code[j];
    //           }
    //         }
    //         code = result;
    //         if (code.length == 6) {
    //           focusNode.unfocus();
    //         }
    //         widget.onChanged(code);
    //         _pinController.setText(code);
    //       }
    //     },
    //   ),
    // );
    // smsUserConsent.requestSms();

    //-------------------------------------------------------------//
  }

  final focusNode = FocusNode();

  void changeCode(String value) {
    code = value;
    widget.onChanged(code);
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      print("Paused");
    } else if (state == AppLifecycleState.resumed) {
      setState(() {});
      focusNode.requestFocus();
      print("Resumed");
    } else if (state == AppLifecycleState.detached) {
      print("detached");
    } else if (state == AppLifecycleState.inactive) {
      print("inactive");
    }
  }

  @override
  void dispose() {
    // smsUserConsent.dispose();

    super.dispose();
    _pinController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ??
        TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.w700,
        );

    return GestureDetector(
      onTap: () {
        try {
          setState(() {});
          focusNode.requestFocus();
        } catch (e) {
          print(e);
        }
        print("focus");
      },
      child: Column(
        children: [
          Material(
            child: SizedBox(
              height: 40.h,
              child: Row(
                children: [
                  for (var i = 0; i < widget.lenth; i++)
                    Row(
                      children: [
                        (code.length > i)
                            ? Text(
                                code[i],
                                style: style,
                              )
                            : Container(
                                height: 16.h,
                                width: 16.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.gray,
                                ),
                              ),
                        SizedBox(width: 16.w),
                      ],
                    )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 0,
            child: TextField(
              autofocus: true,
              controller: _pinController,
              onChanged: changeCode,
              focusNode: focusNode,
              maxLength: null,
              minLines: null,
              maxLines: null,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 0),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
