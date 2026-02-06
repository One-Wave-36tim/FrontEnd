import 'package:flutter_application_1/features/main/data/project_api.dart';

class HomeDataResult {
  const HomeDataResult({
    required this.userName,
    required this.userJob,
    required this.userCareer,
    required this.userPortfolio,
    required this.projects,
    required this.routines,
  });

  final String userName;
  final String userJob;
  final String userCareer;
  final String userPortfolio;
  final List<Map<String, dynamic>> projects;
  final List<Map<String, dynamic>> routines;
}

class ProjectDashboardPatch {
  const ProjectDashboardPatch({
    required this.resume,
    required this.interview,
    required this.simulation,
    required this.myProjects,
  });

  final Map<String, dynamic>? resume;
  final Map<String, dynamic>? interview;
  final Map<String, dynamic>? simulation;
  final List<Map<String, dynamic>> myProjects;
}

class ResumeDraftResult {
  const ResumeDraftResult({
    required this.projectId,
    required this.resumeId,
    required this.title,
    required this.status,
    required this.completedParagraphs,
    required this.totalParagraphs,
    required this.paragraphs,
  });

  final String projectId;
  final String resumeId;
  final String title;
  final String status;
  final int completedParagraphs;
  final int totalParagraphs;
  final List<Map<String, dynamic>> paragraphs;
}

class ResumeCoachResult {
  const ResumeCoachResult({
    required this.summary,
    required this.followUpQuestions,
    required this.checklist,
  });

  final String summary;
  final List<String> followUpQuestions;
  final List<String> checklist;
}

class DeepInterviewStartResult {
  const DeepInterviewStartResult({
    required this.sessionId,
    required this.current,
    required this.total,
    required this.questionId,
    required this.prompt,
  });

  final String sessionId;
  final int current;
  final int total;
  final String questionId;
  final String prompt;
}

class DeepInterviewAnswerResult {
  const DeepInterviewAnswerResult({
    required this.completed,
    required this.current,
    required this.total,
    required this.nextQuestionId,
    required this.nextPrompt,
  });

  final bool completed;
  final int current;
  final int total;
  final String? nextQuestionId;
  final String? nextPrompt;
}

class DeepInterviewInsightResult {
  const DeepInterviewInsightResult({
    required this.summary,
    required this.strengthPoints,
    required this.weakPoints,
    required this.evidenceQuotes,
    required this.actionChecklist,
  });

  final String summary;
  final List<String> strengthPoints;
  final List<String> weakPoints;
  final List<String> evidenceQuotes;
  final List<String> actionChecklist;
}

class SimulationStartResult {
  const SimulationStartResult({
    required this.sessionId,
    required this.maxTurns,
    required this.turn,
    required this.messages,
  });

  final String sessionId;
  final int maxTurns;
  final int turn;
  final List<Map<String, dynamic>> messages;
}

class SimulationTurnResult {
  const SimulationTurnResult({
    required this.turn,
    required this.messagesAppended,
    required this.done,
  });

  final int turn;
  final List<Map<String, dynamic>> messagesAppended;
  final bool done;
}

class ProjectRepository {
  ProjectRepository({ProjectApi? api}) : _api = api ?? ProjectApi();

  final ProjectApi _api;

  Future<HomeDataResult> fetchHomeData({
    required String accessToken,
  }) async {
    final payload = await _api.getHome(accessToken: accessToken);
    final statusCode = payload['statusCode'] as int? ?? 0;
    final body = _asMap(payload['data']);

    if (statusCode != 200) {
      throw _toError(body, fallback: '홈 데이터를 불러오지 못했습니다.');
    }

    final userCard = _asMap(body['userCard']);
    final projects = (_asList(body['projects']))
        .map(_toProjectCardMap)
        .toList(growable: false);

    final routine = _asMap(body['routine']);
    final routines = _asList(routine['items'])
        .map((item) => _toRoutineMap(_asMap(item)))
        .toList(growable: false);

    return HomeDataResult(
      userName: _toStringValue(userCard['name']),
      userJob: _toStringValue(userCard['targetRole']),
      userCareer: _toStringValue(userCard['coachStatus']),
      userPortfolio: '',
      projects: projects,
      routines: routines,
    );
  }

