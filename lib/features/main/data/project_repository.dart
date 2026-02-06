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
