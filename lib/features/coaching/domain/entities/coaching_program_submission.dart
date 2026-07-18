import 'package:equatable/equatable.dart';

class CoachingProgramSubmission extends Equatable {
  final int id;
  final int coachingProgramId;
  final int feedId;
  final String? trackingTitle;
  final String? type;
  final String? label;
  final String? answer;
  final String? unit;
  final num? goal;
  final String? durationStart;
  final String? trackerSubitemId;
  final num? value;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CoachingProgramSubmission({
    required this.id,
    required this.coachingProgramId,
    required this.feedId,
    this.trackingTitle,
    this.type,
    this.label,
    this.answer,
    this.unit,
    this.goal,
    this.durationStart,
    this.trackerSubitemId,
    this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    coachingProgramId,
    feedId,
    trackingTitle,
    type,
    label,
    answer,
    unit,
    goal,
    durationStart,
    trackerSubitemId,
    value,
    createdAt,
    updatedAt,
  ];
}
