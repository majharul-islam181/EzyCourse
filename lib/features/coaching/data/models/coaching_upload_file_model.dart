import '../../domain/entities/coaching_upload_file.dart';

class CoachingUploadFileModel extends CoachingUploadFile {
  const CoachingUploadFileModel({
    super.fileLink,
    super.fileType,
    super.originalName,
  });

  factory CoachingUploadFileModel.fromJson(final Map<String, dynamic> json) {
    final Map<String, dynamic> meta =
        json['meta'] as Map<String, dynamic>? ?? json;

    return CoachingUploadFileModel(
      fileLink: meta['file_link'] as String?,
      fileType: meta['file_type'] as String?,
      originalName: meta['original_name'] as String?,
    );
  }

  factory CoachingUploadFileModel.fromEntity(final CoachingUploadFile file) {
    return CoachingUploadFileModel(
      fileLink: file.fileLink,
      fileType: file.fileType,
      originalName: file.originalName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': {
        'file_link': fileLink,
        'file_type': fileType,
        'original_name': originalName,
      },
    };
  }
}
