import 'package:equatable/equatable.dart';

class CurrentCoachingSession extends Equatable {
  final int? currentSessionId;
  final int? currentSessionParentId;

  const CurrentCoachingSession({
    this.currentSessionId,
    this.currentSessionParentId,
  });

  bool get hasCurrentSession => currentSessionId != null;

  @override
  List<Object?> get props => [currentSessionId, currentSessionParentId];
}
