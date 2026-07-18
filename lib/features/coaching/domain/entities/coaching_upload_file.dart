import 'package:equatable/equatable.dart';

class CoachingUploadFile extends Equatable {
  final String? fileLink;
  final String? fileType;
  final String? originalName;

  const CoachingUploadFile({this.fileLink, this.fileType, this.originalName});

  @override
  List<Object?> get props => [fileLink, fileType, originalName];
}
