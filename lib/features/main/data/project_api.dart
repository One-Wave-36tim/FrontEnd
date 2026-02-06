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
}
