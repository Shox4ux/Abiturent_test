import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/core/block/user_block/user_cubit_cubit.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/res/components/custom_simple_appbar.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import 'package:test_app/ui/bottom_navigation/mistakes/mistakes_screen.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile.dart';

class RefactorScreen extends StatefulWidget {
  const RefactorScreen({super.key, required this.user});
  final UserInfo user;

  @override
  State<RefactorScreen> createState() => _RefactorScreenState();
}

class _RefactorScreenState extends State<RefactorScreen> {
  File? _pickedFile;
  final ImagePicker _picker = ImagePicker();
  var _changedName = "";

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
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: BlocListener<UserCubit, UserState>(
          listener: (context, state) {
            if (state is OnProflieUpdated) {
              showToast("O'zgarishlar muvaffaqiyatli saqlandi");
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteNames.main, (route) => false);
            }
            if (state is OnError) {
              showToast(state.error);
            }
          },
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
                  child: Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            _pickedFile == null
                                ? CircleAvatar(
                                    radius: 80.w,
                                    foregroundImage: const AssetImage(
                                      AppIcons.man,
                                    ))
                                : CircleAvatar(
                                    radius: 80.w,
                                    foregroundImage: FileImage(_pickedFile!)),
                            Positioned(
                              top: 110.h,
                              right: 0.w,
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          bottomSheet(context));
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
                        Gap(50.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              setState(() {
                                _changedName = value;
                              });
                            },
                            keyboardType: TextInputType.name,
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
                        Gap(10.h),
                        BlocBuilder<UserCubit, UserState>(
                          builder: (context, state) {
                            if (state is OnUserProgress) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.mainColor,
                                ),
                              );
                            }
                            return (_changedName.isNotEmpty)
                                ? Padding(
                                    padding: EdgeInsets.only(bottom: 24.h),
                                    child: ElevatedButton(
                                      style: AppStyles.introUpButton,
                                      onPressed: () {
                                        //for now avatar place is empty
                                        context
                                            .read<UserCubit>()
                                            .updateProfile(_changedName, "");
                                      },
                                      child: Text(
                                        "Saqlash",
                                        style: AppStyles.introButtonText
                                            .copyWith(
                                                color: const Color(0xffFCFCFC)),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(bottom: 24.h),
                                    child: ElevatedButton(
                                      style: AppStyles.disabledButton,
                                      onPressed: null,
                                      child: Text(
                                        "Saqlash",
                                        style: AppStyles.introButtonText
                                            .copyWith(
                                                color: const Color(0xffFCFCFC)),
                                      ),
                                    ),
                                  );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
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
                Navigator.pop(context);
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
                Navigator.pop(context);
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
