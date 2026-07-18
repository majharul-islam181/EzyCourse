import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/custom_snakbar.dart';

class FeedCardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String label;

  const FeedCardHeader({
    required this.icon,
    required this.title,
    required this.label,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: colorScheme.onPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedCommentButton extends StatelessWidget {
  final int commentCount;

  const FeedCommentButton({required this.commentCount, super.key});

  @override
  Widget build(final BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.mode_comment_outlined),
      label: Text('$commentCount comments'),
    );
  }
}

InputDecoration feedInputDecoration(
  final BuildContext context, {
  required final String hintText,
}) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;

  return InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: colorScheme.surfaceContainer,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  );
}

Future<void> openFeedLink(final BuildContext context, final String? url) async {
  if (url == null || url.isEmpty) {
    CustomSnackBar.show(
      context: context,
      message: 'No file link found.',
      type: SnackBarType.warning,
    );
    return;
  }

  final Uri? uri = Uri.tryParse(url);
  if (uri == null) {
    CustomSnackBar.show(
      context: context,
      message: 'Invalid file link.',
      type: SnackBarType.error,
    );
    return;
  }

  final bool opened = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );
  if (!opened && context.mounted) {
    CustomSnackBar.show(
      context: context,
      message: 'Unable to open this file.',
      type: SnackBarType.error,
    );
  }
}

void showSubmissionInfo(final BuildContext context) {
  CustomSnackBar.show(
    context: context,
    message: 'Submission API is ready to connect.',
    type: SnackBarType.info,
  );
}
