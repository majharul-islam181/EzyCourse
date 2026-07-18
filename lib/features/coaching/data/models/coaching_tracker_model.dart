import '../../domain/entities/coaching_feed_type.dart';
import '../../domain/entities/coaching_tracker.dart';

class CoachingTrackerModel extends CoachingTracker {
  const CoachingTrackerModel({required super.title, super.inputs});

  factory CoachingTrackerModel.fromJson(final Map<String, dynamic> json) {
    final List<dynamic> inputs = json['inputs'] as List<dynamic>? ?? [];

    return CoachingTrackerModel(
      title: json['title'] as String? ?? '',
      inputs: inputs
          .whereType<Map<String, dynamic>>()
          .map(CoachingTrackerInputModel.fromJson)
          .toList(),
    );
  }

  factory CoachingTrackerModel.fromEntity(final CoachingTracker tracker) {
    return CoachingTrackerModel(title: tracker.title, inputs: tracker.inputs);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'inputs': inputs
          .map((final input) => CoachingTrackerInputModel.fromEntity(input))
          .map((final input) => input.toJson())
          .toList(),
    };
  }
}

class CoachingTrackerInputModel extends CoachingTrackerInput {
  const CoachingTrackerInputModel({
    required super.trackerSubitemId,
    required super.type,
    required super.label,
    super.goal,
    super.unit,
    super.startTime,
    super.options,
  });

  factory CoachingTrackerInputModel.fromJson(final Map<String, dynamic> json) {
    return CoachingTrackerInputModel(
      trackerSubitemId: json['trackerSubitemId'] as String? ?? '',
      type: _parseTrackerInputType(json['type'] as String?),
      label: json['label'] as String? ?? '',
      goal: json['goal'] as num?,
      unit: json['unit'] as String?,
      startTime: json['startTime'] as String?,
      options: _parseOptions(json['options']),
    );
  }

  factory CoachingTrackerInputModel.fromEntity(
    final CoachingTrackerInput input,
  ) {
    return CoachingTrackerInputModel(
      trackerSubitemId: input.trackerSubitemId,
      type: input.type,
      label: input.label,
      goal: input.goal,
      unit: input.unit,
      startTime: input.startTime,
      options: input.options,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trackerSubitemId': trackerSubitemId,
      'type': type.name,
      'label': label,
      'goal': goal,
      'unit': unit,
      'startTime': startTime,
      'options': options,
    };
  }

  static TrackerInputType _parseTrackerInputType(final String? value) {
    switch (value?.toLowerCase()) {
      case 'number':
        return TrackerInputType.number;
      case 'duration':
        return TrackerInputType.duration;
      case 'question':
        return TrackerInputType.question;
      case 'select one':
        return TrackerInputType.selectOne;
      default:
        return TrackerInputType.unknown;
    }
  }

  static List<String> _parseOptions(final dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value.whereType<String>().toList();
  }
}
