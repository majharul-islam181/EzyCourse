import 'package:dio/dio.dart';
import '../storage/local_storage.dart';
import '../storage/storage_keys.dart';

class ApiInterceptor extends Interceptor {
  final LocalStorage _localStorage;
  final Dio _dio;

  ApiInterceptor(this._localStorage, this._dio);

  @override
  void onRequest(final RequestOptions options, final RequestInterceptorHandler handler) {
    final String? token = _localStorage.getString(StorageKeys.authToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    super.onRequest(options, handler);
  }

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final String? refreshToken = _localStorage.getString(StorageKeys.refreshToken);
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Use a clean request options to avoid looping on 401s
          final Response<Map<String, dynamic>> response = await _dio.post<Map<String, dynamic>>(
            '/auth/refresh-token',
            data: {'refreshToken': refreshToken},
            options: Options(
              headers: {'No-Authentication': 'true'},
            ),
          );

          if (response.statusCode == 200 && response.data != null) {
            final String newToken = response.data!['token'] as String;
            final String newRefreshToken = response.data!['refreshToken'] as String;
            
            await _localStorage.setString(StorageKeys.authToken, newToken);
            await _localStorage.setString(StorageKeys.refreshToken, newRefreshToken);

            final RequestOptions requestOptions = err.requestOptions;
            requestOptions.headers['Authorization'] = 'Bearer $newToken';
            
            final Response<dynamic> retryResponse = await _dio.fetch<dynamic>(requestOptions);
            return handler.resolve(retryResponse);
          }
        } catch (_) {
          await _localStorage.remove(StorageKeys.authToken);
          await _localStorage.remove(StorageKeys.refreshToken);
        }
      }
    }
    super.onError(err, handler);
  }
}
