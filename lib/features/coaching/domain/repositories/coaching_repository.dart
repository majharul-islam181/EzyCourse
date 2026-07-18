import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/coaching_details_with_sessions.dart';
import '../entities/coaching_program_page.dart';

abstract class CoachingRepository {
  Future<Either<Failure, CoachingProgramPage>> getEnrolledCoachingPrograms({
    required int page,
    required int perPage,
    String? search,
  });

  Future<Either<Failure, CoachingDetailsWithSessions>>
  getCoachingDetailsWithSessions({
    required int programId,
    required String userZone,
  });
}
