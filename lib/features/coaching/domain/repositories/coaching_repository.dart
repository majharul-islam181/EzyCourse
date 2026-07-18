import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/coaching_program_page.dart';

abstract class CoachingRepository {
  Future<Either<Failure, CoachingProgramPage>> getEnrolledCoachingPrograms({
    required int page,
    required int perPage,
    String? search,
  });
}
