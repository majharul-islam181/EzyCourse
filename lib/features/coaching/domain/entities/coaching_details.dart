import 'package:equatable/equatable.dart';

class CoachingDetails extends Equatable {
  final int id;
  final String title;
  final String? description;
  final String? featureImage;
  final String? bannerImage;
  final String? settings;
  final String accessibilityStatus;
  final String type;
  final int userId;
  final int schoolId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int membersCount;

  const CoachingDetails({
    required this.id,
    required this.title,
    this.description,
    this.featureImage,
    this.bannerImage,
    this.settings,
    required this.accessibilityStatus,
    required this.type,
    required this.userId,
    required this.schoolId,
    this.startDate,
    this.endDate,
    required this.membersCount,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    featureImage,
    bannerImage,
    settings,
    accessibilityStatus,
    type,
    userId,
    schoolId,
    startDate,
    endDate,
    membersCount,
  ];
}
