import 'package:flutter_application_1/core/network/api_client.dart';

class AuthApi {
  AuthApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<Map<String, dynamic>> signup({
    required String id,
    required String pw,
  }) async {
    final response = await _client.post(
      '/signup/',
      data: {
        'id': id,
        'pw': pw,
      },
    );

    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }

  Future<Map<String, dynamic>> login({
    required String id,
    required String pw,
  }) async {
    final response = await _client.post(
      '/auth/login',
      data: {
        'id': id,
        'pw': pw,
      },
    );

    return {
      'statusCode': response.statusCode ?? 0,
      'data': response.data,
    };
  }
}
