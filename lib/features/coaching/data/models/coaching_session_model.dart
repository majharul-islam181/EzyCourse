import '../../domain/entities/coaching_session.dart';

class CoachingSessionModel extends CoachingSession {
  const CoachingSessionModel({
    required super.id,
    required super.sessionName,
    required super.completionRequired,
    required super.isCompleted,
    required super.isCurrent,
    super.parentId,
    super.sessionDate,
    super.batchId,
    required super.weekBased,
    required super.dripDays,
    required super.isReordered,
  });

  factory CoachingSessionModel.fromJson(final Map<String, dynamic> json) {
    return CoachingSessionModel(
      id: json['id'] as int,
      sessionName: json['sessionName'] as String,
      completionRequired: _readBool(json['completionRequired']),
      isCompleted: _readBool(json['isCompleted']),
      isCurrent: _readBool(json['isCurrent']),
      parentId: json['parentId'] as int?,
      sessionDate: _parseDate(json['sessionDate']),
      batchId: json['batchId'] as int?,
      weekBased: json['weekBased'] as String,
      dripDays: json['dripDays'] as int? ?? 0,
      isReordered: _readBool(json['isReordered']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionName': sessionName,
      'completionRequired': completionRequired ? 1 : 0,
      'isCompleted': isCompleted ? 1 : 0,
      'isCurrent': isCurrent ? 1 : 0,
      'parentId': parentId,
      'sessionDate': _formatDate(sessionDate),
      'batchId': batchId,
      'weekBased': weekBased,
      'dripDays': dripDays,
      'isReordered': isReordered ? 1 : 0,
    };
  }

  static bool _readBool(final dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value == 1;
    }
    return false;
  }

  static DateTime? _parseDate(final dynamic value) {
    if (value is! String || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }

  static String? _formatDate(final DateTime? value) {
    if (value == null) {
      return null;
    }
    return value.toIso8601String().split('T').first;
  }
}
