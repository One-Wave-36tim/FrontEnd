import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme.dart';
import 'package:flutter_application_1/features/auth/login_page.dart';
import 'package:flutter_application_1/features/auth/signup_id_password_page.dart';
import 'package:flutter_application_1/features/auth/start_page.dart';
import 'package:flutter_application_1/features/main/main_page.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'features/controller/home_controller.dart';
import 'features/controller/theme_controller.dart';

void main() {
  // GetX 컨트롤러 초기화
  Get.put(HomeController());
  Get.put(ThemeController());

  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: "/start",
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const MainPage();
      },
    ),
    GoRoute(
      path: '/start',
      builder: (context, state) {
        return const StartPage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/signup_idpassword',
      builder: (context, state) {
        return const SignupIdpasswordPage();
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Prologue App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: _router,
    );
  }
}
