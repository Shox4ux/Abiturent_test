import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/res/enum.dart';
import 'package:test_app/res/models/intro_data.dart';
import 'package:test_app/res/models/subject_data.dart';
import 'package:test_app/res/models/test_model.dart';

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
  static const gray = Color(0xFFE0E2E9);
  static const error = Color(0xFFFD3C4A);
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

  static ButtonStyle disabledButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(AppColors.subtitleColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.h),
      ),
    ),
    fixedSize: MaterialStateProperty.all(
      Size(343.w, 56.h),
    ),
  );

  static ButtonStyle introUpButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(AppColors.mainColor),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.h),
      ),
    ),
    fixedSize: MaterialStateProperty.all(
      Size(343.w, 56.h),
    ),
  );
}

class AppStrings {
  static const String firstHeadIntro = "Test markazi";
  static const String secondHeadIntro = "Turli xil fanlar";
  static const String thirdHeadIntro = "O’z ustida ishlash";

  static const String introUpButtonText = "Ro’yhatdan o’tish";

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

  static const String newsString =
      "NASA yaqin 10 yillikning asosiy missiyasi – Artemis dasturi ishga tushirilganini e’lon qildi. U uchta bosqichdan iborat: uchuvchisiz parvoz, ekipajning Oy atrofidagi parvozi va astronavtlarning Oyga qo‘nishi. Uchuvchisiz parvoz 27 sentabr kuni start oladi";
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

  static List<TestModel> tests = [
    TestModel(
        question:
            "... miloddan avvalgi VII-VI asrlardagi O‘rta Osiyo tarixiga xos emas.",
        options: [
          TestOptionModel(
              optionText: "Shaharlarda ichki qal’alar borligi",
              status: TestVertions.neutral),
          TestOptionModel(
              optionText: "Shahar-davlatlar mavjudligi",
              status: TestVertions.correct),
          TestOptionModel(
              optionText:
                  "Kulolchilik charxida ishlangan sopol idishlar mavjudligi",
              status: TestVertions.neutral),
          TestOptionModel(
              optionText: "Bronzadan ishlangan o‘q uchlari",
              status: TestVertions.neutral),
        ]),
    TestModel(
        question:
            "... miloddan avvalgi VII-VI asrlardagi O‘rta Osiyo tarixiga xos emas.",
        options: [
          TestOptionModel(
              optionText: "Shaharlarda ichki qal’alar borligi",
              status: TestVertions.incorrect),
          TestOptionModel(
              optionText: "Shahar-davlatlar mavjudligi",
              status: TestVertions.neutral),
          TestOptionModel(
              optionText:
                  "Kulolchilik charxida ishlangan sopol idishlar mavjudligi",
              status: TestVertions.neutral),
          TestOptionModel(
              optionText: "Bronzadan ishlangan o‘q uchlari",
              status: TestVertions.neutral),
        ]),
    TestModel(
        question:
            "... miloddan avvalgi VII-VI asrlardagi O‘rta Osiyo tarixiga xos emas.",
        options: [
          TestOptionModel(
              optionText: "Shaharlarda ichki qal’alar borligi",
              status: TestVertions.neutral),
          TestOptionModel(
              optionText: "Shahar-davlatlar mavjudligi",
              status: TestVertions.correct),
          TestOptionModel(
              optionText:
                  "Kulolchilik charxida ishlangan sopol idishlar mavjudligi",
              status: TestVertions.neutral),
          TestOptionModel(
              optionText: "Bronzadan ishlangan o‘q uchlari",
              status: TestVertions.neutral),
        ]),
    TestModel(
        question:
            "... miloddan avvalgi VII-VI asrlardagi O‘rta Osiyo tarixiga xos emas.",
        options: [
          TestOptionModel(
              optionText: "Shaharlarda ichki qal’alar borligi",
              status: TestVertions.incorrect),
          TestOptionModel(
              optionText: "Shahar-davlatlar mavjudligi",
              status: TestVertions.neutral),
          TestOptionModel(
              optionText:
                  "Kulolchilik charxida ishlangan sopol idishlar mavjudligi",
              status: TestVertions.neutral),
          TestOptionModel(
              optionText: "Bronzadan ishlangan o‘q uchlari",
              status: TestVertions.neutral),
        ]),
    TestModel(
        question:
            "... miloddan avvalgi VII-VI asrlardagi O‘rta Osiyo tarixiga xos emas.",
        options: [
          TestOptionModel(
              optionText: "Shaharlarda ichki qal’alar borligi",
              status: TestVertions.neutral),
          TestOptionModel(
              optionText: "Shahar-davlatlar mavjudligi",
              status: TestVertions.correct),
          TestOptionModel(
              optionText:
                  "Kulolchilik charxida ishlangan sopol idishlar mavjudligi",
              status: TestVertions.neutral),
          TestOptionModel(
              optionText: "Bronzadan ishlangan o‘q uchlari",
              status: TestVertions.neutral),
        ]),
    TestModel(
        question:
            "... miloddan avvalgi VII-VI asrlardagi O‘rta Osiyo tarixiga xos emas.",
        options: [
          TestOptionModel(
              optionText: "Shaharlarda ichki qal’alar borligi",
              status: TestVertions.incorrect),
          TestOptionModel(
              optionText: "Shahar-davlatlar mavjudligi",
              status: TestVertions.neutral),
          TestOptionModel(
              optionText:
                  "Kulolchilik charxida ishlangan sopol idishlar mavjudligi",
              status: TestVertions.neutral),
          TestOptionModel(
              optionText: "Bronzadan ishlangan o‘q uchlari",
              status: TestVertions.neutral),
        ]),
  ];
}

