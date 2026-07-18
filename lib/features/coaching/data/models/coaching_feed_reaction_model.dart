import '../../domain/entities/coaching_feed_reaction.dart';

class CoachingFeedReactionModel extends CoachingFeedReaction {
  const CoachingFeedReactionModel({
    required super.id,
    required super.likeCount,
    required super.commentCount,
    required super.shareCount,
    required super.privacy,
  });

  factory CoachingFeedReactionModel.fromJson(final Map<String, dynamic> json) {
    return CoachingFeedReactionModel(
      id: json['id'] as int? ?? 0,
      likeCount: json['like_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      shareCount: json['share_count'] as int? ?? 0,
      privacy: json['feed_privacy'] as String? ?? '',
    );
  }

  factory CoachingFeedReactionModel.fromEntity(
    final CoachingFeedReaction reaction,
  ) {
    return CoachingFeedReactionModel(
      id: reaction.id,
      likeCount: reaction.likeCount,
      commentCount: reaction.commentCount,
      shareCount: reaction.shareCount,
      privacy: reaction.privacy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'like_count': likeCount,
      'comment_count': commentCount,
      'share_count': shareCount,
      'feed_privacy': privacy,
    };
  }
}
