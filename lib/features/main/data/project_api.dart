import 'package:flutter_application_1/core/network/api_client.dart';

class ProjectApi {
  ProjectApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<Map<String, dynamic>> getHome({
    required String accessToken,
  }) async {
    final response = await _client.get(
      '/v1/home',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> createProject({
    required String accessToken,
    required Map<String, dynamic> body,
  }) async {
    final response = await _client.post(
      '/v1/projects',
      data: body,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> getProjectDashboard({
    required String accessToken,
    required String projectId,
  }) async {
    final response = await _client.get(
      '/v1/projects/$projectId/dashboard',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> toggleRoutine({
    required String accessToken,
    required String routineItemId,
    required bool checked,
  }) async {
    final response = await _client.patch(
      '/v1/routines/items/$routineItemId',
      data: {'checked': checked},
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> getResumeDraft({
    required String accessToken,
    required String projectId,
  }) async {
    final response = await _client.get(
      '/v1/projects/$projectId/resumes/draft',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> getResumeParagraph({
    required String accessToken,
    required String projectId,
    required String resumeId,
    required String paragraphId,
  }) async {
    final response = await _client.get(
      '/v1/projects/$projectId/resumes/$resumeId/paragraphs/$paragraphId',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> patchResumeParagraph({
    required String accessToken,
    required String projectId,
    required String resumeId,
    required String paragraphId,
    required String text,
  }) async {
    final response = await _client.patch(
      '/v1/projects/$projectId/resumes/$resumeId/paragraphs/$paragraphId',
      data: {'text': text},
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> completeResumeParagraph({
    required String accessToken,
    required String projectId,
    required String resumeId,
    required String paragraphId,
  }) async {
    final response = await _client.post(
      '/v1/projects/$projectId/resumes/$resumeId/paragraphs/$paragraphId/complete',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> askResumeCoach({
    required String projectId,
    required String resumeId,
    required String paragraphId,
    required String paragraphText,
    required String userQuestion,
  }) async {
    final response = await _client.post(
      '/v1/resume-coach/ask',
      data: {
        'projectId': projectId,
        'resumeId': resumeId,
        'paragraphId': paragraphId,
        'paragraphText': paragraphText,
        'userQuestion': userQuestion,
        'policy': {'noGhostwriting': true},
      },
    );
    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> startDeepInterview({
    required String accessToken,
    required String projectId,
  }) async {
    final response = await _client.post(
      '/deep-interview/start',
      data: {
        'projectId': projectId,
      },
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> answerDeepInterview({
    required String accessToken,
    required String sessionId,
    required String questionId,
    required String answer,
  }) async {
    final response = await _client.post(
      '/deep-interview/answer',
      data: {
        'sessionId': sessionId,
        'questionId': questionId,
        'answer': answer,
      },
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> getDeepInterviewInsight({
    required String accessToken,
    required String sessionId,
  }) async {
    final response = await _client.get(
      '/v1/deep-interview/$sessionId/insight-doc',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> startSimulation({
    required String accessToken,
    required String projectId,
    required String role,
    required String scenarioId,
    required int maxTurns,
  }) async {
    final response = await _client.post(
      '/v1/projects/$projectId/simulations/start',
      data: {
        'role': role,
        'scenarioId': scenarioId,
        'maxTurns': maxTurns,
      },
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> appendSimulationTurn({
    required String accessToken,
    required String sessionId,
    required String text,
  }) async {
    final response = await _client.post(
      '/v1/simulations/sessions/$sessionId/turns',
      data: {'text': text},
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> getSimulationResult({
    required String accessToken,
    required String sessionId,
  }) async {
    final response = await _client.get(
      '/v1/simulations/sessions/$sessionId/result',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }
}
