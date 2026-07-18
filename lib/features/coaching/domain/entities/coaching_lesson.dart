import 'package:equatable/equatable.dart';

import 'coaching_feed_type.dart';
import 'coaching_upload_file.dart';

class CoachingLesson extends Equatable {
  final String title;
  final CoachingLessonType type;
  final String? description;
  final String? textDescription;
  final List<CoachingUploadFile> uploadFiles;

  const CoachingLesson({
    required this.title,
    required this.type,
    this.description,
    this.textDescription,
    this.uploadFiles = const [],
  });

  @override
  List<Object?> get props => [
    title,
    type,
    description,
    textDescription,
    uploadFiles,
  ];
}
