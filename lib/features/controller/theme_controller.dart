import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // 현재 다크모드인지 확인하는 변수
  var isDarkMode = false.obs;

  // 테마 전환 함수
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;

    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
