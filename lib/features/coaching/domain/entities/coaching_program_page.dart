import 'package:equatable/equatable.dart';

import 'coaching_program.dart';

class CoachingProgramPage extends Equatable {
  final List<CoachingProgram> programs;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  const CoachingProgramPage({
    required this.programs,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  bool get hasNextPage => lastPage > currentPage;

  @override
  List<Object?> get props => [programs, total, perPage, currentPage, lastPage];
}
