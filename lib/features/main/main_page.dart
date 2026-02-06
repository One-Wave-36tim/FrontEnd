import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../controller/home_controller.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Prologue',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              backgroundImage: const NetworkImage(
                'https://api.dicebear.com/7.x/avataaars/png?seed=Felix',
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 내 정보 섹션
            Obx(() => _buildInfoCard(context, controller)),
            const SizedBox(height: 24),

            // 2. 나의 지원 프로젝트 섹션
            _buildSectionHeader(
              title: "나의 지원 프로젝트",
              onActionPressed: () => context.push('/project_create'),
            ),
            const SizedBox(height: 12),
            Obx(() => _buildProjectList(context, controller)),
            const SizedBox(height: 24),

            // 3. 오늘의 추천 루틴 섹션
            Text(
              "오늘의 루틴",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => _buildRoutineCard(controller)),
            const SizedBox(height: 100), // FAB 및 하단 여백 가독성 확보
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Center(
              child: Text(
                'Prologue',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('메인 화면'),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('마이페이지'),
            onTap: () {
              Navigator.pop(context);
              context.push('/mypage');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, HomeController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: controller.hasUserInfo.value
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.userName.value,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        controller.userCareer.value,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  controller.userJob.value,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => context.push('/profile_edit'),
                  child: Row(
                    children: [
                      Icon(Icons.edit_note,
                          color: Colors.grey.shade400, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '정보 수정하기',
                        style: GoogleFonts.outfit(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: () => context.push('/profile_edit'),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.add_circle_outline,
                        color: Colors.grey.shade300, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      "나의 정보 입력",
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(
      {required String title, required VoidCallback onActionPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: onActionPressed,
          icon: const Icon(Icons.add_circle, color: Colors.black, size: 28),
        ),
      ],
    );
  }

  Widget _buildProjectList(BuildContext context, HomeController controller) {
    if (!controller.hasProjects.value) {
      return Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
        ),
        child: Center(
          child: Text(
            "내역이 없습니다",
            style: GoogleFonts.outfit(color: Colors.grey.shade400),
          ),
        ),
      );
    }

    return Column(
      children: controller.projects
          .asMap()
          .entries
          .map((entry) => _buildProjectCard(context, entry.key, entry.value))
          .toList(),
    );
  }

  Widget _buildProjectCard(
      BuildContext context, int index, Map<String, dynamic> project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${project['title']} · ${project['job']}',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '진행 중',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: const Color(0xFF1E69FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${project['startDate']} 시작',
            style:
                GoogleFonts.outfit(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('전체 진행률',
                  style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
              Text('${project['progress']}%',
                  style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: project['progress'] / 100,
            backgroundColor: Colors.grey.shade100,
            color: Colors.blueGrey.shade900,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              Text('D-14',
                  style: GoogleFonts.outfit(
                      fontSize: 13, color: Colors.grey.shade600)),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              Text('최근 활동: 2시간 전',
                  style: GoogleFonts.outfit(
                      fontSize: 13, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                context.push('/project_analysis/$index');
              },
              icon: const Icon(Icons.psychology_outlined, size: 20),
              label: Text("AI 심층 분석 시작",
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1E69FF),
                side: const BorderSide(color: Color(0xFF1E69FF)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineCard(HomeController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: controller.hasProjects.value
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '오늘의 추천 행동',
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ...controller.routines.asMap().entries.map((entry) {
                  final index = entry.key;
                  final routine = entry.value;
                  return _buildRoutineItem(
                    routine['title'],
                    routine['isCompleted'],
                    () => controller.toggleRoutine(index),
                  );
                }).toList(),
              ],
            )
          : Center(
              child: Text(
                "프로젝트를 제작하면 추천해드립니다",
                style: GoogleFonts.outfit(color: Colors.grey.shade400),
              ),
            ),
    );
  }

  Widget _buildRoutineItem(String title, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected ? const Color(0xFF1E69FF) : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1E69FF)
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: isSelected ? Colors.black87 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
