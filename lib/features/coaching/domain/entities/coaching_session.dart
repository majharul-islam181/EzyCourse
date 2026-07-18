import 'package:equatable/equatable.dart';

class CoachingSession extends Equatable {
  final int id;
  final String sessionName;
  final bool completionRequired;
  final bool isCompleted;
  final bool isCurrent;
  final int? parentId;
  final DateTime? sessionDate;
  final int? batchId;
  final String weekBased;
  final int dripDays;
  final bool isReordered;

  const CoachingSession({
    required this.id,
    required this.sessionName,
    required this.completionRequired,
    required this.isCompleted,
    required this.isCurrent,
    this.parentId,
    this.sessionDate,
    this.batchId,
    required this.weekBased,
    required this.dripDays,
    required this.isReordered,
  });

  bool get isParent => parentId == null;
  bool get isChild => parentId != null;

  @override
  List<Object?> get props => [
    id,
    sessionName,
    completionRequired,
    isCompleted,
    isCurrent,
    parentId,
    sessionDate,
    batchId,
    weekBased,
    dripDays,
    isReordered,
  ];
}
