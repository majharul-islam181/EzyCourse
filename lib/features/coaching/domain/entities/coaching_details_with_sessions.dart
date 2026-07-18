import 'dart:convert';

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
    return _selectedSessionByType() ??
        _selectedSessionFromCurrentObject() ??
        _firstCurrentSession();
  }

  CoachingSession? _selectedSessionByType() {
    final String? weekBased = _weekBasedSetting;

    if (weekBased == 'session') {
      return _firstCurrentSession();
    }

    if (weekBased == 'week') {
      return _sessionMatchingToday();
    }

    return null;
  }

  CoachingSession? _selectedSessionFromCurrentObject() {
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

  CoachingSession? _firstCurrentSession() {
    for (final CoachingSession session in sessions) {
      if (session.isCurrent) {
        return session;
      }
    }

    return null;
  }

  CoachingSession? _sessionMatchingToday() {
    final DateTime now = DateTime.now();

    for (final CoachingSession session in sessions) {
      final DateTime? sessionDate = session.sessionDate;
      if (sessionDate == null) {
        continue;
      }

      if (sessionDate.year == now.year &&
          sessionDate.month == now.month &&
          sessionDate.day == now.day) {
        return session;
      }
    }

    return null;
  }

  String? get _weekBasedSetting {
    final String? settings = details.settings;
    if (settings == null || settings.isEmpty) {
      return null;
    }

    try {
      final dynamic decoded = jsonDecode(settings);
      if (decoded is Map<String, dynamic>) {
        return decoded['week_based'] as String?;
      }
    } on FormatException {
      return null;
    }

    return null;
  }

  @override
  List<Object?> get props => [details, sessions, currentSession];
}
