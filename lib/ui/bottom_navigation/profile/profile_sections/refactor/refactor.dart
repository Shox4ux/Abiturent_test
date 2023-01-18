import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/res/components/custom_simple_appbar.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/show_toast.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile.dart';
import '../../../../../core/bloc/auth_cubit/auth_cubit.dart';
import '../../../../../core/bloc/user_cubit/user_cubit.dart';

class RefactorScreen extends StatefulWidget {
  const RefactorScreen({super.key, required this.user});
  final UserInfo user;

  @override
  State<RefactorScreen> createState() => _RefactorScreenState();
}

class _RefactorScreenState extends State<RefactorScreen> {
  File? _pickedFile;
  final ImagePicker _picker = ImagePicker();
  String compressedImagePath = "/storage/emulated/0/Download/";

  final _changedNameController =
      TextEditingController(text: userData?.fullname ?? '');

  final _tegLinkController =
      TextEditingController(text: userData?.telegramLink ?? '');

  Future<File?> testCompressAndGetFile(File file, String targetPath) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      "$tempPath/compressed.jpg",
      quality: 100,
      minHeight: 600,
      minWidth: 600,
    );
    return result;
  }

  Future<void> _takePhoto(ImageSource source) async {
    try {
      final pickedImage = await _picker.pickImage(source: source);
      if (pickedImage == null) {
        return;
      } else {
        File pickedImg = File(pickedImage.path);
        final beforecompressedSize = pickedImg.lengthSync() / 1024;
        print(beforecompressedSize);
        final compressedImage =
            await testCompressAndGetFile(pickedImg, compressedImagePath);
        final compressedSize = compressedImage!.lengthSync() / 1024;
        print(compressedSize);

        setState(() {
          _pickedFile = compressedImage;
        });
      }
    } on PlatformException catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is OnProflieUpdated) {
          showToast("O'zgarishlar muvaffaqiyatli saqlandi");
          Navigator.pushNamedAndRemoveUntil(
              context, RouteNames.main, (route) => false);
        }
        if (state is OnUserError) {
          showToast(state.error);
        }
        if (state is OnUserUpdated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.main,
            (route) => false,
          );

          context.read<AuthCubit>().getUserData();
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.mainColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomSimpleAppBar(
                isIcon: false,
                titleText: "Tahrirlash",
                style: AppStyles.smsVerBigTextStyle.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
                iconColor: Colors.white,
                isSimple: true,
              ),
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
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: SingleChildScrollView(
                      child: _refactorBody(context),
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

  Widget _refactorBody(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            (_pickedFile == null)
                ? Container(
                    height: 160.h,
                    width: 160.w,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.mainColor,
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Image.network(
                      userData!.image ?? "",
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 64.h,
                          color: AppColors.mainColor,
                        );
                      },
                    ),
                  )
                : CircleAvatar(
                    radius: 80.w,
                    foregroundImage: FileImage(_pickedFile!),
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
        Gap(50.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              TextField(
                controller: _changedNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Abiturent F.I.O",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.h),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.h),
                    borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor, width: 2.w),
                  ),
                ),
              ),
              Gap(10.h),
              TextField(
                controller: _tegLinkController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Telegram link ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.h),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.h),
                    borderSide: BorderSide(
                        color: AppColors.textFieldBorderColor, width: 2.w),
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(40.h),
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is OnUserProgress) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                ),
              );
            }

            return (_changedNameController.text.isNotEmpty ||
                    _pickedFile != null)
                ? Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: ElevatedButton(
                      style: AppStyles.introUpButton,
                      onPressed: () async {
                        if (_tegLinkController.text.isEmpty) {
                          await context.read<UserCubit>().updateProfile(
                                _changedNameController.text,
                                _pickedFile,
                                "-",
                              );
                        } else {
                          await context.read<UserCubit>().updateProfile(
                                _changedNameController.text,
                                _pickedFile,
                                _tegLinkController.text,
                              );
                        }
                      },
                      child: Text(
                        "Saqlash",
                        style: AppStyles.introButtonText
                            .copyWith(color: const Color(0xffFCFCFC)),
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
                            .copyWith(color: const Color(0xffFCFCFC)),
                      ),
                    ),
                  );
          },
        )
      ],
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
