import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../controller/home_controller.dart';

class ProjectCreatePage extends StatefulWidget {
  const ProjectCreatePage({super.key});

  @override
  State<ProjectCreatePage> createState() => _ProjectCreatePageState();
}

class _ProjectCreatePageState extends State<ProjectCreatePage> {
  final controller = Get.find<HomeController>();

  final _companyController = TextEditingController();
  final _jobController = TextEditingController();
  final _linkController = TextEditingController();
  final _notionController = TextEditingController();
  final _blogController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _githubController = TextEditingController();

  bool _isDeveloperMode = false;
  bool _isSubmitting = false;
  String? _fileName;

  @override
  void dispose() {
    _companyController.dispose();
    _jobController.dispose();
    _linkController.dispose();
    _notionController.dispose();
    _blogController.dispose();
    _descriptionController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (!mounted) {
      return;
    }

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("파일이 선택되었습니다: $_fileName")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('지원 프로젝트 생성',
            style:
                GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSectionCard(
                    title: "기본 정보",
                    children: [
                      _buildLabel("기업명"),
                      _buildTextField(_companyController, "예: 네이버, 카카오, 라인"),
                      const SizedBox(height: 16),
                      _buildLabel("지원 직무"),
                      _buildTextField(_jobController, "예: 프론트엔드 개발자, 백엔드 엔진니어"),
                      const SizedBox(height: 16),
                      _buildLabel("채용 공고 링크"),
                      _buildTextField(_linkController,
                          "https://careers.company.com/job/12345"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: "포트폴리오 제출",
                    children: [
                      _buildLabel("노션 링크"),
                      _buildTextField(
                          _notionController, "https://notion.site/portfolio"),
                      const SizedBox(height: 16),
                      _buildLabel("블로그 링크"),
                      _buildTextField(
                          _blogController, "https://blog.site/tech"),
                      const SizedBox(height: 16),
                      _buildLabel("PDF 파일 업로드"),
                      _buildFileUploadArea(),
                      const SizedBox(height: 16),
                      _buildLabel("대표 프로젝트 설명"),
                      _buildTextField(_descriptionController,
                          "주요 기술 스택, 구현 기능, 기여도 등을 작성해주세요.",
                          maxLines: 4),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: "개발자 모드",
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("나는 개발자입니다",
                                  style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              Text("커밋 로그, 메시지 패턴, 수정 범위를 분석합니다",
                                  style: GoogleFonts.outfit(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          CupertinoSwitch(
                            value: _isDeveloperMode,
                            onChanged: (val) {
                              setState(() {
                                _isDeveloperMode = val;
                              });
                            },
                            activeTrackColor: const Color(0xFF1E69FF),
                          ),
                        ],
                      ),
                      if (_isDeveloperMode) ...[
                        const SizedBox(height: 16),
                        _buildLabel("GitHub 레포 링크"),
                        _buildTextField(_githubController,
                            "https://github.com/username/repository"),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
              onPressed: _isSubmitting
                  ? null
                  : () async {
                      if (_companyController.text.isEmpty ||
                          _jobController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("기업명과 직무를 입력해주세요.")),
                        );
                        return;
                      }

                      setState(() {
                        _isSubmitting = true;
                      });

                      final newIndex = await controller.createProjectRemote(
                        companyName: _companyController.text.trim(),
                        roleTitle: _jobController.text.trim(),
                        jobPostingUrl: _linkController.text.trim(),
                        notionUrl: _notionController.text.trim(),
                        blogUrl: _blogController.text.trim(),
                        representativeDescription:
                            _descriptionController.text.trim(),
                        developerMode: _isDeveloperMode,
                        githubRepoUrl: _githubController.text.trim(),
                      );

                      if (!context.mounted) {
                        return;
                      }

                      setState(() {
                        _isSubmitting = false;
                      });

                      if (newIndex == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("프로젝트 생성에 실패했습니다. 로그인/서버 상태를 확인해 주세요."),
                          ),
                        );
                        return;
                      }

                      context.push('/project_analysis/$newIndex');
                    },
              icon: const Icon(Icons.smart_toy_outlined),
              label: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text("AI 분석 시작",
                      style: GoogleFonts.outfit(
                          fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E69FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
      {required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.outfit(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: GoogleFonts.outfit(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.outfit(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildFileUploadArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _pickFile,
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Colors.grey.shade300, style: BorderStyle.none),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_fileName ?? "파일 선택",
                    style: GoogleFonts.outfit(
                        fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text("최대 10MB, PDF 형식만 가능",
            style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
