import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../constants.dart';

class CustomPinPutWidget extends StatefulWidget {
  const CustomPinPutWidget({
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
  State<CustomPinPutWidget> createState() => _CustomPinPutWidgetState();
}

class _CustomPinPutWidgetState extends State<CustomPinPutWidget> {
  var focusNode = FocusNode();
  String code = '';
  final _pinputController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    _pinputController.dispose();
    super.dispose();
  }

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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(focusNode);
        print('object');
      },
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
            ],
          ),
          // Pinput(
          //   length: 1,
          //   autofocus: true,
          //   focusNode: focusNode,
          //   keyboardType: TextInputType.number,
          //   onChanged: onChanged,
          //   // defaultPinTheme: const PinTheme(
          //   //   height: null,
          //   //   width: null,
          //   //   margin: null,
          //   //   padding: null,
          //   //   textStyle: TextStyle(fontSize: 0),
          //   // ),
          //   // style: const TextStyle(fontSize: 0),
          //   // decoration: const InputDecoration(
          //   //   contentPadding: EdgeInsets.zero,
          //   //   border: InputBorder.none,
          //   // ),
          // )
        ],
      ),
    );
  }
}
