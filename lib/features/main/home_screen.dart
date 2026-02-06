import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/home_controller.dart';
import '../controller/theme_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>(); // 테마 컨트롤러 찾기

    // 테마에 따른 동적 색상 가져오기
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final subTextColor = isDark ? Colors.grey[400] : const Color(0xFF666666);

    return Scaffold(
      // 우측 상단에 테마 전환 버튼 추가 (테스트용)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeController.toggleTheme,
            tooltip: "테마 변경",
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.symmetric(
                vertical: 40, horizontal: 20), // 상단 여백 조정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildBadge(context),
                const SizedBox(height: 30),
                Text(
                  "당신의 커리어 여정,\n여기서 완성됩니다.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: textColor, // 테마 색상 적용
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "자기소개서부터 실전 면접, 직무 시뮬레이션까지 단 한 번에 준비하세요.\n취준생을 위한 가장 체계적인 솔루션.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansKr(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: subTextColor, // 테마 색상 적용
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 50),
                _buildCtaButton(context),
                const SizedBox(height: 120),
                _buildStepSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildBadge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        // 다크모드면 약간 밝은 회색, 라이트모드면 연한 회색
        color: isDark ? Colors.grey[800] : const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Text(
            "취업 준비의 모든 단계",
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              // 텍스트 색상도 테마에 따라 자동 변경
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCtaButton(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 200,
      child: ElevatedButton(
        onPressed: controller.onStartClick,
        // 스타일은 AppTheme에서 정의했으므로 여기서는 간단히 적용됨
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "지금 시작하기",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStepSection(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepItem(
              context, "STEP 01", "자기소개서 작성", Icons.edit_note_rounded, true),
          _buildDivider(context),
          _buildStepItem(
              context, "STEP 02", "모의면접", Icons.videocam_rounded, false),
          _buildDivider(context),
          _buildStepItem(
              context, "STEP 03", "직무 시뮬레이션", Icons.laptop_mac_rounded, false),
          _buildDivider(context),
          _buildStepItem(
              context, "STEP 04", "결과 리포트", Icons.analytics_rounded, false),
        ],
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, String step, String title,
      IconData icon, bool isActive) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 활성화/비활성화 색상 계산
    final activeColor = Theme.of(context).primaryColor; // 흑/백
    final inactiveColor = isDark ? Colors.grey[700]! : const Color(0xFFCCCCCC);
    final boxBgColor = Theme.of(context).cardColor;
    final borderColor = isActive
        ? activeColor
        : (isDark ? Colors.grey[800]! : const Color(0xFFEEEEEE));

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: boxBgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      // 그림자 색상도 다크모드 대응
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Icon(
            icon,
            size: 36,
            color: isActive ? activeColor : inactiveColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          step,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey, // Step 텍스트는 옅게 유지
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isActive
                ? Theme.of(context).textTheme.bodyLarge?.color
                : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 60,
      height: 80,
      alignment: Alignment.center,
      child: Container(
        height: 1,
        // 구분선 색상 변경
        color: isDark ? Colors.grey[800] : const Color(0xFFEEEEEE),
      ),
    );
  }
}
