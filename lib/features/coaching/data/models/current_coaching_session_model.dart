import '../../domain/entities/current_coaching_session.dart';

class CurrentCoachingSessionModel extends CurrentCoachingSession {
  const CurrentCoachingSessionModel({
    super.currentSessionId,
    super.currentSessionParentId,
  });

  factory CurrentCoachingSessionModel.fromJson(
    final Map<String, dynamic> json,
  ) {
    return CurrentCoachingSessionModel(
      currentSessionId: json['current_session_id'] as int?,
      currentSessionParentId: json['current_session_parent_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_session_id': currentSessionId,
      'current_session_parent_id': currentSessionParentId,
    };
  }
}
