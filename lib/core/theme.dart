import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 1. 라이트 테마 (White Background, Black Text)
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,

    // 텍스트 테마 (기본 검정)
    textTheme: GoogleFonts.notoSansKrTextTheme(
      ThemeData.light().textTheme.apply(
            bodyColor: Colors.black,
            displayColor: Colors.black,
          ),
    ),

    // 버튼 테마 (검은 버튼, 흰 글씨)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    ),

    // 아이콘 색상
    iconTheme: const IconThemeData(color: Colors.black),

    // 카드/컨테이너 색상
    cardColor: Colors.white,
    dividerColor: const Color(0xFFEEEEEE),
  );

  // 2. 다크 테마 (Black Background, White Text)
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212), // 완전 검정보다 눈이 편한 다크 그레이
    primaryColor: Colors.white,

    // 텍스트 테마 (기본 흰색)
    textTheme: GoogleFonts.notoSansKrTextTheme(
      ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
    ),

    // 버튼 테마 (흰 버튼, 검은 글씨)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    ),

    // 아이콘 색상
    iconTheme: const IconThemeData(color: Colors.white),

    // 카드/컨테이너 색상
    cardColor: const Color(0xFF1E1E1E),
    dividerColor: const Color(0xFF333333),
  );
}
