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
    required this.context,
  });
  final int lenth;
  final ValueChanged<String> onChanged;
  final TextStyle? style;
  final Size? unselectedPinSize;
  final Size? selectedPinSize;
  final BuildContext context;

  @override
  State<PinPutWidget> createState() => _PinPutWidgetState();
}

class _PinPutWidgetState extends State<PinPutWidget> {
  var focusNode = FocusNode();
  String code = '';
  final _pinController = TextEditingController();
  late SmsUserConsent smsUserConsent;

  @override
  void initState() {
    super.initState();
    smsUserConsent = SmsUserConsent(
      phoneNumberListener: () => setState(() {}),
      smsListener: () => setState(
        () {
          code = smsUserConsent.receivedSms ?? "";
          if (code.length > 6) {
            var result = "";
            for (var j = 0; j < code.length; j++) {
              if (double.tryParse(code[j]) != null) {
                result += code[j];
              }
            }
            code = result;
            if (code.length == 6) {
              focusNode.unfocus();
            }
            widget.onChanged(code);
            _pinController.setText(code);
          }
        },
      ),
    );
    smsUserConsent.requestSms();
  }

  void changeCode(String value) {
    code = value;
    widget.onChanged(code);
    setState(() {});
  }

  @override
  void dispose() {
    focusNode.dispose();
    smsUserConsent.dispose();
    _pinController.dispose();
    super.dispose();
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
        FocusScope.of(context).requestFocus(focusNode);
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
              controller: _pinController,
              autofocus: true,
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
