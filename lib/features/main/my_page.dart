import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../controller/home_controller.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

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
        title: Text('마이페이지',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.black)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined, color: Colors.black)),
        ],
      ),
      body: Obx(() {
        final name = controller.userName.value.isEmpty
            ? "김지원"
            : controller.userName.value;
        final job = controller.userJob.value.isEmpty
            ? "프론트엔드 개발자"
            : controller.userJob.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 프로필 섹션
              _buildProfileHeader(name),
              const SizedBox(height: 32),

              // 2. 기본 정보 섹션
              _buildSectionCard(
                title: "기본 정보",
                child: Column(
                  children: [
                    _buildInfoRow("내가 원하는 직무", job, isBold: true),
                    _buildInfoRow("취업 준비 시작일", "2024.08"),
                    _buildInfoRow("목표", "2025년 상반기 취업", isBold: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. 모의면접 기록 섹션 (차트 포함)
              _buildSectionCard(
                title: "모의면접 기록",
                actionText: "전체 보기",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("종합 점수 추이",
                            style: GoogleFonts.outfit(
                                fontSize: 13, color: Colors.grey)),
                        Text("78점",
                            style: GoogleFonts.outfit(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildBarChart(
                        [0.4, 0.6, 0.75, 0.65, 0.85], const Color(0xFF1E69FF)),
                    const SizedBox(height: 20),
                    _buildProgressRow("면접 완료", 12, 15, const Color(0xFF1E69FF)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. 직무 시뮬레이션 기록 섹션
              _buildSectionCard(
                title: "직무 시뮬레이션 기록",
                actionText: "분석 보기",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("미션 해결률 추이",
                            style: GoogleFonts.outfit(
                                fontSize: 13, color: Colors.grey)),
                        Text("92%",
                            style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF10B981))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildBarChart(
                        [0.7, 0.8, 0.65, 0.9, 0.92], const Color(0xFF10B981)),
                    const SizedBox(height: 20),
                    _buildProgressRow("미션 클리어", 5, 6, const Color(0xFF10B981)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5. AI 코칭 섹션
              _buildAiCoachingCard(),
              const SizedBox(height: 32),

              // 6. 다음 목표 & 업적 (추천 아이디어)
              _buildMilestoneSection(),
              const SizedBox(height: 32),

              // 7. 활동 통계
              Text("활동 통계",
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildStatBox("48", "이력서 작성"),
                  _buildStatBox("23", "자소서 작성"),
                  _buildStatBox("12", "모의면접"),
                  _buildStatBox("156", "학습 시간(시간)"),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(String name) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade100, width: 4),
            image: const DecorationImage(
              image: NetworkImage(
                  'https://api.dicebear.com/7.x/avataaars/png?seed=Support'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold, fontSize: 24)),
            Text("AI 취업 코칭 중",
                style: GoogleFonts.outfit(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF2FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text("프리미엄 회원",
                      style: GoogleFonts.outfit(
                          color: const Color(0xFF1E69FF),
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Text("•  활동 128일차",
                    style:
                        GoogleFonts.outfit(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionCard(
      {required String title, String? actionText, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              if (actionText != null)
                Text(actionText,
                    style: GoogleFonts.outfit(
                        color: const Color(0xFF1E69FF), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey)),
          Text(value,
              style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<double> values, Color primaryColor) {
    final List<String> labels = ["1월", "2월", "3월", "4월", "5월"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(values.length, (index) {
        return Column(
          children: [
            Container(
              width: 36,
              height: 80 * values[index],
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    primaryColor.withOpacity(0.8),
                    primaryColor.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Text(labels[index],
                style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey)),
          ],
        );
      }),
    );
  }

  Widget _buildProgressRow(String label, int current, int total, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.outfit(fontSize: 13)),
            Text("$current회",
                style: GoogleFonts.outfit(
                    fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: current / total,
            backgroundColor: color.withOpacity(0.1),
            color: color,
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("취업 준비 마일스톤",
            style:
                GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emoji_events,
                    color: Colors.amber, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("다음 칭호: '면접의 달인'",
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    const SizedBox(height: 4),
                    Text("모의면접 3회 더 진행하면 획득!",
                        style: GoogleFonts.outfit(
                            fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.white24, size: 14),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAiCoachingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.smart_toy_outlined,
                    color: Color(0xFF1E69FF), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("AI 코칭 진행 중",
                        style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text("이번 주 면접 연습 2회를 권장합니다. 취업 준비 계획을 확인해보세요.",
                        style: GoogleFonts.outfit(
                            fontSize: 12, color: Colors.grey.shade700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E69FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text("코칭 계획 보기",
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
