import 'package:flutter_application_1/core/network/api_client.dart';
import 'package:flutter_application_1/features/auth/data/auth_api.dart';

class AuthResult {
  const AuthResult({
    required this.success,
    required this.message,
    this.userId,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
  });

  final bool success;
  final String message;
  final String? userId;
  final String? accessToken;
  final String? tokenType;
  final int? expiresIn;
}

class AuthRepository {
  AuthRepository({AuthApi? api}) : _api = api ?? AuthApi();

  final AuthApi _api;

  Future<AuthResult> signup({
    required String id,
    required String pw,
  }) async {
    try {
      final payload = await _api.signup(id: id, pw: pw);
      final statusCode = payload['statusCode'] as int? ?? 0;
      final data = payload['data'];

      if (statusCode == 200) {
        final body = _asStringKeyedMap(data);
        final success = body['success'] == true;
        final message = body['message'] is String
            ? body['message'] as String
            : success
                ? '회원가입 성공'
                : '회원가입에 실패했습니다.';
        return AuthResult(
          success: success,
          message: message,
          userId: body['user_id'] as String?,
        );
      }

      if (statusCode == 422) {
        return AuthResult(
          success: false,
          message: _extractValidationMessage(data),
        );
      }

      return AuthResult(
        success: false,
        message: _extractServerMessage(data) ?? '회원가입에 실패했습니다. ($statusCode)',
      );
    } on ApiException catch (exception) {
      if (exception.type == ApiErrorType.network ||
          exception.type == ApiErrorType.timeout) {
        return const AuthResult(
          success: false,
          message: '서버에 연결할 수 없습니다.',
        );
      }

      return AuthResult(
        success: false,
        message: exception.message.isNotEmpty
            ? exception.message
            : '알 수 없는 오류가 발생했습니다.',
      );
    } catch (_) {
      return const AuthResult(
        success: false,
        message: '알 수 없는 오류가 발생했습니다.',
      );
    }
  }

  Future<AuthResult> login({
    required String id,
    required String pw,
  }) async {
    try {
      final payload = await _api.login(id: id, pw: pw);
      final statusCode = payload['statusCode'] as int? ?? 0;
      final data = payload['data'];

      if (statusCode == 200) {
        final body = _asStringKeyedMap(data);
        final success = body['success'] == true;
        final message = body['message'] is String
            ? body['message'] as String
            : success
                ? '로그인 성공'
                : '로그인에 실패했습니다.';

        return AuthResult(
          success: success,
          message: message,
          userId: body['user_id'] as String?,
          accessToken: body['access_token'] as String?,
          tokenType: body['token_type'] as String?,
          expiresIn: body['expires_in'] as int?,
        );
      }

      if (statusCode == 422) {
        return AuthResult(
          success: false,
          message: _extractValidationMessage(data),
        );
      }

      return AuthResult(
        success: false,
        message: _extractServerMessage(data) ?? '로그인에 실패했습니다. ($statusCode)',
      );
    } on ApiException catch (exception) {
      if (exception.type == ApiErrorType.network ||
          exception.type == ApiErrorType.timeout) {
        return const AuthResult(
          success: false,
          message: '서버에 연결할 수 없습니다.',
        );
      }

      return AuthResult(
        success: false,
        message: exception.message.isNotEmpty
            ? exception.message
            : '알 수 없는 오류가 발생했습니다.',
      );
    } catch (_) {
      return const AuthResult(
        success: false,
        message: '알 수 없는 오류가 발생했습니다.',
      );
    }
  }

  String _extractValidationMessage(dynamic data) {
    final body = _asStringKeyedMap(data);
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

    return '입력값을 확인해 주세요.';
  }

  String? _extractServerMessage(dynamic data) {
    final body = _asStringKeyedMap(data);

    if (body['message'] is String) {
      final message = body['message'] as String;
      if (message.isNotEmpty) {
        return message;
      }
    }

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

    return null;
  }

  Map<String, dynamic> _asStringKeyedMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return data.map(
        (key, value) => MapEntry(key.toString(), value),
      );
    }
    return <String, dynamic>{};
  }
}
