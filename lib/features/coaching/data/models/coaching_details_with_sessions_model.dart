import '../../domain/entities/coaching_details_with_sessions.dart';
import 'coaching_details_model.dart';
import 'coaching_session_model.dart';
import 'current_coaching_session_model.dart';

class CoachingDetailsWithSessionsModel extends CoachingDetailsWithSessions {
  const CoachingDetailsWithSessionsModel({
    required super.details,
    required super.sessions,
    required super.currentSession,
  });

  factory CoachingDetailsWithSessionsModel.fromJson(
    final Map<String, dynamic> json,
  ) {
    final List<dynamic> sessions = json['sessions'] as List<dynamic>? ?? [];
    final Map<String, dynamic> currentSession =
        json['current_session'] as Map<String, dynamic>? ?? {};

    return CoachingDetailsWithSessionsModel(
      details: CoachingDetailsModel.fromJson(
        json['coaching_details'] as Map<String, dynamic>,
      ),
      sessions: sessions
          .map(
            (final session) =>
                CoachingSessionModel.fromJson(session as Map<String, dynamic>),
          )
          .toList(),
      currentSession: CurrentCoachingSessionModel.fromJson(currentSession),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coaching_details': (details as CoachingDetailsModel).toJson(),
      'sessions': sessions
          .map((final session) => session as CoachingSessionModel)
          .map((final session) => session.toJson())
          .toList(),
      'current_session': (currentSession as CurrentCoachingSessionModel)
          .toJson(),
    };
  }
}
