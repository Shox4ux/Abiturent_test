import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/res/components/custom_simple_appbar.dart';
import 'package:test_app/res/constants.dart';

class RefactorScreen extends StatefulWidget {
  const RefactorScreen({super.key});

  @override
  State<RefactorScreen> createState() => _RefactorScreenState();
}

class _RefactorScreenState extends State<RefactorScreen> {
  File? _pickedFile;
  final ImagePicker _picker = ImagePicker();

  Future _takePhoto(ImageSource source) async {
    try {
      final pickedImage = await _picker.pickImage(source: source);
      if (pickedImage == null) {
        return;
      } else {
        File img = File(pickedImage.path);
        setState(() {
          _pickedFile = img;
        });
      }
    } on PlatformException catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomSimpleAppBar(
                titleText: "Tahrirlash",
                style: AppStyles.smsVerBigTextStyle.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
                iconColor: Colors.white,
                isSimple: true),
            Gap(10.h),
            Expanded(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 14.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28.r),
                      topRight: Radius.circular(28.r),
                    )),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 80.w,
                          foregroundImage: const AssetImage(
                            AppIcons.man,
                          ),
                        ),
                        Positioned(
                          top: 110.h,
                          right: 0.w,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => bottomSheet(context));
                            },
                            child: Container(
                              height: 45.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(120.r),
                              ),
                              child: Image.asset(
                                AppIcons.replace,
                                scale: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(100.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        maxLength: 9,
                        onChanged: (value) {},
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Abiturent FIO",
                          counter: const SizedBox.shrink(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                            borderSide: BorderSide(
                                color: AppColors.textFieldBorderColor,
                                width: 2.w),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        maxLength: 9,
                        onChanged: (value) {},
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Telefon raqami",
                          prefixText: "+998 ",
                          counter: const SizedBox.shrink(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                            borderSide: BorderSide(
                                color: AppColors.textFieldBorderColor,
                                width: 2.w),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        maxLength: 9,
                        onChanged: (value) {},
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Telefon raqami",
                          prefixText: "+998 ",
                          counter: const SizedBox.shrink(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.h),
                            borderSide: BorderSide(
                                color: AppColors.textFieldBorderColor,
                                width: 2.w),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100.h,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(children: [
        const Text(
          "Profil uchun Rasm tanlang",
        ),
        Gap(20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.mainColor)),
              label: const Text("kamera"),
              onPressed: () {
                _takePhoto(ImageSource.camera);
              },
              icon: Icon(
                Icons.camera,
                size: 24.h,
              ),
            ),
            Gap(20.h),
            ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.mainColor)),
              label: const Text("galerya"),
              onPressed: () {
                _takePhoto(ImageSource.gallery);
              },
              icon: Icon(
                Icons.image,
                size: 24.h,
              ),
            )
          ],
        )
      ]),
    );
  }
}
