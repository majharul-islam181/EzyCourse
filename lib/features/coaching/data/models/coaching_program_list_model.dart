import '../../domain/entities/coaching_program.dart';

class CoachingProgramListModel extends CoachingProgram {
  const CoachingProgramListModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.type,
    super.settings,
    super.thumbnail,
    super.cover,
    required super.totalMembers,
    required super.status,
    required super.coachingProgramId,
    required super.enrollmentId,
    super.expiredAt,
    super.expiryDate,
  });

  factory CoachingProgramListModel.fromJson(final Map<String, dynamic> json) {
    return CoachingProgramListModel(
      id: json['id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String,
      type: json['type'] as String,
      settings: json['settings'] as String?,
      thumbnail: json['thumbnail'] as String?,
      cover: json['cover'] as String?,
      totalMembers: json['total_members'] as int? ?? 0,
      status: json['status'] as String,
      coachingProgramId: json['coaching_program_id'] as int,
      enrollmentId: json['enrollment_id'] as int,
      expiredAt: _parseDate(json['expired_at']),
      expiryDate: _parseDate(json['expiry_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'type': type,
      'settings': settings,
      'thumbnail': thumbnail,
      'cover': cover,
      'total_members': totalMembers,
      'status': status,
      'coaching_program_id': coachingProgramId,
      'enrollment_id': enrollmentId,
      'expired_at': expiredAt?.toIso8601String(),
      'expiry_date': expiryDate?.toIso8601String(),
    };
  }

  CoachingProgramListModel copyWith({
    final int? id,
    final String? title,
    final String? slug,
    final String? type,
    final String? settings,
    final String? thumbnail,
    final String? cover,
    final int? totalMembers,
    final String? status,
    final int? coachingProgramId,
    final int? enrollmentId,
    final DateTime? expiredAt,
    final DateTime? expiryDate,
  }) {
    return CoachingProgramListModel(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      type: type ?? this.type,
      settings: settings ?? this.settings,
      thumbnail: thumbnail ?? this.thumbnail,
      cover: cover ?? this.cover,
      totalMembers: totalMembers ?? this.totalMembers,
      status: status ?? this.status,
      coachingProgramId: coachingProgramId ?? this.coachingProgramId,
      enrollmentId: enrollmentId ?? this.enrollmentId,
      expiredAt: expiredAt ?? this.expiredAt,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  static DateTime? _parseDate(final dynamic value) {
    if (value is! String || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }
}
