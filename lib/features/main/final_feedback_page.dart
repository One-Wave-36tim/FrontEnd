import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class FinalFeedbackPage extends StatelessWidget {
  final int projectIndex;
  const FinalFeedbackPage({super.key, required this.projectIndex});

  @override
  Widget build(BuildContext context) {
    Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFEBF2FF),
              child: const Icon(Icons.smart_toy_outlined,
                  color: Color(0xFF1E69FF), size: 18),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("AI 취업 코칭",
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black)),
                Text("종합 리포트",
                    style:
                        GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // 종합 평가 점수 카드
            _buildScoreCard(),

            const SizedBox(height: 32),
            // 모든 피드백 요약
            _buildSectionHeader("모든 피드백 요약", onSeeAll: () {}),
            _buildFeedbackSummary(),

            const SizedBox(height: 32),
            // 자소서 추천 문구
            _buildSectionHeader("자소서 추천 문구"),
            _buildResumeSuggestion(),

            const SizedBox(height: 32),
            // 추천 프로젝트
            _buildSectionHeader("추천 프로젝트", onSeeAll: () {}),
            _buildRecommendedProjects(),

            const SizedBox(height: 32),
            // 추천 소프트 스킬
            _buildSectionHeader("추천 소프트 스킬"),
            _buildSoftSkills(),

            const SizedBox(height: 32),
            // 추천 루틴 카드
            _buildRoutineCard(context),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("종합 평가 점수",
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Text("AI 분석 완료",
                    style: GoogleFonts.outfit(
                        color: const Color(0xFF1E69FF),
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: 0.87,
                  strokeWidth: 12,
                  backgroundColor: Colors.white,
                  color: const Color(0xFF1E69FF),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  Text("87",
                      style: GoogleFonts.outfit(
                          fontSize: 48, fontWeight: FontWeight.bold)),
                  Text("점",
                      style:
                          GoogleFonts.outfit(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildGradeItem("자소서", "A+"),
              _buildGradeItem("프로젝트", "B+"),
              _buildGradeItem("스킬", "A-"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradeItem(String label, String grade) {
    return Column(
      children: [
        Text(grade,
            style:
                GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold, fontSize: 17)),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: Text("전체 보기",
                  style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            icon: Icons.check_circle,
            iconColor: Colors.green,
            title: "강점 분석",
            content: "프로젝트 관리 경험이 풍부하고 커뮤니케이션 능력이 뛰어납니다.",
          ),
          const SizedBox(height: 20),
          _buildSummaryRow(
            icon: Icons.lightbulb,
            iconColor: Colors.amber,
            title: "개선 필요",
            content: "기술 스택 다양화가 필요하며 포트폴리오 정리가 부족합니다.",
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(content,
                  style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResumeSuggestion() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF2FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote, color: Color(0xFF1E69FF), size: 32),
          const SizedBox(height: 8),
          Text(
            "\"다양한 이해관계자와의 협업을 통해 프로젝트 일정을 30% 단축한 경험을 바탕으로, 체계적인 계획 수립과 효율적인 커뮤니케이션으로 조직의 생산성을 향상시키겠습니다.\"",
            style: GoogleFonts.outfit(
                fontSize: 14, height: 1.6, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("AI 생성 문구",
                  style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.copy, size: 14),
                label: Text("복사하기",
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold, fontSize: 12)),
                style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1E69FF)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedProjects() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildProjectSmallCard(
              "데이터 대시보드", "실시간 시각화 프로젝트", Colors.blue.shade50, Colors.blue),
          const SizedBox(width: 12),
          _buildProjectSmallCard("모바일 앱 리뉴얼", "UX/UI 개선 프로젝트",
              Colors.purple.shade50, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildProjectSmallCard(
      String title, String sub, Color bg, Color iconColor) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: bg, borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.bar_chart, color: iconColor, size: 20),
          ),
          const SizedBox(height: 16),
          Text(title,
              style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(sub,
              style: GoogleFonts.outfit(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSoftSkills() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildSkillChip(
              "리더십", const Color(0xFFEBF2FF), const Color(0xFF1E69FF)),
          _buildSkillChip(
              "문제 해결", const Color(0xFFE7F9F0), const Color(0xFF2ECC71)),
          _buildSkillChip(
              "의사소통", const Color(0xFFF3E8FF), const Color(0xFF9B59B6)),
          _buildSkillChip(
              "협업", const Color(0xFFFFF7E6), const Color(0xFFF39C12)),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: GoogleFonts.outfit(
              color: text, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _buildRoutineCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("주간 성장 루틴",
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("AI 맞춤형 추천",
                        style: GoogleFonts.outfit(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.calendar_today,
                      color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
          _buildRoutineCheckItem("매일 30분 기술 학습"),
          _buildRoutineCheckItem("주 2회 네트워킹"),
          _buildRoutineCheckItem("포트폴리오 정리"),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1E69FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text("루틴 시작하기",
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Color(0xFF1E69FF), size: 14),
          ),
          const SizedBox(width: 12),
          Text(text,
              style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
