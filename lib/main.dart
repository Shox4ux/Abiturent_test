import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/block/auth_block/auth_cubit.dart';
import 'package:test_app/core/block/news_bloc/cubit/news_cubit.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/ui/auth/forgot_password.dart';
import 'package:test_app/ui/auth/login.dart';
import 'package:test_app/ui/bottom_navigation/profile/profile_sections/group/group.dart';
import 'package:test_app/ui/bottom_navigation/subjects/subject_screen.dart';
import 'package:test_app/ui/main_page/main_page.dart';
import 'package:test_app/ui/navigation/main_navigation.dart';
import 'package:test_app/ui/splash/splash.dart';

import 'core/block/subjecy_bloc/subject_cubit.dart';

void main() async {
  runApp(const MyApp());

  final r = AppStorage();

  print(await r.getToken());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final navigation = MainNavigation();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => NewsCubit(),
        ),
        BlocProvider(
          create: (context) => SubjectCubit(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(376, 812),
        builder: (BuildContext context, Widget? child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const LoginScreen(),
          routes: navigation.routes,
          onGenerateRoute: navigation.onGenerateRoute,
        ),
      ),
    );
  }
}
