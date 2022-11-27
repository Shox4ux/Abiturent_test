import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:test_app/res/components/custom_simple_appbar.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:test_app/res/painter.dart';

import '../../core/block/book_cubit/book_cubit.dart';
import '../../core/domain/test_model/test_model.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key, required this.bookList});

  final List<Books> bookList;

  @override
  State<BookScreen> createState() => _BookScreenState();
}

double progress = 10;

class _BookScreenState extends State<BookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSimpleAppBar(
                isSimple: true,
                titleText: "Test bo’yicha adabiyotlar",
                iconColor: Colors.white,
                style: AppStyles.subtitleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.bookList.length,
                        itemBuilder: (context, index) =>
                            bookItem(widget.bookList[index]),
                      ),
                    ),
                    // ElevatedButton(
                    //   style: AppStyles.introUpButton,
                    //   onPressed: () {},
                    //   child: Text(
                    //     "Testlarga o'tish",
                    //     style: AppStyles.introButtonText
                    //         .copyWith(color: const Color(0xffFCFCFC)),
                    //   ),
                    // ),
                    // Gap(24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bookItem(Books book) {
    return Container(
      alignment: Alignment.center,
      height: 70.h,
      width: double.maxFinite,
      child: Row(
        children: [
          BlocConsumer<BookCubit, BookState>(
            listener: (context, state) {
              if (state is OnError) {
                showToast(state.error);
              }
              if (state is OnDownloadCompleted) {
                showToast("Kiton yuklab olindi");
              }
              if (state is OnProgress) {
                setState(() {
                  progress = state.progress;
                });
              }
            },
            builder: (context, state) {
              if (state is OnProgress) {
                // return Center(
                //   child: Text("${state.progress.floor()}%"),
                // );

                return CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.mainColor,
                  ),
                  value: state.progress,
                );
              }
              return GestureDetector(
                onTap: () {
                  context
                      .read<BookCubit>()
                      .downloadFile(book.files!, book.title!);
                },
                child: Image.asset(
                  AppIcons.bd,
                  scale: 3.5,
                ),
              );
            },
          ),
          Gap(9.w),
          Text(
            book.title!,
            style: AppStyles.subtitleTextStyle.copyWith(
              color: Colors.black,
              fontSize: 13.sp,
            ),
          )
        ],
      ),
    );
  }
}
