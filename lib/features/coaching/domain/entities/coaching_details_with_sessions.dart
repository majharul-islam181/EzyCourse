import 'package:equatable/equatable.dart';

import 'coaching_details.dart';
import 'coaching_session.dart';
import 'current_coaching_session.dart';

class CoachingDetailsWithSessions extends Equatable {
  final CoachingDetails details;
  final List<CoachingSession> sessions;
  final CurrentCoachingSession currentSession;

  const CoachingDetailsWithSessions({
    required this.details,
    required this.sessions,
    required this.currentSession,
  });

  List<CoachingSession> get parentSessions {
    return sessions.where((final session) => session.isParent).toList();
  }

  List<CoachingSession> childSessionsOf(final int parentId) {
    return sessions
        .where((final session) => session.parentId == parentId)
        .toList();
  }

  CoachingSession? get selectedSession {
    final int? currentSessionId = currentSession.currentSessionId;
    if (currentSessionId == null) {
      return null;
    }

    for (final CoachingSession session in sessions) {
      if (session.id == currentSessionId) {
        return session;
      }
    }

    return null;
  }

  @override
  List<Object?> get props => [details, sessions, currentSession];
}
