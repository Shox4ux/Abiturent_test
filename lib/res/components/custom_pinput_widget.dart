import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class _PinPutWidgetState extends State<PinPutWidget> {
  final controller = TextEditingController();
  var focusNode = FocusNode();
  String code = '';

  void onChanged(String value) {
    code = value;
    setState(() {});
    if (value.length == widget.lenth) {
      focusNode.unfocus();
    }
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ??
        TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.w700,
        );

    return FocusTrapArea(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: () {
          focusNode.requestFocus();
          print('object');
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
                focusNode: focusNode,
                maxLength: null,
                minLines: null,
                maxLines: null,
                keyboardType: TextInputType.number,
                onChanged: onChanged,
                style: const TextStyle(fontSize: 0),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
