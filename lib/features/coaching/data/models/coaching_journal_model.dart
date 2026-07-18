import '../../domain/entities/coaching_journal.dart';

class CoachingJournalModel extends CoachingJournal {
  const CoachingJournalModel({
    required super.title,
    super.description,
    super.characterLimit,
    required super.allowEdit,
  });

  factory CoachingJournalModel.fromJson(final Map<String, dynamic> json) {
    return CoachingJournalModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      characterLimit: json['char_limit'] as int?,
      allowEdit: json['allow_edit'] as bool? ?? false,
    );
  }

  factory CoachingJournalModel.fromEntity(final CoachingJournal journal) {
    return CoachingJournalModel(
      title: journal.title,
      description: journal.description,
      characterLimit: journal.characterLimit,
      allowEdit: journal.allowEdit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'char_limit': characterLimit,
      'allow_edit': allowEdit,
    };
  }
}
