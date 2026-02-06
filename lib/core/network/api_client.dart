import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/network/api_config.dart';

enum ApiErrorType { network, timeout, unknown }

class ApiException implements Exception {
  ApiException({
    required this.type,
    required this.message,
    this.statusCode,
    this.data,
  });

  final ApiErrorType type;
  final String message;
  final int? statusCode;
  final dynamic data;

  factory ApiException.fromDio(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          type: ApiErrorType.timeout,
          message: '요청 시간이 초과되었습니다.',
        );
      case DioExceptionType.connectionError:
        return ApiException(
          type: ApiErrorType.network,
          message: '서버에 연결할 수 없습니다.',
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return ApiException(
          type: ApiErrorType.unknown,
          message: exception.message ?? '알 수 없는 네트워크 오류가 발생했습니다.',
          statusCode: exception.response?.statusCode,
          data: exception.response?.data,
        );
    }
  }

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConfig.baseUrl,
                connectTimeout: const Duration(seconds: 10),
                sendTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: const {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
                validateStatus: (status) => status != null && status < 600,
              ),
            );

  final Dio _dio;

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<Response<dynamic>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }
}
