import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../controller/home_controller.dart';
import 'package:intl/intl.dart' as intl;

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
              onPressed: () async {
                final controller = Get.find<HomeController>();
                final ok = await controller
                    .prepareResumeDraftByProjectIndex(projectIndex);
                if (!context.mounted) {
                  return;
                }
                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('자소서 초안을 불러오지 못했습니다.')),
                  );
                  return;
                }
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
  late final HomeController _controller;
  bool _isLoading = true;
  int _current = 1;
  int _total = 6;
  String _prompt = '';
  bool _isSubmitting = false;

  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<HomeController>();
    _startInterview();
  }

  Future<void> _startInterview() async {
    final ok =
        await _controller.startDeepInterviewByProjectIndex(widget.projectIndex);
    final state = _controller.getDeepInterviewState(widget.projectIndex);
    if (!mounted) {
      return;
    }
    setState(() {
      _current = state['current'] as int? ?? 1;
      _total = state['total'] as int? ?? 6;
      _prompt = state['prompt']?.toString() ?? '';
      _isLoading = false;
    });
    if (!ok || _prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('심층 인터뷰 시작에 실패했습니다.')),
      );
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _submitAnswer() async {
    if (_isSubmitting) {
      return;
    }
    final answer = _answerController.text.trim();
    if (answer.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('답변을 입력해 주세요.')),
      );
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    final ok = await _controller.submitDeepInterviewAnswer(
      projectIndex: widget.projectIndex,
      answer: answer,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _isSubmitting = false;
    });
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('답변 제출에 실패했습니다.')),
      );
      return;
    }
    final state = _controller.getDeepInterviewState(widget.projectIndex);
    if (state['completed'] == true) {
      _controller.setSelectedResumeParagraphIndex(widget.projectIndex, 0);
      context.push('/resume_writing/${widget.projectIndex}');
      return;
    }
    setState(() {
      _current = state['current'] as int? ?? _current;
      _total = state['total'] as int? ?? _total;
      _prompt = state['prompt']?.toString() ?? _prompt;
      _answerController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_prompt.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('심층 인터뷰 질문을 불러오지 못했습니다.')),
      );
    }

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
                Text("$_current / $_total",
                    style: GoogleFonts.outfit(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _total == 0 ? 0 : (_current / _total),
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
                    _prompt,
                    style: GoogleFonts.outfit(
                        fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text("답변 가이드:",
                      style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  _buildExampleBullet("상황-행동-결과(SAR) 순서로 답변"),
                  const SizedBox(height: 8),
                  _buildExampleBullet("본인 기여와 팀 기여를 분리해서 설명"),
                  const SizedBox(height: 8),
                  _buildExampleBullet("가능하면 수치/지표를 포함"),
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
                    onChanged: (_) => setState(() {}),
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
                Text("${_answerController.text.length} / 200",
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
                    onPressed: _isSubmitting ? null : _submitAnswer,
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
                        Text("답변 제출",
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
  late final HomeController _controller;
  bool isAnalysisExpanded = true;
  late TextEditingController _resumeController;
  bool _isLoading = true;
  bool _isSubmitting = false;
  List<Map<String, dynamic>> _paragraphs = const [];
  List<Map<String, dynamic>> _interviewSummary = const [];
  int _selectedParagraphIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<HomeController>();
    _resumeController = TextEditingController();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final ok =
        await _controller.prepareResumeDraftByProjectIndex(widget.projectIndex);
    final paragraphs = _controller.getResumeParagraphs(widget.projectIndex);
    final selected =
        _controller.getSelectedResumeParagraphIndex(widget.projectIndex);
    if (!mounted) {
      return;
    }
    setState(() {
      _paragraphs = paragraphs;
      _interviewSummary =
          _controller.getResumeInterviewSummary(widget.projectIndex);
      _selectedParagraphIndex =
          paragraphs.isEmpty ? 0 : selected.clamp(0, paragraphs.length - 1);
      _resumeController.text = paragraphs.isEmpty
          ? ''
          : (_paragraphs[_selectedParagraphIndex]['text']?.toString() ?? '');
      _isLoading = false;
    });
    if (!ok || paragraphs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('자소서 문단 정보를 불러오지 못했습니다.')),
      );
    }
  }

  @override
  void dispose() {
    _resumeController.dispose();
    super.dispose();
  }

  Map<String, dynamic>? get _selectedParagraph {
    if (_paragraphs.isEmpty) {
      return null;
    }
    if (_selectedParagraphIndex < 0 ||
        _selectedParagraphIndex >= _paragraphs.length) {
      return null;
    }
    return _paragraphs[_selectedParagraphIndex];
  }

  Future<void> _completeCurrentParagraph() async {
    final paragraph = _selectedParagraph;
    if (paragraph == null || _isSubmitting) {
      return;
    }
    if (_resumeController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("내용을 좀 더 작성해 주세요.")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });
    final ok = await _controller.completeResumeParagraph(
      projectIndex: widget.projectIndex,
      paragraphIndex: _selectedParagraphIndex,
      text: _resumeController.text.trim(),
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _isSubmitting = false;
    });
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('문단 완료 처리에 실패했습니다.')),
      );
      return;
    }

    await _loadDraft();
    if (!mounted) {
      return;
    }
    final allCompleted = _paragraphs.isNotEmpty &&
        _paragraphs
            .every((item) => (item['status']?.toString() ?? '') == 'COMPLETED');
    if (allCompleted) {
      context.go('/project_analysis/${widget.projectIndex}');
      return;
    }
    final nextIndex = _paragraphs.indexWhere(
      (item) => (item['status']?.toString() ?? '') != 'COMPLETED',
    );
    if (nextIndex >= 0) {
      setState(() {
        _selectedParagraphIndex = nextIndex;
        _resumeController.text =
            _paragraphs[_selectedParagraphIndex]['text']?.toString() ?? '';
      });
      _controller.setSelectedResumeParagraphIndex(
          widget.projectIndex, nextIndex);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('다음 문단 작성을 이어서 진행해 주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_paragraphs.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('자소서 문단이 없습니다.')),
      );
    }
    final selected = _selectedParagraph!;

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
            Text(selected['title']?.toString() ?? '문단별 작성 및 분석',
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
                          Text("프로젝트 심층 인터뷰 결과 요약",
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 20),
                          if (_interviewSummary.isEmpty)
                            Text(
                              '심층 인터뷰 답변이 아직 없습니다. 위 단계에서 답변을 작성해 주세요.',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            )
                          else
                            ..._interviewSummary.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final item = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: idx == _interviewSummary.length - 1
                                        ? 0
                                        : 16),
                                child: _buildAnalysisResultItem(
                                  icon: _analysisIconByIndex(idx),
                                  title:
                                      "핵심 질문 ${idx + 1}: ${item['paragraphTitle'] ?? '문단'}",
                                  content:
                                      item['summary']?.toString().isNotEmpty ==
                                              true
                                          ? item['summary'].toString()
                                          : (item['answer']?.toString() ?? ''),
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _paragraphs.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                final isSelected = idx == _selectedParagraphIndex;
                final completed =
                    (item['status']?.toString() ?? '') == 'COMPLETED';
                return ChoiceChip(
                  label: Text('${item['title']} ${completed ? "(완료)" : ""}'),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedParagraphIndex = idx;
                      _resumeController.text = item['text']?.toString() ?? '';
                    });
                    _controller.setSelectedResumeParagraphIndex(
                        widget.projectIndex, idx);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
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
                  const SizedBox(height: 4),
                  Text("제한 글자 수: ${selected['charLimit'] ?? 0}",
                      style:
                          GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
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
              onTap: () => _showChatBottomSheet(
                context,
                paragraphIndex: _selectedParagraphIndex,
              ),
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
              onPressed: _isSubmitting ? null : _completeCurrentParagraph,
              icon: const Icon(Icons.check),
              label: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text("문단 완료",
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

  IconData _analysisIconByIndex(int index) {
    final icons = [
      Icons.lightbulb_outline,
      Icons.people_outline,
      Icons.emoji_events_outlined,
    ];
    return icons[index % icons.length];
  }

  void _showChatBottomSheet(BuildContext context,
      {required int paragraphIndex}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ChatBotSheet(
        onAsk: (userQuestion) => _controller.askResumeCoach(
          projectIndex: widget.projectIndex,
          paragraphIndex: paragraphIndex,
          paragraphText: _resumeController.text.trim(),
          userQuestion: userQuestion,
        ),
      ),
    );
  }
}

