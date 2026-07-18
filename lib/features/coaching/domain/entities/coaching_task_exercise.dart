import 'package:equatable/equatable.dart';

import 'coaching_upload_file.dart';

class CoachingTaskExercise extends Equatable {
  final String title;
  final String type;
  final String? description;
  final List<CoachingUploadFile> uploadFiles;
  final int? trackerId;
  final int? coachingLibraryId;
  final List<String> allowedStudentFileTypes;

  const CoachingTaskExercise({
    required this.title,
    required this.type,
    this.description,
    this.uploadFiles = const [],
    this.trackerId,
    this.coachingLibraryId,
    this.allowedStudentFileTypes = const [],
  });

  bool get hasTracker => trackerId != null;

  @override
  List<Object?> get props => [
    title,
    type,
    description,
    uploadFiles,
    trackerId,
    coachingLibraryId,
    allowedStudentFileTypes,
  ];
}
