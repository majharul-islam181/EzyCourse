import '../../domain/entities/coaching_feed_type.dart';
import '../../domain/entities/coaching_lesson.dart';
import '../../domain/entities/coaching_upload_file.dart';
import 'coaching_upload_file_model.dart';

class CoachingLessonModel extends CoachingLesson {
  const CoachingLessonModel({
    required super.title,
    required super.type,
    super.description,
    super.textDescription,
    super.uploadFiles,
  });

  factory CoachingLessonModel.fromJson(final Map<String, dynamic> json) {
    return CoachingLessonModel(
      title: json['title'] as String? ?? '',
      type: _parseLessonType(json['type'] as String?),
      description: json['description'] as String?,
      textDescription: json['text_description'] as String?,
      uploadFiles: _parseUploadFiles(json['upload_files']),
    );
  }

  factory CoachingLessonModel.fromEntity(final CoachingLesson lesson) {
    return CoachingLessonModel(
      title: lesson.title,
      type: lesson.type,
      description: lesson.description,
      textDescription: lesson.textDescription,
      uploadFiles: lesson.uploadFiles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type.name,
      'description': description,
      'text_description': textDescription,
      'upload_files': uploadFiles
          .map((final file) => CoachingUploadFileModel.fromEntity(file))
          .map((final file) => file.toJson())
          .toList(),
    };
  }

  static CoachingLessonType _parseLessonType(final String? value) {
    switch (value?.toLowerCase()) {
      case 'text':
        return CoachingLessonType.text;
      case 'video':
        return CoachingLessonType.video;
      case 'audio':
        return CoachingLessonType.audio;
      case 'pdf':
        return CoachingLessonType.pdf;
      case 'ppt':
        return CoachingLessonType.ppt;
      case 'download':
        return CoachingLessonType.download;
      default:
        return CoachingLessonType.unknown;
    }
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
}
