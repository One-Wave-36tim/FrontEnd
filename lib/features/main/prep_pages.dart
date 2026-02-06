import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../controller/home_controller.dart';

// --- 1. 자소서 안내 화면 ---
class ResumeIntroPage extends StatelessWidget {
  final int projectIndex;
  const ResumeIntroPage({super.key, required this.projectIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.description,
                  size: 16, color: Color(0xFF1E69FF)),
            ),
            const SizedBox(width: 12),
            Text('자소서 프로세스',
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.person, size: 20, color: Colors.grey),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text("AI와 함께하는 자소서 작성 과정",
                style: GoogleFonts.outfit(
                    fontSize: 22, fontWeight: FontWeight.bold, height: 1.3)),
            const SizedBox(height: 12),
            Text("단계별로 당신의 경험을 깊이 있게 탐구하고 설득력 있는 자소서로 완성합니다.",
                style: GoogleFonts.outfit(
                    fontSize: 14, color: Colors.black54, height: 1.5)),
            const SizedBox(height: 32),
            _buildProcessStep(
              number: "1",
              title: "AI가 질문으로 사고를 끌어냄",
              description:
                  "표면적인 설명을 넘어 문제 해결 과정, 협업 방식, 성과 측정 등 심층적인 인사이트를 이끌어내는 질문을 합니다.",
              badgeIcon: Icons.chat_bubble_outline,
              badgeText: "대화형 탐구",
            ),
            const SizedBox(height: 16),
            _buildProcessStep(
              number: "2",
              title: "대필은 하지 않음",
              description:
                  "AI는 당신의 경험을 바탕으로 질문을 생성하며, 직접 작성한 내용을 개선하는 데 도움을 줍니다. 완성된 글을 대신 작성하지 않습니다.",
              badgeIcon: Icons.person_outline,
              badgeText: "자기주도 작성",
            ),
            const SizedBox(height: 16),
            _buildProcessStep(
              number: "3",
              title: "심층 탐구 -> 개선 가이드 구조",
              description:
                  "AI가 수집한 답변을 바탕으로 자소서 초안의 구체성과 설득력을 높이는 개선 가이드를 제공합니다.",
              badgeIcon: Icons.auto_graph_outlined,
              badgeText: "구조적 개선",
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F6FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb,
                      color: Color(0xFF1E69FF), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("프로세스 진행 안내",
                            style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text(
                          "각 단계는 평균 10-15분 소요됩니다. 중간에 저장되며 이어서 진행할 수 있습니다. AI의 질문에 최대한 구체적으로 답변할수록 더 풍부한 자소서 개선 가이드를 받을 수 있습니다.",
                          style: GoogleFonts.outfit(
                              fontSize: 12, color: Colors.black54, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                context.push('/resume_interview/$projectIndex');
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text("프로세스 시작하기",
                  style: GoogleFonts.outfit(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E69FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessStep({
    required String number,
    required String title,
    required String description,
    required IconData badgeIcon,
    required String badgeText,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFEBF2FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number,
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E69FF))),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(title,
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Text(description,
                    style: GoogleFonts.outfit(
                        fontSize: 14, color: Colors.black54, height: 1.5)),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badgeIcon, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(badgeText,
                          style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- 2. 심층 인터뷰 화면 ---
class ResumeInterviewPage extends StatefulWidget {
  final int projectIndex;
  const ResumeInterviewPage({super.key, required this.projectIndex});

  @override
  State<ResumeInterviewPage> createState() => _ResumeInterviewPageState();
}

class _ResumeInterviewPageState extends State<ResumeInterviewPage> {
  int currentIndex = 0;
  final int totalQuestions = 10;

  final List<Map<String, dynamic>> questions = [
    {
      "question": "이 프로젝트에서 가장 복잡했던 기술적 결정은 무엇이었나요?",
      "examples": [
        "당시 선택하지 않은 다른 방법은 무엇이었고 왜 배제했나요?",
        "당신의 코드가 전체 시스템에 어떤 영향을 주었나요?"
      ]
    },
    {
      "question": "프로젝트 도중 발생한 가장 큰 갈등 상황과 이를 해결한 방법은 무엇인가요?",
      "examples": ["팀원과의 의견 차이가 있었나요?", "데이터나 근거를 바탕으로 어떻게 설득했나요?"]
    },
    {
      "question": "해당 직무에서 가장 중요하다고 생각하는 역량을 이 프로젝트에서 어떻게 발휘했나요?",
      "examples": ["문제 해결 능력인가요, 아니면 협업 능력인가요?", "구체적인 수치나 성과가 있다면 무엇인가요?"]
    },
    {
      "question": "프로젝트 결과물에서 가장 아쉬운 점과 다시 한다면 개선하고 싶은 부분은?",
      "examples": ["기술적 부채가 남았나요?", "시간적 제약 때문에 포기한 기능이 있나요?"]
    },
    {
      "question": "사용자의 피드백을 받아 서비스를 개선했던 경험이 있나요?",
      "examples": ["어떤 경로로 피드백을 받았나요?", "피드백을 어떻게 우선순위에 반영했나요?"]
    },
    {
      "question": "이 프로젝트를 통해 새롭게 습득한 기술이나 지식은 무엇인가요?",
      "examples": ["학습 과정에서 가장 어려웠던 점은?", "현재 실무에서 어떻게 활용하고 있나요?"]
    },
    {
      "question": "성능 최적화를 위해 시도했던 구체적인 노력이 있다면?",
      "examples": ["로딩 속도 개선인가요, 아니면 메모리 절약인가요?", "최적화 전후의 지표 차이는 어떠했나요?"]
    },
    {
      "question": "코드 리뷰 과정에서 팀원으로부터 받은 가장 기억에 남는 조언은?",
      "examples": ["본인의 코드 스타일을 어떻게 바꾸었나요?", "협업 효율을 위해 어떤 노력을 했나요?"]
    },
    {
      "question": "프로젝트 일정 관리를 위해 본인이 기여한 바는 무엇인가요?",
      "examples": [
        "마감 기한을 지키기 위해 무엇을 포기하거나 강조했나요?",
        "도구(Jira, Notion 등)를 어떻게 활용했나요?"
      ]
    },
    {
      "question": "본인이 작성한 코드의 테스트 및 검증은 어떻게 진행했나요?",
      "examples": ["단위 테스트를 작성했나요?", "엣지 케이스는 어떻게 고려했나요?"]
    }
  ];

  final TextEditingController _answerController = TextEditingController();

  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        _answerController.clear();
      });
    } else {
      // 마지막 질문 완료 시 작성 페이지로 이동
      context.push('/resume_writing/${widget.projectIndex}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentIndex];

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
        title: Text('프로젝트 심층 인터뷰',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.person, size: 20, color: Colors.grey),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("질문 진행",
                    style: GoogleFonts.outfit(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                Text("${currentIndex + 1} / ${questions.length}",
                    style: GoogleFonts.outfit(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (currentIndex + 1) / questions.length,
                backgroundColor: Colors.grey.shade100,
                color: const Color(0xFF1E69FF),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 32),
            Container(
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
                      offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: const Color(0xFFEBF2FF),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.smart_toy_outlined,
                            color: Color(0xFF1E69FF), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("AI 인터뷰어",
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("심층 분석 질문",
                              style: GoogleFonts.outfit(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    q["question"],
                    style: GoogleFonts.outfit(
                        fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text("예시 질문 유형:",
                      style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  ...(q["examples"] as List).map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildExampleBullet(e),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text("답변 입력",
                style: GoogleFonts.outfit(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _answerController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText:
                          "질문에 대한 답변을 자세히 작성해 주세요. 구체적인 사례와 데이터를 포함하면 더 좋습니다.",
                      hintStyle: GoogleFonts.outfit(
                          color: Colors.grey.shade400, fontSize: 14),
                      contentPadding: const EdgeInsets.all(20),
                      border: InputBorder.none,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Color(0xFFEBF2FF), shape: BoxShape.circle),
                        child: const Icon(Icons.mic,
                            color: Color(0xFF1E69FF), size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("최소 200자 권장",
                    style:
                        GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
                Text("0 / 200",
                    style:
                        GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.pause, size: 20),
                    label: Text("일시 정지",
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
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
                        Text(
                            currentIndex < questions.length - 1
                                ? "다음 질문"
                                : "인터뷰 완료",
                            style: GoogleFonts.outfit(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                  color: Colors.grey, shape: BoxShape.circle)),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Text(text,
                style: GoogleFonts.outfit(
                    fontSize: 13, color: Colors.black54, height: 1.5))),
      ],
    );
  }
}

// --- 3. 자소서 작성 화면 ---
class ResumeWritingPage extends StatefulWidget {
  final int projectIndex;
  const ResumeWritingPage({super.key, required this.projectIndex});

  @override
  State<ResumeWritingPage> createState() => _ResumeWritingPageState();
}

class _ResumeWritingPageState extends State<ResumeWritingPage> {
  bool isAnalysisExpanded = true;
  final TextEditingController _resumeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: const Color(0xFFEBF2FF),
              borderRadius: BorderRadius.circular(8)),
          child:
              const Icon(Icons.description, size: 16, color: Color(0xFF1E69FF)),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('자소서 작성',
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black)),
            Text('문단별 작성 및 분석',
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.close, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 심층 질문 분석 결과 아코디언
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 20,
                      offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => setState(
                        () => isAnalysisExpanded = !isAnalysisExpanded),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Color(0xFFEBF2FF),
                                shape: BoxShape.circle),
                            child: const Icon(Icons.search,
                                color: Color(0xFF1E69FF), size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("심층 질문 분석 결과",
                                    style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Text("이 문단에 대한 핵심 질문 3개",
                                    style: GoogleFonts.outfit(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Icon(
                              isAnalysisExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  if (isAnalysisExpanded) ...[
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("프로젝트 심층 인터뷰 결과",
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 20),
                          _buildAnalysisResultItem(
                            icon: Icons.lightbulb_outline,
                            title: "핵심 질문 1: 프로젝트 참여 동기 및 역할",
                            content:
                                "프로젝트 참여 동기하는 것이와 캐드익스섹를 종기 및 역을 건과 한고, 중계룩 복판과 한고 있는 참여 역할. 프로젝트 참여있더의 역할을 작이하면 분석적를 안해 보고졌고 이 거되어 추척하지 않아한다.",
                          ),
                          const SizedBox(height: 16),
                          _buildAnalysisResultItem(
                            icon: Icons.people_outline,
                            title: "핵심 질문 2: 협업 경험 및 갈등 해결",
                            content:
                                "협업 경험과 테어스 어낸봄, 7에게 중복하고 갖혔하고 별공적으로 인터뷰를 위한 해보는: 갈과동의 협업 갈등을 토한 해도르 드리다: 순조비 파동아있고, 협업고 1차여 갈정합니다.",
                          ),
                          const SizedBox(height: 16),
                          _buildAnalysisResultItem(
                            icon: Icons.emoji_events_outlined,
                            title: "핵심 질문 3: 성과 및 배운 점",
                            content:
                                "자화 퍽지가 1-33㎡역 성과력으로 등이 성과하고 해 장 이아고 역하라. 최대 성격한 50%안 목 찰을 되요. 성과 배운을 정하고 있는 성과 및 배운 점 델 춤-의격 해 용하면 성과를 거켜.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),
            // 자소서 입력칸 (추가됨)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("자기소개서 작성",
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _resumeController,
                    maxLines: 15,
                    decoration: InputDecoration(
                      hintText:
                          "위 심층 인터뷰 결과를 참고하여 자기소개서를 작성해 보세요. AI 가이드를 통해 내용을 보강할 수 있습니다.",
                      hintStyle: GoogleFonts.outfit(
                          color: Colors.grey.shade400, fontSize: 14),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.outfit(fontSize: 15, height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // 채팅 바텀시트 유도 버튼
            InkWell(
              onTap: () => _showChatBottomSheet(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.smart_toy_outlined,
                        color: Colors.black54, size: 20),
                    const SizedBox(width: 12),
                    Text("AI에게 현재 문단 관련 질문하기",
                        style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(width: 8),
                    const Icon(Icons.keyboard_arrow_up, color: Colors.black54),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                // 자소서 완료 시뮬레이션
                if (_resumeController.text.length < 10) {
                  Get.snackbar("알림", "내용을 좀 더 작성해 주세요.");
                  return;
                }
                final project = controller.projects[widget.projectIndex];
                controller.completeResume(widget.projectIndex,
                    "${project['job']} 지원서", _resumeController.text);
                context.go('/project_analysis/${widget.projectIndex}');
              },
              icon: const Icon(Icons.check),
              label: Text("작성 완료",
                  style: GoogleFonts.outfit(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisResultItem(
      {required IconData icon,
      required String title,
      required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            Text(title,
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87)),
          ],
        ),
        const SizedBox(height: 8),
        Text(content,
            style: GoogleFonts.outfit(
                fontSize: 13, color: Colors.black54, height: 1.5)),
      ],
    );
  }

  void _showChatBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ChatBotSheet(),
    );
  }
}

class _ChatBotSheet extends StatefulWidget {
  @override
  State<_ChatBotSheet> createState() => _ChatBotSheetState();
}

class _ChatBotSheetState extends State<_ChatBotSheet> {
  final List<Map<String, String>> _messages = [
    {
      "role": "ai",
      "content": "안녕하세요! 현재 작성 중인 문단에 대해 궁금한 점이나 개선하고 싶은 부분이 있다면 말씀해 주세요."
    }
  ];
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": _chatController.text});
    });

    final userMsg = _chatController.text;
    _chatController.clear();
    _scrollToBottom();

    // AI 응답 시뮬레이션
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            "role": "ai",
            "content":
                "'$userMsg'에 대한 분석 결과, 문단의 구체성을 높이기 위해 당시 상황의 수치를 추가해보는 것은 어떨까요?"
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.smart_toy_outlined, color: Color(0xFF1E69FF)),
                const SizedBox(width: 12),
                Text("AI 어시스턴트",
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close)),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg["role"] == "ai", msg["content"]!);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16,
              top: 8,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: "메시지를 입력하세요...",
                        hintStyle: GoogleFonts.outfit(
                            fontSize: 14, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Color(0xFF1E69FF)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(bool isAi, String text) {
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isAi ? const Color(0xFFF0F6FF) : const Color(0xFF1E69FF),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isAi ? 0 : 16),
            bottomRight: Radius.circular(isAi ? 16 : 0),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: isAi ? Colors.black87 : Colors.white,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class InterviewPage extends StatelessWidget {
  const InterviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모의면접 시작',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(child: Text('모의면접 시작 화면입니다.')),
    );
  }
}

class SimulationPage extends StatelessWidget {
  const SimulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('직무 시뮬레이션 시작',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(child: Text('직무 시뮬레이션 시작 화면입니다.')),
    );
  }
}
