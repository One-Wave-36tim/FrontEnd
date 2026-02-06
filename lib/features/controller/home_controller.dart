import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/data/auth_session.dart';
import 'package:flutter_application_1/features/main/data/project_repository.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ProjectRepository _projectRepository = ProjectRepository();

  // --- 1. 상태 변수 (State) ---

  // 내 정보 상태
  var hasUserInfo = false.obs;
  var userName = "".obs;
  var userJob = "".obs;
  var userCareer = "".obs;
  var userPortfolio = "".obs;

  // 지원 프로젝트 상태
  var hasProjects = false.obs;
  // 프로젝트 리스트 (예시 데이터)
  var projects = <Map<String, dynamic>>[].obs;

  // 현재 마우스가 올라간 Step의 인덱스 (없으면 -1)
  // .obs를 붙여서 UI가 이 값이 변할 때마다 자동으로 다시 그려지게 함
  var hoveredStepIndex = (-1).obs;

  // 오늘의 루틴 상태
  var routines = <Map<String, dynamic>>[
    {'title': "자소서 1개 첨삭 완료하기", 'isCompleted': false},
    {'title': "모의 면접 1회 진행하기", 'isCompleted': false},
    {'title': "관심 기업 채용 공고 확인", 'isCompleted': false},
  ].obs;

  var isSyncing = false.obs;
  var isCreatingProject = false.obs;

  // --- 2. 액션 (Actions) ---

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  // 정보 입력 시뮬레이션
  void setUserInfo(String name, String job, String career, String portfolio) {
    userName.value = name;
    userJob.value = job;
    userCareer.value = career;
    userPortfolio.value = portfolio;
    hasUserInfo.value = true;
  }

  // 프로젝트 생성 시뮬레이션(레거시 fallback)
  int createProject(String title, String job, String date, int progess) {
    projects.add({
      'title': title,
      'job': job,
      'startDate': date,
      'progress': progess,
      'resume': null,
      'interview': null,
      'simulation': null,
      'myProjects': [
        {
          'type': '대표',
          'title': '쇼핑몰 리뉴얼',
          'tech': 'React, TypeScript',
          'date': '2025.03 - 2025.04'
        },
        {
          'type': '보조',
          'title': 'AI 채팅봇',
          'tech': 'Next.js, OpenAI',
          'date': '2025.02 - 2025.03'
        },
        {
          'type': '보조',
          'title': '포트폴리오 웹',
          'tech': 'Vue.js, Node.js',
          'date': '2025.01 - 2025.02'
        },
      ],
    });
    hasProjects.value = true;
    return projects.length - 1;
  }

  Future<void> loadHomeData() async {
    final token = AuthSession.accessToken;
    if (token == null || token.isEmpty) {
      return;
    }

    isSyncing.value = true;
    try {
      final result = await _projectRepository.fetchHomeData(accessToken: token);

      userName.value = result.userName;
      userJob.value = result.userJob;
      userCareer.value = result.userCareer;
      userPortfolio.value = result.userPortfolio;
      hasUserInfo.value = result.userName.isNotEmpty;

      projects.assignAll(result.projects);
      hasProjects.value = projects.isNotEmpty;

      routines.assignAll(result.routines);
    } catch (error) {
      debugPrint('loadHomeData failed: $error');
    } finally {
      isSyncing.value = false;
    }
  }

  Future<int?> createProjectRemote({
    required String companyName,
    required String roleTitle,
    required String jobPostingUrl,
    required String notionUrl,
    required String blogUrl,
    required String representativeDescription,
    required bool developerMode,
    required String githubRepoUrl,
  }) async {
    final token = AuthSession.accessToken;
    if (token == null || token.isEmpty) {
      return null;
    }

    isCreatingProject.value = true;
    try {
      final projectId = await _projectRepository.createProject(
        accessToken: token,
        companyName: companyName,
        roleTitle: roleTitle,
        jobPostingUrl: jobPostingUrl,
        notionUrl: notionUrl,
        blogUrl: blogUrl,
        representativeDescription: representativeDescription,
        developerMode: developerMode,
        githubRepoUrl: githubRepoUrl,
      );

      await loadHomeData();
      final index = projects.indexWhere((item) => item['id'] == projectId);
      final resolvedIndex = index >= 0 ? index : 0;
      await loadProjectDashboardByIndex(resolvedIndex);
      return resolvedIndex;
    } catch (error) {
      debugPrint('createProjectRemote failed: $error');
      return null;
    } finally {
      isCreatingProject.value = false;
    }
  }

  Future<void> loadProjectDashboardByIndex(int index) async {
    if (index < 0 || index >= projects.length) {
      return;
    }

    final token = AuthSession.accessToken;
    if (token == null || token.isEmpty) {
      return;
    }

    final projectId = projects[index]['id']?.toString() ?? '';
    if (projectId.isEmpty) {
      return;
    }

    try {
      final patch = await _projectRepository.fetchProjectDashboard(
        accessToken: token,
        projectId: projectId,
      );

      final updatedProject = Map<String, dynamic>.from(projects[index]);
      final resumeId = _toStringValue(patch.resume?['resumeId']);
      if (resumeId.isNotEmpty) {
        updatedProject['resumeId'] = resumeId;
      }
      updatedProject['resume'] = patch.resume;
      updatedProject['interview'] = patch.interview;
      updatedProject['simulation'] = patch.simulation;
      updatedProject['myProjects'] = patch.myProjects;
      projects[index] = updatedProject;
    } catch (error) {
      debugPrint('loadProjectDashboardByIndex failed: $error');
    }
  }

  Future<bool> prepareResumeDraftByProjectIndex(int projectIndex) async {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return false;
    }
    final token = AuthSession.accessToken;
    if (token == null || token.isEmpty) {
      return false;
    }

    final projectId = projects[projectIndex]['id']?.toString() ?? '';
    if (projectId.isEmpty) {
      return false;
    }

    try {
      final draft = await _projectRepository.getOrCreateResumeDraft(
        accessToken: token,
        projectId: projectId,
      );

      final updatedProject = Map<String, dynamic>.from(projects[projectIndex]);
      updatedProject['resumeId'] = draft.resumeId;
      updatedProject['resumeDraft'] = {
        'projectId': draft.projectId,
        'resumeId': draft.resumeId,
        'title': draft.title,
        'status': draft.status,
        'completedParagraphs': draft.completedParagraphs,
        'totalParagraphs': draft.totalParagraphs,
        'paragraphs': draft.paragraphs,
        'selectedParagraphIndex':
            _resolveSelectedParagraphIndex(draft.paragraphs),
      };

      if (draft.paragraphs.isNotEmpty) {
        final first = draft.paragraphs.first;
        if (_toStringValue(first['text']).isNotEmpty) {
          updatedProject['resume'] = {
            'title': _toStringValue(first['title']).isNotEmpty
                ? _toStringValue(first['title'])
                : draft.title,
            'content': _toStringValue(first['text']),
          };
        } else {
          updatedProject['resume'] = {'title': draft.title, 'content': ''};
        }
      }

      projects[projectIndex] = updatedProject;
      return true;
    } catch (error) {
      debugPrint('prepareResumeDraftByProjectIndex failed: $error');
      return false;
    }
  }

  void setSelectedResumeParagraphIndex(int projectIndex, int paragraphIndex) {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return;
    }
    final updatedProject = Map<String, dynamic>.from(projects[projectIndex]);
    final draft = Map<String, dynamic>.from(
      (updatedProject['resumeDraft'] as Map?)?.cast<String, dynamic>() ??
          const <String, dynamic>{},
    );
    draft['selectedParagraphIndex'] = paragraphIndex;
    updatedProject['resumeDraft'] = draft;
    projects[projectIndex] = updatedProject;
  }

  int getSelectedResumeParagraphIndex(int projectIndex) {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return 0;
    }
    final draft = projects[projectIndex]['resumeDraft'];
    if (draft is Map && draft['selectedParagraphIndex'] is int) {
      return draft['selectedParagraphIndex'] as int;
    }
    return 0;
  }

  List<Map<String, dynamic>> getResumeParagraphs(int projectIndex) {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return const <Map<String, dynamic>>[];
    }
    final draft = projects[projectIndex]['resumeDraft'];
    if (draft is Map && draft['paragraphs'] is List) {
      return (draft['paragraphs'] as List)
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList(growable: false);
    }
    return const <Map<String, dynamic>>[];
  }

  void saveResumeInterviewAnswer({
    required int projectIndex,
    required int questionIndex,
    required String paragraphTitle,
    required String question,
    required String answer,
  }) {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return;
    }
    final updatedProject = Map<String, dynamic>.from(projects[projectIndex]);
    final current = updatedProject['resumeInterviewSummary'];
    final list = (current is List ? current : const <dynamic>[])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList(growable: true);

    final payload = <String, dynamic>{
      'questionIndex': questionIndex,
      'paragraphTitle': paragraphTitle,
      'question': question,
      'answer': answer,
      'summary': _toInterviewSummary(answer),
    };
    final idx = list.indexWhere((e) => e['questionIndex'] == questionIndex);
    if (idx >= 0) {
      list[idx] = payload;
    } else {
      list.add(payload);
    }
    list.sort((a, b) =>
        (a['questionIndex'] as int).compareTo(b['questionIndex'] as int));
    updatedProject['resumeInterviewSummary'] = list;
    projects[projectIndex] = updatedProject;
  }

  List<Map<String, dynamic>> getResumeInterviewSummary(int projectIndex) {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return const <Map<String, dynamic>>[];
    }
    final current = projects[projectIndex]['resumeInterviewSummary'];
    if (current is List) {
      return current
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList(growable: false);
    }
    return const <Map<String, dynamic>>[];
  }

  Future<bool> startDeepInterviewByProjectIndex(int projectIndex) async {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return false;
    }
    final token = AuthSession.accessToken;
    if (token == null || token.isEmpty) {
      return false;
    }
    final projectId = projects[projectIndex]['id']?.toString() ?? '';
    if (projectId.isEmpty) {
      return false;
    }

    try {
      final started = await _projectRepository.startDeepInterview(
        accessToken: token,
        projectId: projectId,
      );
      final updatedProject = Map<String, dynamic>.from(projects[projectIndex]);
      updatedProject['deepInterviewSessionId'] = started.sessionId;
      updatedProject['deepInterviewCurrentQuestionId'] = started.questionId;
      updatedProject['deepInterviewCurrentPrompt'] = started.prompt;
      updatedProject['deepInterviewCurrent'] = started.current;
      updatedProject['deepInterviewTotal'] = started.total;
      updatedProject['deepInterviewCompleted'] = false;
      projects[projectIndex] = updatedProject;
      return true;
    } catch (error) {
      debugPrint('startDeepInterviewByProjectIndex failed: $error');
      return false;
    }
  }

  Map<String, dynamic> getDeepInterviewState(int projectIndex) {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return const <String, dynamic>{};
    }
    final project = projects[projectIndex];
    return {
      'sessionId': _toStringValue(project['deepInterviewSessionId']),
      'questionId': _toStringValue(project['deepInterviewCurrentQuestionId']),
      'prompt': _toStringValue(project['deepInterviewCurrentPrompt']),
      'current': project['deepInterviewCurrent'] is int
          ? project['deepInterviewCurrent'] as int
          : 1,
      'total': project['deepInterviewTotal'] is int
          ? project['deepInterviewTotal'] as int
          : 6,
      'completed': project['deepInterviewCompleted'] == true,
    };
  }

  Future<bool> submitDeepInterviewAnswer({
    required int projectIndex,
    required String answer,
  }) async {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return false;
    }
    final token = AuthSession.accessToken;
    if (token == null || token.isEmpty) {
      return false;
    }

    final state = getDeepInterviewState(projectIndex);
    final sessionId = _toStringValue(state['sessionId']);
    final questionId = _toStringValue(state['questionId']);
    if (sessionId.isEmpty || questionId.isEmpty) {
      return false;
    }

    try {
      final result = await _projectRepository.answerDeepInterview(
        accessToken: token,
        sessionId: sessionId,
        questionId: questionId,
        answer: answer,
      );

      final updatedProject = Map<String, dynamic>.from(projects[projectIndex]);
      if (!result.completed) {
        updatedProject['deepInterviewCurrentQuestionId'] =
            result.nextQuestionId;
        updatedProject['deepInterviewCurrentPrompt'] = result.nextPrompt;
        updatedProject['deepInterviewCurrent'] = result.current;
        updatedProject['deepInterviewTotal'] = result.total;
        updatedProject['deepInterviewCompleted'] = false;
        projects[projectIndex] = updatedProject;
        return true;
      }

      final insight = await _projectRepository.getDeepInterviewInsight(
        accessToken: token,
        sessionId: sessionId,
      );
      updatedProject['deepInterviewCompleted'] = true;
      updatedProject['deepInterviewCurrentPrompt'] = '';
      updatedProject['deepInterviewCurrentQuestionId'] = '';
      updatedProject['resumeInterviewSummary'] =
          _toInterviewSummaryItems(insight);
      projects[projectIndex] = updatedProject;
      return true;
    } catch (error) {
      debugPrint('submitDeepInterviewAnswer failed: $error');
      return false;
    }
  }

  Future<bool> saveResumeParagraph({
    required int projectIndex,
    required int paragraphIndex,
    required String text,
  }) async {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return false;
    }
    final token = AuthSession.accessToken;
    if (token == null || token.isEmpty) {
      return false;
    }
    final projectId = projects[projectIndex]['id']?.toString() ?? '';
    if (projectId.isEmpty) {
      return false;
    }
    final paragraphs = getResumeParagraphs(projectIndex);
    if (paragraphIndex < 0 || paragraphIndex >= paragraphs.length) {
      return false;
    }
    final resumeId = projects[projectIndex]['resumeId']?.toString() ?? '';
    final paragraphId =
        paragraphs[paragraphIndex]['paragraphId']?.toString() ?? '';
    if (resumeId.isEmpty || paragraphId.isEmpty) {
      return false;
    }

    try {
      await _projectRepository.patchResumeParagraph(
        accessToken: token,
        projectId: projectId,
        resumeId: resumeId,
        paragraphId: paragraphId,
        text: text,
      );
      final updatedProject = Map<String, dynamic>.from(projects[projectIndex]);
      final draft = Map<String, dynamic>.from(
        (updatedProject['resumeDraft'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      );
      final mutableParagraphs = paragraphs
          .map((e) => Map<String, dynamic>.from(e))
          .toList(growable: true);
      mutableParagraphs[paragraphIndex]['text'] = text;
      draft['paragraphs'] = mutableParagraphs;
      updatedProject['resumeDraft'] = draft;
      updatedProject['resume'] = {
        'title': mutableParagraphs[paragraphIndex]['title'],
        'content': text,
      };
      projects[projectIndex] = updatedProject;
      return true;
    } catch (error) {
      debugPrint('saveResumeParagraph failed: $error');
      return false;
    }
  }

  Future<bool> completeResumeParagraph({
    required int projectIndex,
    required int paragraphIndex,
    required String text,
  }) async {
    final saved = await saveResumeParagraph(
      projectIndex: projectIndex,
      paragraphIndex: paragraphIndex,
      text: text,
    );
    if (!saved) {
      return false;
    }

    final token = AuthSession.accessToken;
    if (token == null || token.isEmpty) {
      return false;
    }
    final projectId = projects[projectIndex]['id']?.toString() ?? '';
    final resumeId = projects[projectIndex]['resumeId']?.toString() ?? '';
    final paragraphs = getResumeParagraphs(projectIndex);
    final paragraphId =
        paragraphs[paragraphIndex]['paragraphId']?.toString() ?? '';
    if (projectId.isEmpty || resumeId.isEmpty || paragraphId.isEmpty) {
      return false;
    }

    try {
      await _projectRepository.completeResumeParagraph(
        accessToken: token,
        projectId: projectId,
        resumeId: resumeId,
        paragraphId: paragraphId,
      );
      await prepareResumeDraftByProjectIndex(projectIndex);
      await loadProjectDashboardByIndex(projectIndex);
      return true;
    } catch (error) {
      debugPrint('completeResumeParagraph failed: $error');
      return false;
    }
  }

  Future<String> askResumeCoach({
    required int projectIndex,
    required int paragraphIndex,
    required String paragraphText,
    required String userQuestion,
  }) async {
    final projectId = projects[projectIndex]['id']?.toString() ?? '';
    final resumeId = projects[projectIndex]['resumeId']?.toString() ?? '';
    final paragraphs = getResumeParagraphs(projectIndex);
    if (paragraphIndex < 0 || paragraphIndex >= paragraphs.length) {
      return '문단을 선택해 주세요.';
    }
    final paragraphId =
        paragraphs[paragraphIndex]['paragraphId']?.toString() ?? '';
    if (projectId.isEmpty || resumeId.isEmpty || paragraphId.isEmpty) {
      return '자소서 문단 정보를 불러오지 못했습니다.';
    }
    try {
      final result = await _projectRepository.askResumeCoach(
        projectId: projectId,
        resumeId: resumeId,
        paragraphId: paragraphId,
        paragraphText: paragraphText,
        userQuestion: userQuestion,
      );
      final checklist = result.checklist.map((e) => '- $e').join('\n');
      return '${result.summary}\n\n체크리스트\n$checklist';
    } catch (error) {
      debugPrint('askResumeCoach failed: $error');
      return 'AI 코치 응답을 불러오지 못했습니다.';
    }
  }

  Future<bool> startSimulationByProjectIndex(int projectIndex) async {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return false;
    }
    final token = AuthSession.accessToken;
    if (token == null || token.isEmpty) {
      return false;
    }
    final projectId = projects[projectIndex]['id']?.toString() ?? '';
    if (projectId.isEmpty) {
      return false;
    }
    try {
      final started = await _projectRepository.startSimulation(
        accessToken: token,
        projectId: projectId,
        role: '프로젝트 관리자 역할',
        scenarioId: 'default_conflict',
        maxTurns: 2,
      );
      final updated = Map<String, dynamic>.from(projects[projectIndex]);
      updated['simulationSessionId'] = started.sessionId;
      updated['simulationMessages'] = started.messages;
      updated['simulationTurn'] = started.turn;
      updated['simulationMaxTurns'] = started.maxTurns;
      projects[projectIndex] = updated;
      return true;
    } catch (error) {
      debugPrint('startSimulationByProjectIndex failed: $error');
      return false;
    }
  }

  List<Map<String, dynamic>> getSimulationMessages(int projectIndex) {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return const <Map<String, dynamic>>[];
    }
    final raw = projects[projectIndex]['simulationMessages'];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList(growable: false);
    }
    return const <Map<String, dynamic>>[];
  }

  Future<bool> appendSimulationTurn({
    required int projectIndex,
    required String text,
  }) async {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return false;
    }
    final token = AuthSession.accessToken;
    if (token == null || token.isEmpty) {
      return false;
    }
    final sessionId =
        projects[projectIndex]['simulationSessionId']?.toString() ?? '';
    if (sessionId.isEmpty) {
      return false;
    }
    try {
      final result = await _projectRepository.appendSimulationTurn(
        accessToken: token,
        sessionId: sessionId,
        text: text,
      );
      final updated = Map<String, dynamic>.from(projects[projectIndex]);
      final current = getSimulationMessages(projectIndex)
          .map((e) => Map<String, dynamic>.from(e))
          .toList(growable: true);
      current.addAll(result.messagesAppended);
      updated['simulationMessages'] = current;
      updated['simulationTurn'] = result.turn;
      updated['simulationDone'] = result.done;
      projects[projectIndex] = updated;
      if (result.done) {
        await fetchSimulationResult(projectIndex: projectIndex);
      }
      return true;
    } catch (error) {
      debugPrint('appendSimulationTurn failed: $error');
      return false;
    }
  }

  Future<bool> fetchSimulationResult({required int projectIndex}) async {
    if (projectIndex < 0 || projectIndex >= projects.length) {
      return false;
    }
    final token = AuthSession.accessToken;
    if (token == null || token.isEmpty) {
      return false;
    }
    final sessionId =
        projects[projectIndex]['simulationSessionId']?.toString() ?? '';
    if (sessionId.isEmpty) {
      return false;
    }
    try {
      final result = await _projectRepository.getSimulationResult(
        accessToken: token,
        sessionId: sessionId,
      );
      final updated = Map<String, dynamic>.from(projects[projectIndex]);
      updated['simulationResult'] = result;
      updated['simulation'] = {
        'title': '직무 시뮬레이션 결과',
        'score': (result['fitScorePercent'] as num?)?.toInt() ?? 0,
      };
      projects[projectIndex] = updated;
      return true;
    } catch (error) {
      debugPrint('fetchSimulationResult failed: $error');
      return false;
    }
  }

  int _resolveSelectedParagraphIndex(List<Map<String, dynamic>> paragraphs) {
    final index = paragraphs.indexWhere(
      (item) => _toStringValue(item['status']) != 'COMPLETED',
    );
    if (index >= 0) {
      return index;
    }
    return 0;
  }

  String _toStringValue(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString();
  }

  String _toInterviewSummary(String answer) {
    final trimmed = answer.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    if (trimmed.length <= 120) {
      return trimmed;
    }
    return '${trimmed.substring(0, 120)}...';
  }

  List<Map<String, dynamic>> _toInterviewSummaryItems(
      DeepInterviewInsightResult insight) {
    final result = <Map<String, dynamic>>[];
    result.add({
      'questionIndex': 0,
      'paragraphTitle': '전체 요약',
      'summary': insight.summary,
      'answer': insight.summary,
    });

    for (var i = 0; i < insight.strengthPoints.length; i++) {
      result.add({
        'questionIndex': 10 + i,
        'paragraphTitle': '강점 포인트',
        'summary': insight.strengthPoints[i],
        'answer': insight.strengthPoints[i],
      });
    }
    for (var i = 0; i < insight.weakPoints.length; i++) {
      result.add({
        'questionIndex': 20 + i,
        'paragraphTitle': '보완 포인트',
        'summary': insight.weakPoints[i],
        'answer': insight.weakPoints[i],
      });
    }
    for (var i = 0; i < insight.actionChecklist.length; i++) {
      result.add({
        'questionIndex': 30 + i,
        'paragraphTitle': '실행 체크리스트',
        'summary': insight.actionChecklist[i],
        'answer': insight.actionChecklist[i],
      });
    }
    return result;
  }

  // 준비 단계 완료 메서드들
  void completeResume(int index, String title, String content) {
    var project = Map<String, dynamic>.from(projects[index]);
    project['resume'] = {'title': title, 'content': content};
    projects[index] = project;
  }

  void completeInterview(int index, String title, int score) {
    var project = Map<String, dynamic>.from(projects[index]);
    project['interview'] = {'title': title, 'score': score};
    projects[index] = project;
  }

  void completeSimulation(int index, String title, int score) {
    var project = Map<String, dynamic>.from(projects[index]);
    project['simulation'] = {'title': title, 'score': score};
    projects[index] = project;
  }

  // 마우스 호버 이벤트 처리
  void onHoverStep(int index, bool isHovering) {
    if (isHovering) {
      hoveredStepIndex.value = index;
    } else {
      // 마우스가 나갔을 때, 현재 호버 중인 인덱스가 나간 인덱스와 같다면 초기화
      if (hoveredStepIndex.value == index) {
        hoveredStepIndex.value = -1;
      }
    }
  }

  // 루틴 토글 액션
  void toggleRoutine(int index) async {
    if (index < 0 || index >= routines.length) {
      return;
    }

    var routine = Map<String, dynamic>.from(routines[index]);
    routine['isCompleted'] = !routine['isCompleted'];
    routines[index] = routine;

    final token = AuthSession.accessToken;
    final routineItemId = routine['id']?.toString() ?? '';
    if (token == null || token.isEmpty || routineItemId.isEmpty) {
      return;
    }

    final success = await _projectRepository.toggleRoutine(
      accessToken: token,
      routineItemId: routineItemId,
      checked: routine['isCompleted'] == true,
    );

    if (!success) {
      final rollback = Map<String, dynamic>.from(routines[index]);
      rollback['isCompleted'] = !rollback['isCompleted'];
      routines[index] = rollback;
    }
  }

  // '지금 시작하기' 버튼 클릭 시
  void onStartClick() {
    // 나중에 여기에 '프로젝트 생성 페이지'나 '대시보드'로 이동하는 코드를 넣습니다.
    // 예: Get.toNamed('/dashboard');

    debugPrint("환영합니다! 커리어 여정을 시작하기 위해 워크스페이스를 생성합니다.");
  }

  // 하단 Step 아이콘 클릭 시
  void onStepClick(int index) {
    // 각 단계별로 바로 이동하고 싶을 때 사용
    String stepName = "";
    switch (index) {
      case 0:
        stepName = "자소서 작성";
        break;
      case 1:
        stepName = "모의면접";
        break;
      case 2:
        stepName = "직무 시뮬레이션";
        break;
      case 3:
        stepName = "결과 리포트";
        break;
    }

    debugPrint("$stepName 단계로 이동합니다.");
    // 임시 안내
  }
}
