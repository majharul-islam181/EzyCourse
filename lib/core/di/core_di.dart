import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../flavors/app_flavor.dart';
import '../network/api_interceptor.dart';
import '../network/api_constants.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/local_storage.dart';
import '../storage/memory_storage.dart';
import '../storage/storage_keys.dart';
import '../theme/theme_manager.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initStorage();
  _initTheme();
  _initNetwork();
}

Future<void> _initStorage() async {
  final SharedPreferencesImpl localStorage =
      await SharedPreferencesImpl.create();
  final MemoryStorage memoryStorage = MemoryStorage();
  final String? accessToken = await localStorage.getSecureData(
    StorageKeys.authToken,
  );

  memoryStorage.setAccessToken(accessToken);

  sl.registerSingleton<LocalStorage>(localStorage);
  sl.registerSingleton<MemoryStorage>(memoryStorage);
}

void _initTheme() {
  sl.registerFactory<ThemeBloc>(() => ThemeBloc(sl<LocalStorage>()));
}

void _initNetwork() {
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: AppFlavorConfig.instance.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    ),
  );

  sl.registerLazySingleton<ApiInterceptor>(
    () => ApiInterceptor(sl<LocalStorage>(), sl<Dio>(), sl<MemoryStorage>()),
  );

  final Dio dio = sl<Dio>();
  dio.interceptors.add(sl<ApiInterceptor>());

  if (AppFlavorConfig.instance.enableLogging) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
      ),
    );
  }

  sl.registerLazySingleton<DioClient>(() => DioClient(sl<Dio>()));
}
