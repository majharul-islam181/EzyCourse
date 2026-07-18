import 'package:equatable/equatable.dart';

class CoachingNote extends Equatable {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isViewAllowed;

  const CoachingNote({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.isViewAllowed,
  });

  @override
  List<Object?> get props => [id, title, content, createdAt, isViewAllowed];
}
