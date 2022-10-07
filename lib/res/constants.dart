import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/res/models/intro_data.dart';
import 'package:test_app/res/models/subject_data.dart';

class AppColors {
  static const splashColor = Color(0xFFFCAC12);
  static const mainColor = Color(0xFF7F3DFF);
  static const backgroundColor = Color(0xffF6F6F6);
  static const greenBackground = Color(0xff00A86B);
  static const subtitleColor = Color(0xFF91919F);
  static const titleColor = Color(0xFF212325);
  static const smsVerColor = Color(0xff0D0E0F);
  static const secondaryColor = Color(0xFFEEE5FF);
  static const textFieldBorderColor = Color(0xFFF1F1FA);
  static const shadowColor = Color(0xffe8e8e8);
  static const fillingColor = Color(0xfffcfcfc);
}

class AppStyles {
  static TextStyle mainTextStyle = GoogleFonts.inter(
      fontSize: 32.sp, fontWeight: FontWeight.w700, color: AppColors.mainColor);

  static TextStyle subtitleTextStyle = GoogleFonts.inter(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.subtitleColor);

  static TextStyle introButtonText = GoogleFonts.inter(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.subtitleColor);
  static TextStyle smsVerBigTextStyle = GoogleFonts.inter(
      fontSize: 36.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.smsVerColor);

  static ButtonStyle introUpButton = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(AppColors.mainColor),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.h),
        ),
      ),
      fixedSize: MaterialStateProperty.all(Size(343.w, 56.h)));
}

class AppStrings {
  static const String firstHeadIntro = "Test markazi";
  static const String secondHeadIntro = "Turli xil fanlar";
  static const String thirdHeadIntro = "O’z ustada ishlash";

  static const String introUpButtonText = "Ro’yhatdan o’rish";

  static const String checkBoxText =
      "Barcha ma’lumotlarinmi qayta ishlash uchun va foydalanishga ruxsat etaman";

  static const String firstFootIntro =
      "Eng yaqin test markazi, sizning telefoningizda";
  static const String secondFootIntro =
      "Ushbu foydali manba orqali turli xil fanlarga tayyorlaning";

  static const String thirdFootIntro =
      "Agar siz testdan o'tgan bo'lsangiz,natijangizni tekshiring va o’z ustingizda ishlang";

  static const String smsText =
      "Bizning telegon +99899 *** ** 88 raqamingizga sms-kod xabarnomasini jo’natdik.";
}

class AppIntroImages {
  static List<IntroData> introList = [
    const IntroData(
        imgPath: "assets/intro_1.png",
        mainTitle: AppStrings.firstHeadIntro,
        secondaryTitle: AppStrings.firstFootIntro),
    const IntroData(
        imgPath: "assets/intro_2.png",
        mainTitle: AppStrings.secondHeadIntro,
        secondaryTitle: AppStrings.secondFootIntro),
    const IntroData(
        imgPath: "assets/intro_3.png",
        mainTitle: AppStrings.thirdHeadIntro,
        secondaryTitle: AppStrings.thirdFootIntro),
  ];
}

class SubjectList {
  static List<SubjectData> introList = [
    const SubjectData(
        text: "Tarix fanidan namunaviy test topshiriqlari", quantity: "12"),
    const SubjectData(
        text: " Eng qadimgi tuzumdan sivilizatsiya sari", quantity: "10"),
    const SubjectData(
        text:
            " O‘rta Osiyoning Arab xalifalari tomonidan fath etilishi. Xalq qo‘zg‘olonlari",
        quantity: "12"),
    const SubjectData(
        text:
            " 1918-1939- yillarda Osiyo davlatlarining iqtisodiy va siyosiy rivojlanishi",
        quantity: "12"),
  ];
}

class AppIcons {
  static const String subFilled = "assets/sub_filled.png";
  static const String sub = "assets/sub.png";

  static const String medlFilled = "assets/medl_filled.png";
  static const String medl = "assets/medl.png";

  static const String profileFilled = "assets/profile_filled.png";
  static const String profile = "assets/profile.png";

  static const String mistakesFilled = "assets/mistakes_filled.png";
  static const String mistakes = "assets/mistakes.png";

  static const String dtmFilled = "assets/dtm_filled.png";
  static const String dtm = "assets/dtm.png";

  static const String purplePocket = "assets/purlpe.png";
  static const String greenPocket = "assets/green.png";

  static const String person = "assets/pesron.png";
  static const String info = "assets/info.png";
  static const String arrow = "assets/arrow.png";
  static const String down = "assets/down.png";
  static const String star = "assets/star.png";
  static const String group = "assets/group.png";
  static const String gallery = "assets/gallery.png";
  static const String check = "assets/check.png";
  static const String purpleDone = "assets/pesron.png";
  static const String clock = "assets/clock.png";
  static const String menu = "assets/menu.png";
  static const String logout = "assets/logout.png";
  static const String payme = "assets/payme.png";
  static const String bigEnvy = "assets/envy.png";
  static const String bigGreenDone = "assets/envy.png";
  static const String arrowBack = "assets/back.png";

  static const String greenSub = "assets/green_sub.png";
  static const String redSub = "assets/red_sub.png";
  static const String purpleSub = "assets/purple_sub.png";
}
