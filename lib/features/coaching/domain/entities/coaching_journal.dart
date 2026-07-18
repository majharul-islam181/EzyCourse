import 'package:equatable/equatable.dart';

class CoachingJournal extends Equatable {
  final String title;
  final String? description;
  final int? characterLimit;
  final bool allowEdit;

  const CoachingJournal({
    required this.title,
    this.description,
    this.characterLimit,
    required this.allowEdit,
  });

  @override
  List<Object?> get props => [title, description, characterLimit, allowEdit];
}
