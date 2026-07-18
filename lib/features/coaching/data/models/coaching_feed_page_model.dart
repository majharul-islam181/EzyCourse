import '../../domain/entities/coaching_feed.dart';
import '../../domain/entities/coaching_feed_page.dart';
import 'coaching_feed_model.dart';

class CoachingFeedPageModel extends CoachingFeedPage {
  const CoachingFeedPageModel({
    required super.feeds,
    required super.total,
    required super.perPage,
    required super.currentPage,
    required super.lastPage,
    required super.coachingType,
    required super.studentEnrollmentId,
  });

  factory CoachingFeedPageModel.fromJson(final Map<String, dynamic> json) {
    final Map<String, dynamic> meta =
        json['meta'] as Map<String, dynamic>? ?? const {};
    final List<dynamic> data = json['data'] as List<dynamic>? ?? [];

    return CoachingFeedPageModel(
      feeds: data
          .whereType<Map<String, dynamic>>()
          .map(CoachingFeedModel.fromJson)
          .toList(),
      total: meta['total'] as int? ?? 0,
      perPage: meta['perPage'] as int? ?? 10,
      currentPage: meta['currentPage'] as int? ?? 1,
      lastPage: meta['lastPage'] as int? ?? 1,
      coachingType: json['coaching_type'] as String? ?? '',
      studentEnrollmentId: json['student_enrollment_id'] as int? ?? 0,
    );
  }

  factory CoachingFeedPageModel.fromEntity(final CoachingFeedPage page) {
    return CoachingFeedPageModel(
      feeds: page.feeds,
      total: page.total,
      perPage: page.perPage,
      currentPage: page.currentPage,
      lastPage: page.lastPage,
      coachingType: page.coachingType,
      studentEnrollmentId: page.studentEnrollmentId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': {
        'total': total,
        'perPage': perPage,
        'currentPage': currentPage,
        'lastPage': lastPage,
      },
      'data': feeds
          .map((final CoachingFeed feed) => CoachingFeedModel.fromEntity(feed))
          .map((final CoachingFeedModel feed) => feed.toJson())
          .toList(),
      'coaching_type': coachingType,
      'student_enrollment_id': studentEnrollmentId,
    };
  }
}
