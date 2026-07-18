import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/coaching_note.dart';

class CoachingNotesBottomSheet extends StatelessWidget {
  final List<CoachingNote> notes;

  const CoachingNotesBottomSheet({required this.notes, super.key});

  @override
  Widget build(final BuildContext context) {
    final List<CoachingNote> visibleNotes = notes
        .where((final CoachingNote note) => note.isViewAllowed)
        .toList();

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Coach Notes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: visibleNotes.isEmpty
                ? const _EmptyNotesView()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemBuilder: (final BuildContext context, final int index) {
                      return _CoachNoteItem(note: visibleNotes[index]);
                    },
                    separatorBuilder:
                        (final BuildContext context, final int index) {
                          return const SizedBox(height: 12);
                        },
                    itemCount: visibleNotes.length,
                  ),
          ),
        ],
      ),
    );
  }
}

class _CoachNoteItem extends StatelessWidget {
  final CoachingNote note;

  const _CoachNoteItem({required this.note});

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  note.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Html(data: note.content),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text(
              DateFormatter.toReadableWithTime(note.createdAt),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyNotesView extends StatelessWidget {
  const _EmptyNotesView();

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'No coach notes available',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
