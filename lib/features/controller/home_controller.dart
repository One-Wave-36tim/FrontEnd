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
      updatedProject['resume'] = patch.resume;
      updatedProject['interview'] = patch.interview;
      updatedProject['simulation'] = patch.simulation;
      updatedProject['myProjects'] = patch.myProjects;
      projects[index] = updatedProject;
    } catch (error) {
      debugPrint('loadProjectDashboardByIndex failed: $error');
    }
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
