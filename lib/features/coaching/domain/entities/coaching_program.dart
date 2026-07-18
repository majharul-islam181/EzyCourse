import 'package:equatable/equatable.dart';

class CoachingProgram extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String type;
  final String? settings;
  final String? thumbnail;
  final String? cover;
  final int totalMembers;
  final String status;
  final int coachingProgramId;
  final int enrollmentId;
  final DateTime? expiredAt;
  final DateTime? expiryDate;

  const CoachingProgram({
    required this.id,
    required this.title,
    required this.slug,
    required this.type,
    this.settings,
    this.thumbnail,
    this.cover,
    required this.totalMembers,
    required this.status,
    required this.coachingProgramId,
    required this.enrollmentId,
    this.expiredAt,
    this.expiryDate,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    slug,
    type,
    settings,
    thumbnail,
    cover,
    totalMembers,
    status,
    coachingProgramId,
    enrollmentId,
    expiredAt,
    expiryDate,
  ];
}
