import 'package:flutter/material.dart';
import '../constants.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({Key? key}) : super(key: key);

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  String get countText {
    Duration count = _controller.duration! * _controller.value;
    return "${(count.inMinutes % 60).toString().padLeft(2, "0")}:${(count.inSeconds % 60).toString().padLeft(2, "0")}";
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 180),
    );

    _controller.reverse(from: _controller.value == 0 ? 1.0 : _controller.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Text(
        countText,
        style: AppStyles.introButtonText.copyWith(
          color: AppColors.mainColor,
        ),
      ),
    );
  }
}
