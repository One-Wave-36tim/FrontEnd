import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme.dart';
import 'package:flutter_application_1/features/auth/login_page.dart';
import 'package:flutter_application_1/features/auth/signup_id_password_page.dart';
import 'package:flutter_application_1/features/auth/start_page.dart';
import 'package:flutter_application_1/features/main/main_page.dart';
import 'package:flutter_application_1/features/main/my_page.dart';
import 'package:flutter_application_1/features/main/profile_edit_page.dart';
import 'package:flutter_application_1/features/main/project_create_page.dart';
import 'package:flutter_application_1/features/main/project_analysis_page.dart';
import 'package:flutter_application_1/features/main/prep_pages.dart';
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
    GoRoute(
      path: '/mypage',
      builder: (context, state) {
        return const MyPage();
      },
    ),
    GoRoute(
      path: '/profile_edit',
      builder: (context, state) {
        return const ProfileEditPage();
      },
    ),
    GoRoute(
      path: '/project_create',
      builder: (context, state) {
        return const ProjectCreatePage();
      },
    ),
    GoRoute(
      path: '/project_analysis/:index',
      builder: (context, state) {
        final index = int.parse(state.pathParameters['index']!);
        return ProjectAnalysisPage(projectIndex: index);
      },
    ),
    GoRoute(
      path: '/resume_create/:index',
      builder: (context, state) {
        final index = int.parse(state.pathParameters['index']!);
        return ResumeIntroPage(projectIndex: index);
      },
    ),
    GoRoute(
      path: '/resume_interview/:index',
      builder: (context, state) {
        final index = int.parse(state.pathParameters['index']!);
        return ResumeInterviewPage(projectIndex: index);
      },
    ),
    GoRoute(
      path: '/resume_writing/:index',
      builder: (context, state) {
        final index = int.parse(state.pathParameters['index']!);
        return ResumeWritingPage(projectIndex: index);
      },
    ),
    GoRoute(
      path: '/interview/:index',
      builder: (context, state) {
        final index = int.parse(state.pathParameters['index']!);
        return InterviewIntroPage(projectIndex: index);
      },
    ),
    GoRoute(
      path: '/interview_session/:index',
      builder: (context, state) {
        final index = int.parse(state.pathParameters['index']!);
        return InterviewSessionPage(projectIndex: index);
      },
    ),
    GoRoute(
      path: '/simulation',
      builder: (context, state) => const SimulationPage(),
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
