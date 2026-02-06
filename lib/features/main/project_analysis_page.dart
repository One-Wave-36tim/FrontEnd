import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../controller/home_controller.dart';

class ProjectAnalysisPage extends StatelessWidget {
  final int projectIndex;
  const ProjectAnalysisPage({super.key, required this.projectIndex});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    // Ensure project data exists or handle error
    if (controller.projects.length <= projectIndex) {
      return const Scaffold(body: Center(child: Text("프로젝트를 찾을 수 없습니다.")));
    }

    return Obx(() {
      final project = controller.projects[projectIndex];
      final title = project['title'] ?? 'N/A';
      final job = project['job'] ?? 'N/A';
      final startDate = project['startDate'] ?? '2025.04.01';

      // Completion Logic
      final hasResume = project['resume'] != null;
      final hasInterview = project['interview'] != null;
      final hasSimulation = project['simulation'] != null;

      final completedCount =
          [hasResume, hasInterview, hasSimulation].where((e) => e).length;

      String statusText = "진행 전";
      Color statusColor = Colors.grey.shade400;
      Color statusBg = Colors.grey.shade100;

      if (completedCount == 3) {
        statusText = "진행 완료";
        statusColor = Colors.green.shade700;
        statusBg = Colors.green.shade50;
      } else if (completedCount > 0) {
        statusText = "진행 중";
        statusColor = const Color(0xFF1E69FF);
        statusBg = const Color(0xFFEBF2FF);
      }

      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                size: 20, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: Text(
            "$title-$job",
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
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
              // Header Info
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text("D-7",
                          style: GoogleFonts.outfit(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                    Text("생성일: $startDate",
                        style: GoogleFonts.outfit(
                            color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 1. 취업 준비 단계 진행도
              _buildSectionCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("취업 준비 단계 진행도",
                            style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(statusText,
                              style: GoogleFonts.outfit(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildStepItem(
                      title: "작성한 자기소개서",
                      content: hasResume
                          ? project['resume']['title']
                          : "자기소개서가 없습니다",
                      isCompleted: hasResume,
                      onAction: () {
                        context.push('/resume_create/$projectIndex');
                      },
                      actionText: "생성",
                    ),
                    const SizedBox(height: 12),
                    _buildStepItem(
                      title: "모의면접 기록",
                      content: hasInterview
                          ? project['interview']['title']
                          : "기록이 없습니다",
                      score:
                          hasInterview ? project['interview']['score'] : null,
                      isCompleted: hasInterview,
                      onAction: () {
                        context.push('/interview');
                        controller.completeInterview(
                            projectIndex, "기술 면접 모의테스트", 85);
                      },
                      actionText: "시작하기",
                    ),
                    const SizedBox(height: 12),
                    _buildStepItem(
                      title: "직무 시뮬레이션",
                      content: hasSimulation
                          ? project['simulation']['title']
                          : "기록이 없습니다",
                      score:
                          hasSimulation ? project['simulation']['score'] : null,
                      isCompleted: hasSimulation,
                      onAction: () {
                        context.push('/simulation');
                        controller.completeSimulation(
                            projectIndex, "퇴근 전 심각한 버그 발생 상황", 85);
                      },
                      actionText: "시작하기",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 2. 내가 한 프로젝트
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("내가 한 프로젝트",
                        style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    TextButton(
                        onPressed: () {},
                        child: Text("대표 설정",
                            style: GoogleFonts.outfit(
                                color: const Color(0xFF1E69FF)))),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildMyProjectsGrid(project['myProjects'] ?? []),

              const SizedBox(height: 32),

              // 3. Footer Button
              _buildFooter(context, completedCount == 3),
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: child,
    );
  }

  Widget _buildStepItem({
    required String title,
    required String content,
    bool isCompleted = false,
    int? score,
    required VoidCallback onAction,
    required String actionText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500)),
              if (!isCompleted)
                InkWell(
                  onTap: onAction,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF2FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(actionText,
                        style: GoogleFonts.outfit(
                            color: const Color(0xFF1E69FF),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  content,
                  style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.black : Colors.grey.shade300),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isCompleted) ...[
                if (score != null)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text("$score점",
                        style: GoogleFonts.outfit(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 11)),
                  ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios,
                    size: 14, color: Colors.grey),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyProjectsGrid(List<dynamic> myProjects) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: myProjects.length + 1,
        itemBuilder: (context, index) {
          if (index == myProjects.length) {
            return _buildAddProjectCard();
          }
          final p = myProjects[index];
          return _buildMyProjectCard(p);
        },
      ),
    );
  }

  Widget _buildMyProjectCard(Map<String, dynamic> p) {
    bool isMain = p['type'] == '대표';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isMain
                ? const Color(0xFF1E69FF).withOpacity(0.3)
                : Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color:
                        isMain ? const Color(0xFFEBF2FF) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4)),
                child: Text(p['type'] ?? '보조',
                    style: GoogleFonts.outfit(
                        color: isMain ? const Color(0xFF1E69FF) : Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
              if (isMain)
                const Icon(Icons.check_circle,
                    color: Color(0xFF1E69FF), size: 18)
              else
                const Icon(Icons.more_horiz, color: Colors.grey, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(p['title'] ?? 'Title',
              style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(p['tech'] ?? 'Tech',
              style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
          const Spacer(),
          Text(p['date'] ?? 'Date',
              style: GoogleFonts.outfit(
                  color: Colors.grey.shade400, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildAddProjectCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text("프로젝트 추가",
                style: GoogleFonts.outfit(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isAllCompleted) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF2FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child:
                    const Icon(Icons.star, color: Color(0xFF1E69FF), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("모든 준비가 완료되었어요!",
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text("AI가 분석한 최종 피드백을 확인하세요.",
                      style: GoogleFonts.outfit(
                          color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (isAllCompleted) {
                  Get.snackbar("성공", "최종 피드백 화면으로 이동합니다.");
                } else {
                  Get.snackbar("알림", "모든 단계를 완료해주세요.",
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E69FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("최종 피드백 보러가기",
                      style: GoogleFonts.outfit(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
