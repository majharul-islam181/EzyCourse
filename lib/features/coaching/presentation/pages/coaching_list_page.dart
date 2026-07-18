import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/blocs/auth_session/auth_session_bloc.dart';
import '../../../../core/blocs/auth_session/auth_session_event.dart';
import '../../../../core/theme/theme_context.dart';

class CoachingListPage extends StatelessWidget {
  const CoachingListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coaching Programs'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthSessionBloc>().add(
                const AuthSessionLogoutRequested(),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(context.spacing.pagePadding),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: context.radius.feedItem,
          ),
          child: Padding(
            padding: EdgeInsets.all(context.spacing.cardPadding),
            child: Text(
              'Coaching list route is ready.',
              style: context.text.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
