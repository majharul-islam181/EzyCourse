import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio);

  Future<Response<T>> get<T>(
    final String path, {
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _parseDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final void Function(int, int)? onSendProgress,
    final void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _parseDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final void Function(int, int)? onSendProgress,
    final void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _parseDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _parseDioError(e);
    }
  }

  Exception _parseDioError(final DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Connection timed out. Please check your internet.',
        );
      case DioExceptionType.badResponse:
        final int? statusCode = error.response?.statusCode;
        final dynamic responseData = error.response?.data;

        String message = 'Something went wrong';
        Map<String, List<String>>? validationErrors;

        if (responseData is Map<String, dynamic>) {
          message = _readErrorMessage(responseData) ?? message;
          if (responseData['errors'] is Map<String, dynamic>) {
            validationErrors = (responseData['errors'] as Map<String, dynamic>)
                .map((final key, final value) {
                  if (value is List) {
                    return MapEntry(
                      key,
                      value.map((final e) => e.toString()).toList(),
                    );
                  }
                  return MapEntry(key, [value.toString()]);
                });
          }
        }

        if (statusCode == 401) {
          return UnauthorizedException(message: message);
        } else if (statusCode == 422) {
          return ValidationException(
            message: message,
            errors: validationErrors,
          );
        } else {
          return ServerException(message: message, statusCode: statusCode);
        }
      case DioExceptionType.cancel:
        return const NetworkException(message: 'Request was cancelled.');
      case DioExceptionType.connectionError:
        return const NetworkException(message: 'No internet connection.');
      case DioExceptionType.badCertificate:
        return const ServerException(
          message: 'Bad certificate. Secure connection failed.',
        );
      case DioExceptionType.unknown:
      default:
        return const NetworkException(
          message: 'An unexpected network error occurred.',
        );
    }
  }

  String? _readErrorMessage(final Map<String, dynamic> data) {
    final dynamic message = data['msg'] ?? data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message;
    }

    final dynamic nestedData = data['data'];
    if (nestedData is Map<String, dynamic>) {
      final dynamic nestedMessage = nestedData['msg'] ?? nestedData['message'];
      if (nestedMessage is String && nestedMessage.trim().isNotEmpty) {
        return nestedMessage;
      }
    }

    return null;
  }
}
