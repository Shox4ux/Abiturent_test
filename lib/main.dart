import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:test_app/core/bloc/app_bar_cubit/app_bar_cubit.dart';
import 'package:test_app/core/bloc/dtm_cubit/dtm_cubit.dart';
import 'package:test_app/core/bloc/test_cubit/test_cubit.dart';
import 'package:test_app/res/navigation/main_navigation.dart';
import 'package:test_app/ui/splash/splash.dart';
import 'core/bloc/auth_cubit/auth_cubit.dart';
import 'core/bloc/book_cubit/book_cubit.dart';
import 'core/bloc/drawer_cubit/drawer_cubit.dart';
import 'core/bloc/group_cubit/group_cubit.dart';
import 'core/bloc/inner_test_cubit/inside_test_cubit.dart';
import 'core/bloc/mistakes_cubit/mistakes_cubit.dart';
import 'core/bloc/payment_cubit/payment_cubit.dart';
import 'core/bloc/rating_cubit/rating_cubit.dart';
import 'core/bloc/subscription_cubit/subscription_cubit.dart';
import 'core/bloc/user_cubit/user_cubit.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());

  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation = MainNavigation();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: true,
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => DtmCubit(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => AppBarCubit(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => InnerTestCubit(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => BookCubit(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => GroupCubit(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => DrawerCubit(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => TestCubit(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => RatingCubit(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => MistakesCubit(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => SubscriptionCubit(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => PaymentCubit(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(376, 812),
        builder: (BuildContext context, Widget? child) => MaterialApp(
          debugShowCheckedModeBanner: false,
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
