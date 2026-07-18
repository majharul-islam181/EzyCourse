import '../../domain/entities/coaching_details.dart';

class CoachingDetailsModel extends CoachingDetails {
  const CoachingDetailsModel({
    required super.id,
    required super.title,
    super.description,
    super.featureImage,
    super.bannerImage,
    super.settings,
    required super.accessibilityStatus,
    required super.type,
    required super.userId,
    required super.schoolId,
    super.startDate,
    super.endDate,
    required super.membersCount,
  });

  factory CoachingDetailsModel.fromJson(final Map<String, dynamic> json) {
    final Map<String, dynamic>? meta = json['meta'] as Map<String, dynamic>?;

    return CoachingDetailsModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['desc'] as String?,
      featureImage: json['featureImg'] as String?,
      bannerImage: json['bannerImg'] as String?,
      settings: json['settings'] as String?,
      accessibilityStatus: json['accessibilityStatus'] as String,
      type: json['type'] as String,
      userId: json['userId'] as int,
      schoolId: json['schoolId'] as int,
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      membersCount: meta?['members_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': description,
      'featureImg': featureImage,
      'bannerImg': bannerImage,
      'settings': settings,
      'accessibilityStatus': accessibilityStatus,
      'type': type,
      'userId': userId,
      'schoolId': schoolId,
      'startDate': _formatDate(startDate),
      'endDate': _formatDate(endDate),
      'meta': {'members_count': membersCount},
    };
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
