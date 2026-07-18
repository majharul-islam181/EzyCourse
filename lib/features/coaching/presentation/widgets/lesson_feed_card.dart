import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../domain/entities/coaching_feed.dart';
import '../../domain/entities/coaching_feed_type.dart';
import '../../domain/entities/coaching_lesson.dart';
import '../../domain/entities/coaching_upload_file.dart';
import 'feed_card_shared.dart';

class LessonFeedCard extends StatelessWidget {
  final CoachingFeed feed;

  const LessonFeedCard({required this.feed, super.key});

  @override
  Widget build(final BuildContext context) {
    final CoachingLesson? lesson = feed.lesson;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FeedCardHeader(
          icon: _lessonIcon(lesson?.type),
          title: lesson?.title ?? 'Lesson',
          label: _lessonLabel(lesson?.type),
        ),
        const SizedBox(height: 12),
        _LessonContent(lesson: lesson),
        const SizedBox(height: 12),
        FeedCommentButton(commentCount: feed.commentCount),
      ],
    );
  }
}

class _LessonContent extends StatelessWidget {
  final CoachingLesson? lesson;

  const _LessonContent({required this.lesson});

  @override
  Widget build(final BuildContext context) {
    return switch (lesson?.type) {
      CoachingLessonType.video => _VideoLessonContent(lesson: lesson),
      CoachingLessonType.audio => _AudioLessonContent(lesson: lesson),
      CoachingLessonType.pdf ||
      CoachingLessonType.ppt ||
      CoachingLessonType.download => _FileLessonContent(lesson: lesson),
      CoachingLessonType.text => Html(
        data: lesson?.textDescription ?? lesson?.description ?? '',
      ),
      CoachingLessonType.unknown ||
      null => Html(data: lesson?.description ?? lesson?.textDescription ?? ''),
    };
  }
}

class _VideoLessonContent extends StatelessWidget {
  final CoachingLesson? lesson;

  const _VideoLessonContent({required this.lesson});

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final CoachingUploadFile? file = _firstUploadFile(lesson);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isImageFile(file))
              CachedNetworkImage(imageUrl: file!.fileLink!, fit: BoxFit.cover)
            else
              ColoredBox(
                color: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.video_library_outlined,
                  color: colorScheme.onSurfaceVariant,
                  size: 48,
                ),
              ),
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () => openFeedLink(context, file?.fileLink),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: colorScheme.primary,
                  child: Icon(
                    Icons.play_arrow,
                    color: colorScheme.onPrimary,
                    size: 34,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioLessonContent extends StatelessWidget {
  final CoachingLesson? lesson;

  const _AudioLessonContent({required this.lesson});

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final CoachingUploadFile? file = _firstUploadFile(lesson);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton(
              onPressed: () => openFeedLink(context, file?.fileLink),
              icon: Icon(
                Icons.play_circle_fill,
                color: colorScheme.primary,
                size: 36,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LinearProgressIndicator(
                value: 0,
                color: colorScheme.primary,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.graphic_eq, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _FileLessonContent extends StatelessWidget {
  final CoachingLesson? lesson;

  const _FileLessonContent({required this.lesson});

  @override
  Widget build(final BuildContext context) {
    final CoachingUploadFile? file = _firstUploadFile(lesson);

    return OutlinedButton.icon(
      onPressed: () => openFeedLink(context, file?.fileLink),
      icon: Icon(_lessonIcon(lesson?.type)),
      label: Text(file?.originalName ?? _lessonLabel(lesson?.type)),
    );
  }
}

IconData _lessonIcon(final CoachingLessonType? type) {
  return switch (type) {
    CoachingLessonType.video => Icons.play_circle_outline,
    CoachingLessonType.audio => Icons.headphones_outlined,
    CoachingLessonType.pdf => Icons.picture_as_pdf_outlined,
    CoachingLessonType.ppt => Icons.slideshow_outlined,
    CoachingLessonType.download => Icons.download_outlined,
    CoachingLessonType.text => Icons.article_outlined,
    CoachingLessonType.unknown || null => Icons.school_outlined,
  };
}

String _lessonLabel(final CoachingLessonType? type) {
  return switch (type) {
    CoachingLessonType.video => 'Video',
    CoachingLessonType.audio => 'Audio',
    CoachingLessonType.pdf => 'PDF',
    CoachingLessonType.ppt => 'PPT',
    CoachingLessonType.download => 'Download',
    CoachingLessonType.text => 'Text',
    CoachingLessonType.unknown || null => 'Lesson',
  };
}

CoachingUploadFile? _firstUploadFile(final CoachingLesson? lesson) {
  if (lesson == null || lesson.uploadFiles.isEmpty) {
    return null;
  }

  return lesson.uploadFiles.first;
}

bool _isImageFile(final CoachingUploadFile? file) {
  final String? fileType = file?.fileType?.toLowerCase();
  final String? fileLink = file?.fileLink?.toLowerCase();

  return fileType == 'image' ||
      fileLink?.endsWith('.jpg') == true ||
      fileLink?.endsWith('.jpeg') == true ||
      fileLink?.endsWith('.png') == true ||
      fileLink?.endsWith('.webp') == true;
}
