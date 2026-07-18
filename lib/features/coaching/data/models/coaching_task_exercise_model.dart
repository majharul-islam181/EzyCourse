import '../../domain/entities/coaching_task_exercise.dart';
import '../../domain/entities/coaching_upload_file.dart';
import 'coaching_upload_file_model.dart';

class CoachingTaskExerciseModel extends CoachingTaskExercise {
  const CoachingTaskExerciseModel({
    required super.title,
    required super.type,
    super.description,
    super.uploadFiles,
    super.trackerId,
    super.coachingLibraryId,
    super.allowedStudentFileTypes,
  });

  factory CoachingTaskExerciseModel.fromJson(final Map<String, dynamic> json) {
    return CoachingTaskExerciseModel(
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
      description: json['description'] as String?,
      uploadFiles: _parseUploadFiles(json['upload_files']),
      trackerId: json['tracker_id'] as int?,
      coachingLibraryId: json['coaching_library_id'] as int?,
      allowedStudentFileTypes: _parseAllowedFileTypes(json['settings']),
    );
  }

  factory CoachingTaskExerciseModel.fromEntity(
    final CoachingTaskExercise taskExercise,
  ) {
    return CoachingTaskExerciseModel(
      title: taskExercise.title,
      type: taskExercise.type,
      description: taskExercise.description,
      uploadFiles: taskExercise.uploadFiles,
      trackerId: taskExercise.trackerId,
      coachingLibraryId: taskExercise.coachingLibraryId,
      allowedStudentFileTypes: taskExercise.allowedStudentFileTypes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'description': description,
      'upload_files': uploadFiles
          .map((final file) => CoachingUploadFileModel.fromEntity(file))
          .map((final file) => file.toJson())
          .toList(),
      'tracker_id': trackerId,
      'coaching_library_id': coachingLibraryId,
      'settings': {'student_files': allowedStudentFileTypes},
    };
  }

  static List<CoachingUploadFile> _parseUploadFiles(final dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(CoachingUploadFileModel.fromJson)
        .toList();
  }

  static List<String> _parseAllowedFileTypes(final dynamic value) {
    if (value is! Map<String, dynamic>) {
      return const [];
    }

    final dynamic studentFiles = value['student_files'];
    if (studentFiles is! List) {
      return const [];
    }

    return studentFiles.whereType<String>().toList();
  }
}
