import 'package:equatable/equatable.dart';

import 'coaching_feed_type.dart';

class CoachingTracker extends Equatable {
  final String title;
  final List<CoachingTrackerInput> inputs;

  const CoachingTracker({required this.title, this.inputs = const []});

  @override
  List<Object?> get props => [title, inputs];
}

class CoachingTrackerInput extends Equatable {
  final String trackerSubitemId;
  final TrackerInputType type;
  final String label;
  final num? goal;
  final String? unit;
  final String? startTime;
  final List<String> options;

  const CoachingTrackerInput({
    required this.trackerSubitemId,
    required this.type,
    required this.label,
    this.goal,
    this.unit,
    this.startTime,
    this.options = const [],
  });

  @override
  List<Object?> get props => [
    trackerSubitemId,
    type,
    label,
    goal,
    unit,
    startTime,
    options,
  ];
}
