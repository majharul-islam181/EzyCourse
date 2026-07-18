import '../../domain/entities/coaching_program.dart';
import '../../domain/entities/coaching_program_page.dart';

class CoachingProgramListModel extends CoachingProgramPage {
  const CoachingProgramListModel({
    required super.programs,
    required super.total,
    required super.perPage,
    required super.currentPage,
    required super.lastPage,
  });

  factory CoachingProgramListModel.fromJson(final Map<String, dynamic> json) {
    final Map<String, dynamic> meta = json['meta'] as Map<String, dynamic>;
    final List<dynamic> data = json['data'] as List<dynamic>? ?? [];

    return CoachingProgramListModel(
      programs: data
          .map(
            (final item) =>
                CoachingProgramItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      total: meta['total'] as int? ?? 0,
      perPage: meta['per_page'] as int? ?? 10,
      currentPage: meta['current_page'] as int? ?? 1,
      lastPage: meta['last_page'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': {
        'total': total,
        'per_page': perPage,
        'current_page': currentPage,
        'last_page': lastPage,
      },
      'data': programs
          .map((final program) => CoachingProgramItemModel.fromEntity(program))
          .map((final program) => program.toJson())
          .toList(),
    };
  }
}

class CoachingProgramItemModel extends CoachingProgram {
  const CoachingProgramItemModel({
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

  factory CoachingProgramItemModel.fromJson(final Map<String, dynamic> json) {
    return CoachingProgramItemModel(
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

  factory CoachingProgramItemModel.fromEntity(final CoachingProgram program) {
    return CoachingProgramItemModel(
      id: program.id,
      title: program.title,
      slug: program.slug,
      type: program.type,
      settings: program.settings,
      thumbnail: program.thumbnail,
      cover: program.cover,
      totalMembers: program.totalMembers,
      status: program.status,
      coachingProgramId: program.coachingProgramId,
      enrollmentId: program.enrollmentId,
      expiredAt: program.expiredAt,
      expiryDate: program.expiryDate,
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

  static DateTime? _parseDate(final dynamic value) {
    if (value is! String || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }
}