class AppIcons {
  static const String subFilled = "assets/sub_filled.png";
  static const String sub = "assets/sub.png";
  static const String sim = "assets/sim.png";

  static const String medlFilled = "assets/medl_filled.png";
  static const String medl = "assets/medl.png";

  static const String profileFilled = "assets/profile_filled.png";
  static const String profile = "assets/profile.png";

  static const String mistakesFilled = "assets/mistakes_filled.png";
  static const String mistakes = "assets/mistakes.png";

  static const String dtmFilled = "assets/dtm_filled.png";
  static const String dtm = "assets/dtm.png";
  static const String warning = "assets/warning.png";

  static const String bilim = "assets/bilim.png";

  static const String mobile = "assets/mobile.png";
  static const String noImage = "assets/no_image.png";
  static const String delete = "assets/delete.png";

  static const String purplePocket = "assets/wallet.png";
  static const String greenPocket = "assets/green.png";

  static const String bronze = "assets/bronze-medal.png";
  static const String silver = "assets/silver-medal.png";
  static const String gold = "assets/gold-medal.png";

  static const String drop = "assets/drop.png";

  static const String man = "assets/man.png";
  static const String tab = "assets/tab.png";
  static const String user = "assets/user.png";
  static const String borrow = "assets/borrow.png";

  static const String info = "assets/info.png";
  static const String arrow = "assets/arrow.png";
  static const String down = "assets/down.png";
  static const String star = "assets/star.png";
  static const String group = "assets/group.png";
  static const String gallery = "assets/gallery.png";
  static const String check = "assets/check.png";
  static const String purpleDone = "assets/done.png";
  static const String clock = "assets/clock.png";
  static const String menu = "assets/menu.png";
  static const String logout = "assets/logout.png";
  static const String payme = "assets/payme.png";
  static const String bigEnvy = "assets/envy.png";
  static const String bigGreenDone = "assets/envy.png";
  static const String arrowBack = "assets/arrow_back.png";
  static const String card = "assets/card.png";
  static const String news = "assets/news.png";
  static const String bell = "assets/bell.png";
  static const String bigNews = "assets/big_news.png";
  static const String greenSub = "assets/green_sub.png";
  static const String redSub = "assets/red_sub.png";
  static const String members = "assets/members.png";
  static const String purpleSub = "assets/purple_sub.png";
  static const String bi = "assets/bi.png";
  static const String errorImg = "assets/error.png";

  static const String arrowForward = "assets/arrow_forward.png";
  static const String white = "assets/white.png";
  static const String newsError = "assets/news_error.png";
}

class WarningValues {
  static const String smsDone = "smsDone";
  static const String subFirstDone = "subFirstDone";
  static const String subSecondDone = "subSecondDone";
  static const String fillBudget = "fillBudget";
  static const String warning = "warning";
  static const String hisobError = "hisobError";
  static const String internetError = "internetError";
  static const String authError = "authError";
  static const String obunaError = "authError";
}

class ApiValues {
  static const String baseUrl = "http://uzbilim.uz/api/";
  static const String sighUPUrl = "user/signup";
  static const String loginUrl = "user/login";
  static const String checkSmsUrl = "user/check-code";
  static const String logoutUrl = "user/logout";
  static const String changePasswordUrl = "user/new-password";
  static const String confirmSmsUrl = "user/check-code-password";
  static const String resetPasswordUrl = "user/reset-password";
  static const String createGroup = "user-group/create-group";

  static const String ratingUrl = "user/rating";

  static const String addCardUrl = "card/add-card";
  static const String amountUrl = "card/payment";
  static const String getCardsUrl = "card/index";
  static const String getErrorListUrl = "test/show-mistakes";

  static const String getScripts = "subjects/index";
  static const String getPreview = "subjects/view";
  static const String makeScript = "subjects/make-subscription";

  static const String getHistoryUrl = "user/payment-history";

  static const String subjectUrl = "subjects/show-subject";
  static const String innerTest = "test/questions";
  static const String getGroupMembers = "user-group/view";
  static const String sendTestAnswerUrl = "test/receive-answers";
  static const String getResults = "test/result";
  static const String getUserProfile = "user/profile";
  static const String mainNewsAndPaginationUrl = "news/index";
  static const String newsByIdUrl = "news/view";
  static const String getGroupByUserId = "user-group/index";
//Tests
  static const String testsBySubIdAndTypeIndex = "test/index";
}

class AppStorageConstants {
  static const String tokenKey = "token";
  static const String userKey = "user";
  static const String passwordKey = "password";
}