  Future<String> createProject({
    required String accessToken,
    required String companyName,
    required String roleTitle,
    required String jobPostingUrl,
    required String notionUrl,
    required String blogUrl,
    required String representativeDescription,
    required bool developerMode,
    required String githubRepoUrl,
  }) async {
    final portfolio = <String, dynamic>{};
    if (notionUrl.isNotEmpty) {
      portfolio['notionUrl'] = notionUrl;
    }
    if (blogUrl.isNotEmpty) {
      portfolio['blogUrl'] = blogUrl;
    }
    if (representativeDescription.isNotEmpty) {
      portfolio['representativeDescription'] = representativeDescription;
    }
    if (developerMode) {
      portfolio['developerMode'] = true;
    }
    if (githubRepoUrl.isNotEmpty) {
      portfolio['githubRepoUrl'] = githubRepoUrl;
    }

    final body = <String, dynamic>{
      'companyName': companyName,
      'roleTitle': roleTitle,
      if (jobPostingUrl.isNotEmpty) 'jobPostingUrl': jobPostingUrl,
      if (portfolio.isNotEmpty) 'portfolio': portfolio,
    };

    final payload = await _api.createProject(
      accessToken: accessToken,
      body: body,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    final data = _asMap(payload['data']);

    if (statusCode != 200) {
      throw _toError(data, fallback: '프로젝트 생성에 실패했습니다.');
    }

    final projectId = _toStringValue(data['projectId']);
    if (projectId.isEmpty) {
      throw '생성된 프로젝트 ID를 찾을 수 없습니다.';
    }
    return projectId;
  }

  Future<ProjectDashboardPatch> fetchProjectDashboard({
    required String accessToken,
    required String projectId,
  }) async {
    final payload = await _api.getProjectDashboard(
      accessToken: accessToken,
      projectId: projectId,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    final body = _asMap(payload['data']);

    if (statusCode != 200) {
      throw _toError(body, fallback: '프로젝트 상세를 불러오지 못했습니다.');
    }

    final resume = _asMap(body['resume']);
    final mockInterview = _asMap(body['mockInterview']);
    final simulation = _asMap(body['simulation']);
    final portfolios = _asList(body['portfolios'])
        .map((item) => _asMap(item))
        .toList(growable: false);

    final mappedPortfolios = portfolios
        .map(
          (item) => {
            'id': _toStringValue(item['portfolioId']),
            'type': item['isRepresentative'] == true ? '대표' : '보조',
            'title': _toStringValue(item['title']),
            'tech': _joinTech(item['techStack']),
            'date': _toStringValue(item['period']).isNotEmpty
                ? _toStringValue(item['period'])
                : '-',
          },
        )
        .toList(growable: false);

    final hasResume = resume['exists'] == true;
    final resumeMap = hasResume
        ? <String, dynamic>{
            'resumeId': _toStringValue(resume['resumeId']),
            'title': _toStringValue(resume['title']).isNotEmpty
                ? _toStringValue(resume['title'])
                : '자기소개서',
            'content': _toStringValue(resume['title']).isNotEmpty
                ? _toStringValue(resume['title'])
                : '작성된 자기소개서',
          }
        : null;

    final latestScore = mockInterview['latestScore'];
    final interviewMap = mockInterview['latestSessionId'] != null
        ? <String, dynamic>{
            'title': _toStringValue(mockInterview['latestTitle']).isNotEmpty
                ? _toStringValue(mockInterview['latestTitle'])
                : '모의면접 결과',
            if (latestScore is num) 'score': latestScore.round(),
          }
        : null;

    final simulationMap = simulation['completed'] == true
        ? <String, dynamic>{
            'title': '직무 시뮬레이션 결과',
            'score': 0,
          }
        : null;

    return ProjectDashboardPatch(
      resume: resumeMap,
      interview: interviewMap,
      simulation: simulationMap,
      myProjects: mappedPortfolios,
    );
  }

  Future<bool> toggleRoutine({
    required String accessToken,
    required String routineItemId,
    required bool checked,
  }) async {
    final payload = await _api.toggleRoutine(
      accessToken: accessToken,
      routineItemId: routineItemId,
      checked: checked,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    return statusCode == 200;
  }

  Future<ResumeDraftResult> getOrCreateResumeDraft({
    required String accessToken,
    required String projectId,
  }) async {
    final payload = await _api.getResumeDraft(
      accessToken: accessToken,
      projectId: projectId,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    final body = _asMap(payload['data']);
    if (statusCode != 200) {
      throw _toError(body, fallback: '자소서 초안을 불러오지 못했습니다.');
    }

    final paragraphs = _asList(body['paragraphs'])
        .map((item) => _toResumeParagraph(_asMap(item)))
        .toList(growable: false);
    return ResumeDraftResult(
      projectId: _toStringValue(body['projectId']),
      resumeId: _toStringValue(body['resumeId']),
      title: _toStringValue(body['title']),
      status: _toStringValue(body['status']),
      completedParagraphs: _toInt(body['completedParagraphs']),
      totalParagraphs: _toInt(body['totalParagraphs']),
      paragraphs: paragraphs,
    );
  }

  Future<Map<String, dynamic>> getResumeParagraph({
    required String accessToken,
    required String projectId,
    required String resumeId,
    required String paragraphId,
  }) async {
    final payload = await _api.getResumeParagraph(
      accessToken: accessToken,
      projectId: projectId,
      resumeId: resumeId,
      paragraphId: paragraphId,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    final body = _asMap(payload['data']);
    if (statusCode != 200) {
      throw _toError(body, fallback: '문단 조회에 실패했습니다.');
    }
    return _toResumeParagraph(body);
  }

  Future<void> patchResumeParagraph({
    required String accessToken,
    required String projectId,
    required String resumeId,
    required String paragraphId,
    required String text,
  }) async {
    final payload = await _api.patchResumeParagraph(
      accessToken: accessToken,
      projectId: projectId,
      resumeId: resumeId,
      paragraphId: paragraphId,
      text: text,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    final body = _asMap(payload['data']);
    if (statusCode != 200) {
      throw _toError(body, fallback: '문단 저장에 실패했습니다.');
    }
  }

  Future<void> completeResumeParagraph({
    required String accessToken,
    required String projectId,
    required String resumeId,
    required String paragraphId,
  }) async {
    final payload = await _api.completeResumeParagraph(
      accessToken: accessToken,
      projectId: projectId,
      resumeId: resumeId,
      paragraphId: paragraphId,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    final body = _asMap(payload['data']);
    if (statusCode != 200) {
      throw _toError(body, fallback: '문단 완료 처리에 실패했습니다.');
    }
  }

  Future<ResumeCoachResult> askResumeCoach({
    required String projectId,
    required String resumeId,
    required String paragraphId,
    required String paragraphText,
    required String userQuestion,
  }) async {
    final payload = await _api.askResumeCoach(
      projectId: projectId,
      resumeId: resumeId,
      paragraphId: paragraphId,
      paragraphText: paragraphText,
      userQuestion: userQuestion,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    final body = _asMap(payload['data']);
    if (statusCode != 200) {
      throw _toError(body, fallback: 'AI 코치 응답을 불러오지 못했습니다.');
    }

    final answer = _asMap(body['coachAnswer']);
    final followUps = _asList(answer['followUpQuestions'])
        .map((e) => e.toString())
        .toList(growable: false);
    final checklist = _asList(answer['checklist'])
        .map((e) => e.toString())
        .toList(growable: false);

    return ResumeCoachResult(
      summary: _toStringValue(answer['summary']),
      followUpQuestions: followUps,
      checklist: checklist,
    );
  }

  Future<DeepInterviewStartResult> startDeepInterview({
    required String accessToken,
    required String projectId,
  }) async {
    final payload = await _api.startDeepInterview(
      accessToken: accessToken,
      projectId: projectId,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    final body = _asMap(payload['data']);
    if (statusCode != 200) {
      throw _toError(body, fallback: '심층 인터뷰 시작에 실패했습니다.');
    }
    final firstQuestion = _asMap(body['firstQuestion']);
    return DeepInterviewStartResult(
      sessionId: _toStringValue(body['sessionId']),
      current: _toInt(body['currentIndex']),
      total: _toInt(body['totalQuestions']),
      questionId: _toStringValue(firstQuestion['questionId']),
      prompt: _toStringValue(firstQuestion['prompt']),
    );
  }

  Future<DeepInterviewAnswerResult> answerDeepInterview({
    required String accessToken,
    required String sessionId,
    required String questionId,
    required String answer,
  }) async {
    final payload = await _api.answerDeepInterview(
      accessToken: accessToken,
      sessionId: sessionId,
      questionId: questionId,
      answer: answer,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    final body = _asMap(payload['data']);
    if (statusCode != 200) {
      throw _toError(body, fallback: '심층 인터뷰 답변 제출에 실패했습니다.');
    }

    final completed = body['completed'] == true;
    final progress = _asMap(body['progress']);
    final nextQuestion = _asMap(body['nextQuestion']);
    return DeepInterviewAnswerResult(
      completed: completed,
      current: _toInt(progress['current']),
      total: _toInt(progress['total']),
      nextQuestionId:
          completed ? null : _toStringValue(nextQuestion['questionId']),
      nextPrompt: completed ? null : _toStringValue(nextQuestion['prompt']),
    );
  }

  Future<DeepInterviewInsightResult> getDeepInterviewInsight({
    required String accessToken,
    required String sessionId,
  }) async {
    final payload = await _api.getDeepInterviewInsight(
      accessToken: accessToken,
      sessionId: sessionId,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    final body = _asMap(payload['data']);
    if (statusCode != 200) {
      throw _toError(body, fallback: '심층 인터뷰 요약을 불러오지 못했습니다.');
    }
    return DeepInterviewInsightResult(
      summary: _toStringValue(body['summary']),
      strengthPoints: _asList(body['strengthPoints'])
          .map((e) => e.toString())
          .toList(growable: false),
      weakPoints: _asList(body['weakPoints'])
          .map((e) => e.toString())
          .toList(growable: false),
      evidenceQuotes: _asList(body['evidenceQuotes'])
          .map((e) => e.toString())
          .toList(growable: false),
      actionChecklist: _asList(body['actionChecklist'])
          .map((e) => e.toString())
          .toList(growable: false),
    );
  }

  Future<SimulationStartResult> startSimulation({
    required String accessToken,
    required String projectId,
    required String role,
    required String scenarioId,
    required int maxTurns,
  }) async {
    final payload = await _api.startSimulation(
      accessToken: accessToken,
      projectId: projectId,
      role: role,
      scenarioId: scenarioId,
      maxTurns: maxTurns,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    final body = _asMap(payload['data']);
    if (statusCode != 200) {
      throw _toError(body, fallback: '시뮬레이션 시작에 실패했습니다.');
    }
    final messages = _asList(body['messages'])
        .map((e) => _toSimulationMessage(_asMap(e)))
        .toList(growable: false);
    return SimulationStartResult(
      sessionId: _toStringValue(body['sessionId']),
      maxTurns: _toInt(body['maxTurns']),
      turn: _toInt(body['turn']),
      messages: messages,
    );
  }

  Future<SimulationTurnResult> appendSimulationTurn({
    required String accessToken,
    required String sessionId,
    required String text,
  }) async {
    final payload = await _api.appendSimulationTurn(
      accessToken: accessToken,
      sessionId: sessionId,
      text: text,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    final body = _asMap(payload['data']);
    if (statusCode != 200) {
      throw _toError(body, fallback: '시뮬레이션 턴 진행에 실패했습니다.');
    }
    final messages = _asList(body['messagesAppended'])
        .map((e) => _toSimulationMessage(_asMap(e)))
        .toList(growable: false);
    return SimulationTurnResult(
      turn: _toInt(body['turn']),
      messagesAppended: messages,
      done: body['done'] == true,
    );
  }

  Future<Map<String, dynamic>> getSimulationResult({
    required String accessToken,
    required String sessionId,
  }) async {
    final payload = await _api.getSimulationResult(
      accessToken: accessToken,
      sessionId: sessionId,
    );
    final statusCode = payload['statusCode'] as int? ?? 0;
    final body = _asMap(payload['data']);
    if (statusCode != 200) {
      throw _toError(body, fallback: '시뮬레이션 결과 조회에 실패했습니다.');
    }
    return body;
  }

  Map<String, dynamic> _toProjectCardMap(dynamic item) {
    final row = _asMap(item);
    final dDay = row['dDay'] is int ? row['dDay'] as int : null;
    final startedAt = _toStringValue(row['startedAt']);

    return {
      'id': _toStringValue(row['projectId']),
      'title': _toStringValue(row['companyName']),
      'job': _toStringValue(row['roleTitle']),
      'startDate': startedAt.isNotEmpty ? startedAt : '-',
      'progress': _toInt(row['progressPercent']),
      'status': _toStringValue(row['status']),
      'dDayLabel': _toDdayLabel(dDay),
      'lastActivityLabel': _toStringValue(row['lastActivityLabel']).isNotEmpty
          ? _toStringValue(row['lastActivityLabel'])
          : '활동 없음',
      'resume': null,
      'interview': null,
      'simulation': null,
      'myProjects': <Map<String, dynamic>>[],
    };
  }

  Map<String, dynamic> _toRoutineMap(Map<String, dynamic> item) {
    return {
      'id': _toStringValue(item['routineItemId']),
      'title': _toStringValue(item['label']),
      'isCompleted': item['checked'] == true,
    };
  }

  Map<String, dynamic> _toResumeParagraph(Map<String, dynamic> row) {
    return {
      'paragraphId': _toStringValue(row['paragraphId']),
      'title': _toStringValue(row['title']),
      'text': _toStringValue(row['text']),
      'charLimit': _toInt(row['charLimit']),
      'status': _toStringValue(row['status']),
      'sortOrder': _toInt(row['sortOrder']),
      'updatedAt': _toStringValue(row['updatedAt']),
    };
  }

  Map<String, dynamic> _toSimulationMessage(Map<String, dynamic> row) {
    return {
      'messageId': _toStringValue(row['messageId']),
      'role': _toStringValue(row['role']),
      'speaker': _toStringValue(row['speaker']),
      'text': _toStringValue(row['text']),
    };
  }

  String _toError(Map<String, dynamic> body, {required String fallback}) {
    final detail = body['detail'];
    if (detail is String && detail.isNotEmpty) {
      return detail;
    }
    if (detail is List && detail.isNotEmpty) {
      final first = detail.first;
      if (first is String && first.isNotEmpty) {
        return first;
      }
      if (first is Map && first['msg'] is String) {
        final msg = first['msg'] as String;
        if (msg.isNotEmpty) {
          return msg;
        }
      }
    }
    if (body['message'] is String && (body['message'] as String).isNotEmpty) {
      return body['message'] as String;
    }
    return fallback;
  }

  String _toDdayLabel(int? dDay) {
    if (dDay == null) {
      return 'D-?';
    }
    if (dDay > 0) {
      return 'D-$dDay';
    }
    if (dDay == 0) {
      return 'D-Day';
    }
    return 'D+${dDay.abs()}';
  }

  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return 0;
  }

  String _toStringValue(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString();
  }

  String _joinTech(dynamic value) {
    if (value is List) {
      final items = value
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList(growable: false);
      return items.join(', ');
    }
    return '';
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (key, val) => MapEntry(key.toString(), val),
      );
    }
    return <String, dynamic>{};
  }

  List<dynamic> _asList(dynamic value) {
    if (value is List) {
      return value;
    }
    return const <dynamic>[];
  }
}
