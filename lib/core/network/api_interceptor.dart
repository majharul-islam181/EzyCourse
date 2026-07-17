import 'package:dio/dio.dart';
import '../storage/local_storage.dart';
import '../storage/memory_storage.dart';
import '../storage/storage_keys.dart';

class ApiInterceptor extends Interceptor {
  final LocalStorage _localStorage;
  final Dio _dio;
  final MemoryStorage _memoryStorage;

  ApiInterceptor(this._localStorage, this._dio, this._memoryStorage);

  @override
  void onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) {
    // Add the access token from memory storage to the request headers.
    final String? token = _memoryStorage.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    super.onRequest(options, handler);
  }

  @override
  void onError(
    final DioException err,
    final ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final String? refreshToken = await _localStorage.getSecureData(
        StorageKeys.refreshToken
      );
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Use a clean request options to avoid looping on 401s
          final Response<Map<String, dynamic>> response = await _dio
              .post<Map<String, dynamic>>(
                '/student/auth/refresh-token',
                data: {'refreshToken': refreshToken},
                options: Options(headers: {'No-Authentication': 'true'}),
              );

          if (response.statusCode == 200 && response.data != null) {
            final String newToken = response.data!['token'] as String;
            final String newRefreshToken =
                response.data!['refreshToken'] as String;
            
            // Update the access token in memory
            _memoryStorage.setAccessToken(newToken);
            // Update the refresh token in secure storage
            await _localStorage.saveSecureData(StorageKeys.refreshToken, newRefreshToken);

            final RequestOptions requestOptions = err.requestOptions;
            requestOptions.headers['Authorization'] = 'Bearer $newToken';

            final Response<dynamic> retryResponse = await _dio.fetch<dynamic>(
              requestOptions,
            );
            return handler.resolve(retryResponse);
          }
        } catch (_) {
          // If refresh token fails, clear tokens from storage and memory
          _localStorage.clear();
          _memoryStorage.clear();
          await _localStorage.deleteSecureData(StorageKeys.refreshToken);
        }
      }
    }
    super.onError(err, handler);
  }
}