class _ChatBotSheet extends StatefulWidget {
  const _ChatBotSheet({required this.onAsk});

  final Future<String> Function(String userQuestion) onAsk;

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
  bool _isWaiting = false;

  Future<void> _sendMessage() async {
    if (_chatController.text.trim().isEmpty) return;
    if (_isWaiting) return;

    final userMsg = _chatController.text.trim();
    setState(() {
      _messages.add({"role": "user", "content": userMsg});
      _isWaiting = true;
    });
    _chatController.clear();
    _scrollToBottom();
    final aiMessage = await widget.onAsk(userMsg);
    if (!mounted) {
      return;
    }
    setState(() {
      _messages.add({"role": "ai", "content": aiMessage});
      _isWaiting = false;
    });
    _scrollToBottom();
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

// --- 4. 모의면접 입문 화면 ---
class InterviewIntroPage extends StatefulWidget {
  final int projectIndex;
  const InterviewIntroPage({super.key, required this.projectIndex});

  @override
  State<InterviewIntroPage> createState() => _InterviewIntroPageState();
}

class _InterviewIntroPageState extends State<InterviewIntroPage> {
  final TextEditingController _jobPostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        title: Text('모의면접 시작',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 기업 공고 텍스트 박스
            Container(
              padding: const EdgeInsets.all(20),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("기업 공고 텍스트 확인",
                          style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("붙여넣기 완료",
                          style: GoogleFonts.outfit(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        TextField(
                          controller: _jobPostController,
                          maxLines: 6,
                          style: GoogleFonts.outfit(fontSize: 13, height: 1.6),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        ),
                        const Positioned(
                          right: 0,
                          bottom: 0,
                          child: Icon(Icons.edit_outlined,
                              size: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Text("AI가 5개 핵심 역량 키워드를 추출했습니다",
                          style: GoogleFonts.outfit(
                              color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 면접 설명
            Text("면접 설명",
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            _buildDescriptionItem(
                Icons.list_alt, "총 10문제", "직무 핵심 역량 기반 AI 생성 질문"),
            _buildDescriptionItem(Icons.play_circle_outline, "진행 방식",
                "질문 제시 → 답변 준비(30초) → 답변 녹음/녹화(2분) → 다음 문제"),
            _buildDescriptionItem(Icons.videocam_outlined, "녹음 + 동영상 촬영",
                "음성 답변과 함께 웹캠으로 표정, 태도, 시선 분석"),
            _buildDescriptionItem(
                Icons.bar_chart, "결과 리포트", "종합 점수, 답변 내용 평가, 표정 분석, 개선점 제시"),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 20, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("예상 소요시간: 약 25분 (준비시간 포함)",
                            style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        Text("모든 답변은 저장되며 면접 종료 후 상세 리포트를 확인할 수 있습니다.",
                            style: GoogleFonts.outfit(
                                color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 준비 상태
            Text("준비 상태",
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            _buildPreparationItem("공고 분석", 1.0),
            _buildPreparationItem("질문 생성", 1.0),
            _buildPreparationItem("시스템 준비", 1.0),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 20, color: Colors.green),
                  const SizedBox(width: 12),
                  Text("모든 준비가 완료되었습니다. 면접을 시작하세요.",
                      style: GoogleFonts.outfit(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () =>
                      context.push('/interview_session/${widget.projectIndex}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E69FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text("모의면접 시작하기",
                      style: GoogleFonts.outfit(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              Text("시작 버튼을 누르면 첫 번째 질문이 제시됩니다",
                  style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color(0xFFEBF2FF),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: const Color(0xFF1E69FF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(desc,
                    style:
                        GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreparationItem(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
              width: 80,
              child: Text(label,
                  style: GoogleFonts.outfit(
                      fontSize: 14, color: Colors.grey.shade700))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey.shade100,
                color: Colors.green,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text("완료",
              style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// --- 5. 모의면접 실제 진행 화면 ---
class InterviewSessionPage extends StatefulWidget {
  final int projectIndex;
  const InterviewSessionPage({super.key, required this.projectIndex});

  @override
  State<InterviewSessionPage> createState() => _InterviewSessionPageState();
}

class _InterviewSessionPageState extends State<InterviewSessionPage> {
  int currentStep = 1;
  final int totalSteps = 10;
  bool isRecording = false;

  final List<String> interviewQuestions = [
    "지난 프로젝트에서 팀원과 의견 충돌이 발생했을 때, 어떻게 해결하셨나요? 구체적인 사례와 함께 설명해 주세요.",
    "우리 회사가 진행 중인 주요 서비스에 대해 어떻게 생각하시나요? 어떤 부분을 개선하고 싶으신가요?",
    "본인의 기술적인 강점을 이 직무에서 어떻게 발휘할 수 있을지 설명해 주세요.",
    "가장 어려웠던 기술적 문제는 무엇이었으며, 어떻게 극복하셨나요?",
    "팀워크에서 가장 중요하게 생각하는 가치 세 가지는 무엇인가요?",
    "새로운 기술 스택을 도입해야 할 때 본인만의 학습 전략은 무엇인가요?",
    "스트레스 상황에서 본인만의 관리 방법이 있나요?",
    "5년 후 이 분야에서 어떤 전문성을 가진 개발자가 되고 싶으신가요?",
    "코드 리뷰 중 본인의 코드에 대해 강한 비판을 받는다면 어떻게 대처하시겠습니까?",
    "마지막으로 궁금하신 점이나 꼭 하고 싶은 말씀이 있다면 부탁드립니다."
  ];

  @override
  Widget build(BuildContext context) {
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
        title: Text('모의면접',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black)),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text("질문 $currentStep / $totalSteps",
                  style: GoogleFonts.outfit(color: Colors.grey, fontSize: 14)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 질문 카드
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 40,
                      offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: const Color(0xFFEBF2FF),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.smart_toy_outlined,
                            color: Color(0xFF1E69FF), size: 18),
                      ),
                      const SizedBox(width: 12),
                      Text("AI 면접관 질문",
                          style: GoogleFonts.outfit(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "\"${interviewQuestions[currentStep - 1]}\"",
                    style: GoogleFonts.outfit(
                        fontSize: 17, fontWeight: FontWeight.bold, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // 웹캠/녹화 영역 (Simulated)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF161B22),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.videocam_outlined,
                          size: 64, color: Colors.grey.shade700),
                      const SizedBox(height: 16),
                      Text("웹캠 연결 중...",
                          style: GoogleFonts.outfit(
                              color: Colors.grey.shade600, fontSize: 14)),
                    ],
                  ),
                  if (isRecording)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                              height: 8,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Text("녹화 중",
                                style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  if (isRecording)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 14, color: Colors.white),
                            const SizedBox(width: 6),
                            Text("02:45",
                                style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 컨트롤러 영역
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                if (isRecording)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text("● 녹화 중",
                        style: GoogleFonts.outfit(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ),

                // 녹화 버튼
                GestureDetector(
                  onTap: () => setState(() => isRecording = !isRecording),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 4),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          isRecording ? Icons.stop : Icons.fiber_manual_record,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: currentStep > 1
                          ? () => setState(() => currentStep--)
                          : null,
                      icon: const Icon(Icons.arrow_back_ios, size: 14),
                      label: Text("이전",
                          style:
                              GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 48),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (currentStep < totalSteps) {
                          setState(() {
                            currentStep++;
                            isRecording = false;
                          });
                        } else {
                          // 완료 시나리오
                          final controller = Get.find<HomeController>();
                          controller.completeInterview(
                              widget.projectIndex, "기술 면접 모의테스트", 78);
                          context
                              .go('/interview_result/${widget.projectIndex}');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E69FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(160, 48),
                        elevation: 0,
                      ),
                      child: Row(
                        children: [
                          Text(currentStep == totalSteps ? "면접 종료" : "다음 질문",
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 하단 툴바
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToolItem(Icons.mic, "음소거"),
                _buildToolItem(Icons.videocam, "카메라 끄기"),
                _buildToolItem(Icons.settings, "설정"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.grey.shade100, shape: BoxShape.circle),
          child: Icon(icon, size: 24, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 8),
        Text(label,
            style:
                GoogleFonts.outfit(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}

// --- 6. 모의면접 피드백 화면 ---
class InterviewResultPage extends StatelessWidget {
  final int projectIndex;
  const InterviewResultPage({super.key, required this.projectIndex});

  @override
  Widget build(BuildContext context) {
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
        title: Text('모의면접 결과',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 날짜 및 시간
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text("2026.02.07",
                      style:
                          GoogleFonts.outfit(color: Colors.grey, fontSize: 13)),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text("총 24분 37초",
                      style:
                          GoogleFonts.outfit(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 종합 평가 카드
            _buildSection(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("종합 평가",
                          style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Color(0xFF1E69FF), size: 18),
                          const SizedBox(width: 4),
                          Text("78점",
                              style: GoogleFonts.outfit(
                                  color: const Color(0xFF1E69FF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildMetricItem("습관", 0.65, "65%")),
                      const SizedBox(width: 16),
                      Expanded(child: _buildMetricItem("보완성", 0.42, "42%")),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildMetricItem("자신감", 0.82, "82%")),
                      const SizedBox(width: 16),
                      Expanded(child: _buildMetricItem("어휘력", 0.71, "71%")),
                    ],
                  ),
                ],
              ),
            ),

            // 주요 보완점 분석
            _buildSectionHeader("주요 보완점 분석"),
            _buildImprovementItem("답변의 구조적 부재",
                "복잡한 상황을 설명할 때 상황-과제-행동-결과(STAR) 방식이 아닌 나열식 서술로 인해 핵심 메시지가 희석됨."),
            _buildImprovementItem("불필요한 말버릇 반복",
                "\"그러니까\", \"어...\" 등의 필러 워드가 분당 5회 이상 관찰되어 전문성 인상을 떨어뜨림."),
            _buildImprovementItem("시선 처리 미흡",
                "답변 중 카메라를 벗어난 시선이 빈번하여 집중력이 부족해 보이고 자신감을 낮게 평가받을 수 있음."),
            _buildImprovementItem("질문 이해 확인 부족",
                "복합 질문 시 핵심 키워드를 재확인하지 않고 답변을 시작하여 일부 문맥에서 벗어난 내용 포함."),

            // 질문별 분석
            _buildSectionHeader("질문별 분석"),
            _buildQuestionAnalysisItem(
              number: 1,
              question: "자기소개를 해주세요",
              score: 8.5,
              intent: "지원자의 핵심 역량과 회사 적합성을 빠르게 파악하기 위한 질문입니다.",
              userAnswer: "저는 3년간 프론트엔드 개발자로 일하며 React와 Vue.js 프로젝트를 주도했습니다...",
              feedback: "기술 스택을 명확히 언급한 점이 좋습니다. 다만 경력 기간을 더 구체적으로 표현하면 좋겠습니다.",
              modelAnswer:
                  "저는 3년 2개월간 프론트엔드 개발자로 활동하며 React 기반 대규모 프로젝트 3건을 주도적으로 진행했습니다...",
            ),
            const SizedBox(height: 16),
            _buildQuestionAnalysisItem(
              number: 2,
              question: "가장 도전적이었던 프로젝트는?",
              score: 7.2,
              intent: "문제 해결 능력과 회복 탄력성을 평가하기 위한 질문입니다.",
              userAnswer: "기존 시스템을 마이그레이션하는 프로젝트에서 기술적 어려움이 많았습니다...",
              feedback: "어려움을 구체적으로 설명한 점은 좋으나, 해결 과정을 더 구조적으로 설명할 필요가 있습니다.",
              modelAnswer: "6개월간 진행된 레거시 시스템 마이그레이션 프로젝트에서 3가지 주요 장애물을 해결하고...",
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.white,
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => context.go('/project_analysis/$projectIndex'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E69FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("완료하기",
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87)),
      ),
    );
  }

  Widget _buildMetricItem(String label, double value, String percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                GoogleFonts.outfit(fontSize: 13, color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey.shade100,
                  color: const Color(0xFF1E69FF),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(percentage,
                style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
        ),
      ],
    );
  }

  Widget _buildImprovementItem(String title, String content) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.red.shade50, shape: BoxShape.circle),
            child: const Icon(Icons.error_outline, color: Colors.red, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Text(content,
                    style: GoogleFonts.outfit(
                        fontSize: 12, color: Colors.black87, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionAnalysisItem({
    required int number,
    required String question,
    required double score,
    required String intent,
    required String userAnswer,
    required String feedback,
    required String modelAnswer,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                        color: Color(0xFFEBF2FF), shape: BoxShape.circle),
                    child: Center(
                        child: Text("$number",
                            style: GoogleFonts.outfit(
                                color: const Color(0xFF1E69FF),
                                fontSize: 12,
                                fontWeight: FontWeight.bold))),
                  ),
                  const SizedBox(width: 12),
                  Text(question,
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              Text("$score점",
                  style: GoogleFonts.outfit(
                      color: const Color(0xFF1E69FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ],
          ),
          const SizedBox(height: 20),
          _buildAnalysisSection(
              "질문 의도", intent, Colors.grey.shade50, Colors.black54),
          _buildAnalysisSection(
              "사용자 답변", userAnswer, const Color(0xFFF0F6FF), Colors.black87),
          _buildAnalysisSection(
              "피드백", feedback, const Color(0xFFFFF8F0), Colors.black87),
          _buildAnalysisSection(
              "모범 답변", modelAnswer, const Color(0xFFF0FFF4), Colors.black87),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection(
      String label, String content, Color bgColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: bgColor, borderRadius: BorderRadius.circular(8)),
            child: Text(content,
                style: GoogleFonts.outfit(
                    fontSize: 13, color: textColor, height: 1.5)),
          ),
        ],
      ),
    );
  }
}

// --- 7. 직무 시뮬레이션 입문 화면 ---
class SimulationIntroPage extends StatelessWidget {
  final int projectIndex;
  const SimulationIntroPage({super.key, required this.projectIndex});

  @override
  Widget build(BuildContext context) {
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
        title: Text('직무별 시뮬레이션',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.help_outline, color: Colors.grey)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 소개 카드
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color(0xFFEBF2FF),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.smart_toy_outlined,
                            color: Color(0xFF1E69FF), size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("AI 시뮬레이션 체험",
                                style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text("직무별로 실제 업무 스트레스 상황을 모의로 체험해보세요.",
                                style: GoogleFonts.outfit(
                                    color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildIntroDetail(
                      Icons.chat_bubble_outline, "챗봇 형태로 대화하며 상황을 해결합니다."),
                  _buildIntroDetail(
                      Icons.bar_chart_outlined, "피드백과 점수를 통해 역량을 분석받으세요."),
                  _buildIntroDetail(
                      Icons.access_time, "약 10~15분 소요되는 실전형 연습입니다."),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 상황 제시
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("상황 제시",
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold, fontSize: 17)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: const Color(0xFFEBF2FF),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text("1/5 단계",
                      style: GoogleFonts.outfit(
                          color: const Color(0xFF1E69FF),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.03), blurRadius: 20)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF1F3F5),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.business_center_outlined,
                            color: Colors.black54),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("프로젝트 관리자 역할",
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("IT 프로젝트 · 난이도: 중급",
                              style: GoogleFonts.outfit(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text("상황 설명",
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey.shade800)),
                  const SizedBox(height: 12),
                  Text(
                    "주요 고객사와의 중간 보고회가 2시간 앞으로 다가왔습니다. 갑자기 팀원 한 명이 긴급 병가를 내었고, 발표 자료의 핵심 부분이 완성되지 않은 상태입니다. 고객사 담당자는 매우 까다로운 성향으로 알려져 있습니다.",
                    style: GoogleFonts.outfit(
                        fontSize: 14, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  Text("목표",
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey.shade800)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildTargetBadge("시간 관리"),
                      _buildTargetBadge("의사소통"),
                      _buildTargetBadge("위기 대처"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFEDF2FF),
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline,
                      color: Color(0xFF1E69FF), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("AI 코치 팁",
                            style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: const Color(0xFF1E69FF))),
                        Text(
                            "실제 업무에서 발생할 수 있는 예상치 못한 상황을 대비하는 연습입니다. 침착하게 우선순위를 판단해보세요.",
                            style: GoogleFonts.outfit(
                                fontSize: 12,
                                color:
                                    const Color(0xFF1E69FF).withOpacity(0.8))),
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    final controller = Get.find<HomeController>();
                    final ok = await controller
                        .startSimulationByProjectIndex(projectIndex);
                    if (!context.mounted) {
                      return;
                    }
                    if (!ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('시뮬레이션 시작에 실패했습니다.')),
                      );
                      return;
                    }
                    context.push('/simulation_session/$projectIndex');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E69FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow_rounded, size: 28),
                      const SizedBox(width: 8),
                      Text("시뮬레이션 시작하기",
                          style: GoogleFonts.outfit(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text("시작하면 약 12분 정도 소요됩니다",
                  style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroDetail(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF1E69FF)),
          const SizedBox(width: 12),
          Text(text,
              style: GoogleFonts.outfit(color: Colors.black87, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildTargetBadge(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(8)),
      child: Text(label,
          style: GoogleFonts.outfit(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w500)),
    );
  }
}

// --- 8. 직무 시뮬레이션 실제 진행 화면 ---
class SimulationMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final String? profileType; // 'boss', 'coworker', etc.

  SimulationMessage(
      {required this.text,
      this.isUser = false,
      required this.time,
      this.profileType});
}

class SimulationSessionPage extends StatefulWidget {
  final int projectIndex;
  const SimulationSessionPage({super.key, required this.projectIndex});

  @override
  State<SimulationSessionPage> createState() => _SimulationSessionPageState();
}

class _SimulationSessionPageState extends State<SimulationSessionPage> {
  final List<SimulationMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() {
    final controller = Get.find<HomeController>();
    final rows = controller.getSimulationMessages(widget.projectIndex);
    for (final row in rows) {
      final role = row['role']?.toString() ?? 'npc';
      final speaker = row['speaker']?.toString() ?? '';
      _messages.add(
        SimulationMessage(
          text: row['text']?.toString() ?? '',
          isUser: role == 'user',
          time: DateTime.now(),
          profileType: _profileTypeFromSpeaker(speaker),
        ),
      );
    }
    setState(() {});
    _scrollToBottom();
  }

  void _addBotMessage(String text, {String? profileType}) {
    setState(() {
      _messages.add(SimulationMessage(
          text: text,
          isUser: false,
          time: DateTime.now(),
          profileType: profileType));
    });
    _scrollToBottom();
  }

  String? _profileTypeFromSpeaker(String speaker) {
    if (speaker.contains('기획')) {
      return 'boss';
    }
    if (speaker.contains('시스템')) {
      return 'system';
    }
    return 'coworker';
  }

  void _sendMessage() async {
    if (_inputController.text.trim().isEmpty) return;
    String userText = _inputController.text.trim();
    _inputController.clear();

    setState(() {
      _messages.add(SimulationMessage(
          text: userText, isUser: true, time: DateTime.now()));
      _isTyping = true;
    });
    _scrollToBottom();

    final controller = Get.find<HomeController>();
    final ok = await controller.appendSimulationTurn(
      projectIndex: widget.projectIndex,
      text: userText,
    );
    if (!mounted) return;
    setState(() => _isTyping = false);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('시뮬레이션 응답을 받지 못했습니다.')),
      );
      return;
    }

    final rows = controller.getSimulationMessages(widget.projectIndex);
    if (rows.isNotEmpty) {
      final row = rows.last;
      _addBotMessage(
        row['text']?.toString() ?? '',
        profileType: _profileTypeFromSpeaker(row['speaker']?.toString() ?? ''),
      );
    }

    final done =
        controller.projects[widget.projectIndex]['simulationDone'] == true;
    if (done) {
      _finishSimulation();
    }
  }

  void _finishSimulation() {
    _addBotMessage(
        "시스템: 시뮬레이션 종료\n\"수고하셨습니다. 모든 인터랙션이 완료되었습니다. 분석 결과 화면으로 이동합니다.\"",
        profileType: 'system');
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.go('/simulation_result/${widget.projectIndex}');
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
        title: Text('직무 시뮬레이션',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/stern_boss.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFFF0F6FF),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Color(0xFF1E69FF), size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("실전 직무 상황 시뮬레이션",
                          style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: const Color(0xFF1E69FF))),
                      Text("AI가 제시하는 상황에 최선의 답변을 선택해보세요. 실제 면접처럼 평가됩니다.",
                          style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: const Color(0xFF1E69FF).withOpacity(0.8))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 64, vertical: 8),
              child: LinearProgressIndicator(
                  minHeight: 2,
                  color: Color(0xFF1E69FF),
                  backgroundColor: Color(0xFFF0F6FF)),
            ),

          // 하단 텍스트 필드
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(SimulationMessage msg) {
    bool isBoss = msg.profileType == 'boss';
    bool isSystem = msg.profileType == 'system';

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!msg.isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
                image: isBoss
                    ? const DecorationImage(
                        image: AssetImage('assets/images/stern_boss.png'),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: isSystem
                  ? const Icon(Icons.smart_toy_outlined,
                      size: 20, color: Colors.grey)
                  : (isBoss
                      ? null
                      : const Icon(Icons.palette_outlined,
                          size: 20, color: Colors.grey)),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: msg.isUser
                        ? const Color(0xFFEBF2FF)
                        : (isSystem ? const Color(0xFFF8F9FA) : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(2),
                      topRight: const Radius.circular(20),
                      bottomLeft: const Radius.circular(20),
                      bottomRight: const Radius.circular(20),
                    ),
                    border: msg.isUser
                        ? null
                        : Border.all(color: Colors.grey.shade100),
                  ),
                  child: Text(
                    msg.text,
                    style: GoogleFonts.outfit(
                        fontSize: 14, height: 1.5, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  intl.DateFormat('yyyy.MM.dd HH:mm').format(msg.time),
                  style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (msg.isUser) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color(0xFFEBF2FF), shape: BoxShape.circle),
              child: const Icon(Icons.person_outline,
                  size: 20, color: Color(0xFF1E69FF)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100))),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(24)),
              child: TextField(
                controller: _inputController,
                decoration: InputDecoration(
                    hintText: "답변을 입력하세요...",
                    hintStyle: GoogleFonts.outfit(fontSize: 14),
                    border: InputBorder.none),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: Color(0xFF1E69FF), shape: BoxShape.circle),
              child:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 9. 직무 시뮬레이션 결과 화면 ---
class SimulationResultPage extends StatelessWidget {
  final int projectIndex;
  const SimulationResultPage({super.key, required this.projectIndex});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final project = controller.projects[projectIndex];
    final result =
        (project['simulationResult'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{};
    final score = (result['fitScorePercent'] as num?)?.toInt() ?? 92;
    final rankLabel = result['rankLabel']?.toString() ?? '상위 8%';

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
        title: Text('직무 시뮬레이션 결과',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text("직무 적합도 평가",
                style: GoogleFonts.outfit(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 12),
            Text("$score%",
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 56,
                    color: const Color(0xFF161B22))),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_pin_outlined,
                      size: 18, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text("프론트엔드 개발자",
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // 역량 분석
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("역량 분석",
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(rankLabel,
                      style:
                          GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                    value: 0.92,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade100,
                    color: const Color(0xFF161B22)),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem("기술 역량", "9.2", "평균 점수"),
                _buildStatItem("소프트 스킬", "12", "분석 항목"),
                _buildStatItem("문제 해결", "48h", "소요 시간"),
              ],
            ),
            const SizedBox(height: 40),

            // Best / Worst 순간
            _buildMomentItem(
                true,
                "Best 순간",
                "복잡한 버그 해결 과정에서 체계적인 디버깅 접근법을 보여주셨어요. 문제를 작은 단위로 분해하고 로그를 분석한 방식이 인상적이에요.",
                "2026.02",
                "+15% 영향력"),
            _buildMomentItem(
                false,
                "Worst 순간",
                "동시 다발적인 요청이 들어왔을 때 우선순위 설정에 어려움을 겪으셨네요. 중요한 업무와 긴급한 업무를 구분하는 전략이 필요해 보여요.",
                "2026.02",
                "개선 필요"),

            // 직무 내구력 지표
            _buildSectionHeader("직무 내구력 지표"),
            _buildDurabilityItem("스트레스 내성", 0.8),
            _buildDurabilityItem("업무 집중력", 0.9),
            _buildDurabilityItem("피드백 수용", 0.85),

            // 보완점 추천
            _buildSectionHeader("보완점 추천"),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 20),
                      const SizedBox(width: 12),
                      Text("보완점 추천",
                          style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "크로스펑셔널 협업 시 명확한 의사소통이 필요해요. 기술적 설명을 비개발자에게 전달할 때 비유와 시각적 자료를 활용하는 연습을 추천합니다.",
                    style: GoogleFonts.outfit(
                        fontSize: 13, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("커뮤니케이션",
                          style: GoogleFonts.outfit(
                              color: Colors.grey, fontSize: 12)),
                      Text("우선순위 높음",
                          style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => context.go('/project_analysis/$projectIndex'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF161B22),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lightbulb_outline, size: 20),
                  const SizedBox(width: 12),
                  Text("직무 시뮬레이션 완료",
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String sub) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 4),
              Text(sub,
                  style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMomentItem(
      bool isBest, String title, String desc, String date, String status) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: isBest
                        ? const Color(0xFFF1F3F5)
                        : const Color(0xFFFFF5F5),
                    shape: BoxShape.circle),
                child: Icon(
                    isBest ? Icons.emoji_events_outlined : Icons.show_chart,
                    size: 20,
                    color: isBest ? Colors.black87 : Colors.red),
              ),
              const SizedBox(width: 12),
              Text(title,
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          Text(desc,
              style: GoogleFonts.outfit(
                  fontSize: 13, height: 1.6, color: Colors.black87)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date,
                  style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
              Text(status,
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isBest ? Colors.black87 : Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style:
                GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _buildDurabilityItem(String label, double value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: Text(label,
                  style:
                      GoogleFonts.outfit(fontSize: 14, color: Colors.black87))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade100,
                  color: const Color(0xFF161B22)),
            ),
          ),
        ],
      ),
    );
  }
}
