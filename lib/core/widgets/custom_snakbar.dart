import 'package:flutter/material.dart';

import '../theme/theme_context.dart';

enum SnackBarType { success, warning, error, info }

class CustomSnackBar {
  CustomSnackBar._();

  static void show({
    required final BuildContext context,
    required final String message,
    final SnackBarType type = SnackBarType.info,
    final String? title,
    final Duration duration = const Duration(seconds: 3),
    final SnackBarAction? action,
  }) {
    final SnackBarStyle style = _styleFor(context, type);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          content: DecoratedBox(
            decoration: BoxDecoration(
              color: style.backgroundColor,
              borderRadius: context.radius.card,
              border: Border.all(color: style.borderColor),
            ),
            child: Padding(
              padding: EdgeInsets.all(context.spacing.cardPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(style.icon, color: style.foregroundColor, size: 22),
                  SizedBox(width: context.spacing.sm),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null) ...[
                          Text(
                            title,
                            style: context.text.labelLarge?.copyWith(
                              color: style.foregroundColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: context.spacing.xs),
                        ],
                        Text(
                          message,
                          style: context.text.bodyMedium?.copyWith(
                            color: style.foregroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          action: action,
        ),
      );
  }

  static SnackBarStyle _styleFor(
    final BuildContext context,
    final SnackBarType type,
  ) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case SnackBarType.success:
        return SnackBarStyle(
          icon: Icons.check_circle_outline,
          backgroundColor: context.colors.success.withValues(alpha: 0.14),
          foregroundColor: context.colors.success,
          borderColor: context.colors.success.withValues(alpha: 0.32),
        );
      case SnackBarType.warning:
        return SnackBarStyle(
          icon: Icons.warning_amber_rounded,
          backgroundColor: context.colors.warning.withValues(alpha: 0.16),
          foregroundColor: colorScheme.onSurface,
          borderColor: context.colors.warning.withValues(alpha: 0.42),
        );
      case SnackBarType.error:
        return SnackBarStyle(
          icon: Icons.error_outline,
          backgroundColor: colorScheme.errorContainer,
          foregroundColor: colorScheme.onErrorContainer,
          borderColor: colorScheme.error.withValues(alpha: 0.34),
        );
      case SnackBarType.info:
        return SnackBarStyle(
          icon: Icons.info_outline,
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          borderColor: colorScheme.primary.withValues(alpha: 0.28),
        );
    }
  }
}

class SnackBarStyle {
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  const SnackBarStyle({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });
}
