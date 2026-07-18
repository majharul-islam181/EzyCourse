import '../../domain/entities/coaching_program_submission.dart';

class CoachingProgramSubmissionModel extends CoachingProgramSubmission {
  const CoachingProgramSubmissionModel({
    required super.id,
    required super.coachingProgramId,
    required super.feedId,
    super.trackingTitle,
    super.type,
    super.label,
    super.answer,
    super.unit,
    super.goal,
    super.trackerSubitemId,
    super.value,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CoachingProgramSubmissionModel.fromJson(
    final Map<String, dynamic> json,
  ) {
    return CoachingProgramSubmissionModel(
      id: json['id'] as int,
      coachingProgramId: json['coachingProgramId'] as int? ?? 0,
      feedId: json['feedId'] as int? ?? 0,
      trackingTitle: json['trackingTitle'] as String?,
      type: json['type'] as String?,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      unit: json['unit'] as String?,
      goal: json['goal'] as num?,
      trackerSubitemId: json['trackerSubitemId'] as String?,
      value: json['value'] as num?,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  factory CoachingProgramSubmissionModel.fromEntity(
    final CoachingProgramSubmission submission,
  ) {
    return CoachingProgramSubmissionModel(
      id: submission.id,
      coachingProgramId: submission.coachingProgramId,
      feedId: submission.feedId,
      trackingTitle: submission.trackingTitle,
      type: submission.type,
      label: submission.label,
      answer: submission.answer,
      unit: submission.unit,
      goal: submission.goal,
      trackerSubitemId: submission.trackerSubitemId,
      value: submission.value,
      createdAt: submission.createdAt,
      updatedAt: submission.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coachingProgramId': coachingProgramId,
      'feedId': feedId,
      'trackingTitle': trackingTitle,
      'type': type,
      'label': label,
      'answer': answer,
      'unit': unit,
      'goal': goal,
      'trackerSubitemId': trackerSubitemId,
      'value': value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static DateTime _parseDate(final dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
