import 'package:flutter/material.dart';

import '../../../../core/theme/theme_context.dart';

class CoachingSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CoachingSearchBar({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.spacing.pagePadding,
        0,
        context.spacing.pagePadding,
        context.spacing.md,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search coaching programs',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.72,
          ),
          border: _border,
          enabledBorder: _border,
          focusedBorder: _border,
        ),
      ),
    );
  }

  OutlineInputBorder get _border {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide.none,
    );
  }
}
