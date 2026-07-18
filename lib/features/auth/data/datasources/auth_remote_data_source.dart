import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_session_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> login({
    required String email,
    required String password,
    String? appFcmToken,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  const AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthSessionModel> login({
    required final String email,
    required final String password,
    final String? appFcmToken,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
        if (appFcmToken != null && appFcmToken.isNotEmpty) 'app_fcm_token': appFcmToken,
      },
      options: Options(headers: {'No-Authentication': 'true'}),
    );

    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw const ServerException(message: 'Login response was empty.');
    }

    return AuthSessionModel.fromJson(data);
  }
}
