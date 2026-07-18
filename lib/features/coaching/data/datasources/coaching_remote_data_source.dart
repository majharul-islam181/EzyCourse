import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/coaching_program_list_model.dart';

abstract class CoachingRemoteDataSource {
  Future<CoachingProgramListModel> getEnrolledCoachingPrograms({
    required int page,
    required int limit,
  });
}

class CoachingRemoteDataSourceImpl implements CoachingRemoteDataSource {
  final DioClient _dioClient;

  const CoachingRemoteDataSourceImpl(this._dioClient);

  @override
  Future<CoachingProgramListModel> getEnrolledCoachingPrograms({
    required final int page,
    required final int limit,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiConstants.getCoachingProgramList,
      queryParameters: {'page': page, 'limit': limit},
    );

    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw const ServerException(
        message: 'Coaching program response was empty.',
      );
    }

    return CoachingProgramListModel.fromJson(data);
  }
}
