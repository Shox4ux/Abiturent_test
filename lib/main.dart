import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/block/auth_block/auth_cubit.dart';
import 'package:test_app/core/block/group_block/group_cubit.dart';
import 'package:test_app/core/block/news_bloc/cubit/news_cubit.dart';
import 'package:test_app/core/block/payment_cubit/payment_cubit.dart';
import 'package:test_app/core/block/test_block/test_cubit.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import 'package:test_app/ui/splash/splash.dart';
import 'core/block/drawer_cubit/drawer_cubit.dart';
import 'core/block/subjecy_bloc/subject_cubit.dart';
import 'core/block/subscription_block/subscription_cubit.dart';
import 'core/block/user_block/user_cubit_cubit.dart';

void main() async {
  runApp(const MyApp());
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
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => GroupCubit(),
        ),
        BlocProvider(
          create: (context) => DrawerCubit(),
        ),
        BlocProvider(
          create: (context) => TestCubit(),
        ),
        BlocProvider(
          create: (context) => SubscriptionCubit(),
        ),
        BlocProvider(
          create: (context) => PaymentCubit(),
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
          home: const SplashScreen(),
          routes: navigation.routes,
          onGenerateRoute: navigation.onGenerateRoute,
        ),
      ),
    );
  }
}
