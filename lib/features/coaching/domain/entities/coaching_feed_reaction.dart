import 'package:equatable/equatable.dart';

class CoachingFeedReaction extends Equatable {
  final int id;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final String privacy;

  const CoachingFeedReaction({
    required this.id,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.privacy,
  });

  @override
  List<Object?> get props => [id, likeCount, commentCount, shareCount, privacy];
}
