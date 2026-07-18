import '../../../core/di/core_di.dart';
import '../../../core/network/dio_client.dart';
import '../data/datasources/coaching_remote_data_source.dart';
import '../data/repositories/coaching_repository_impl.dart';
import '../domain/repositories/coaching_repository.dart';
import '../domain/usecases/get_coaching_details_with_sessions_usecase.dart';
import '../domain/usecases/get_enrolled_coaching_programs_usecase.dart';
import '../presentation/bloc/coaching_details_bloc.dart';
import '../presentation/bloc/coaching_program_list_bloc.dart';

void initCoachingDependencies() {
  sl.registerLazySingleton<CoachingRemoteDataSource>(
    () => CoachingRemoteDataSourceImpl(sl<DioClient>()),
  );

  sl.registerLazySingleton<CoachingRepository>(
    () => CoachingRepositoryImpl(sl<CoachingRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetEnrolledCoachingProgramsUseCase>(
    () => GetEnrolledCoachingProgramsUseCase(sl<CoachingRepository>()),
  );

  sl.registerLazySingleton<GetCoachingDetailsWithSessionsUseCase>(
    () => GetCoachingDetailsWithSessionsUseCase(sl<CoachingRepository>()),
  );

  sl.registerFactory<CoachingProgramListBloc>(
    () => CoachingProgramListBloc(sl<GetEnrolledCoachingProgramsUseCase>()),
  );

  sl.registerFactory<CoachingDetailsBloc>(
    () => CoachingDetailsBloc(sl<GetCoachingDetailsWithSessionsUseCase>()),
  );
}
