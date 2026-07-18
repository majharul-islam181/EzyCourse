import 'package:equatable/equatable.dart';
import 'coaching_feed.dart';

class CoachingFeedPage extends Equatable {
  final List<CoachingFeed> feeds;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final String coachingType;
  final int studentEnrollmentId;

  const CoachingFeedPage({
    required this.feeds,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.coachingType,
    required this.studentEnrollmentId,
  });

  bool get hasNextPage => lastPage > currentPage;

  @override
  List<Object?> get props => [
    feeds,
    total,
    perPage,
    currentPage,
    lastPage,
    coachingType,
    studentEnrollmentId,
  ];
}
