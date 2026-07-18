import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/blocs/auth_session/auth_session_bloc.dart';
import '../../core/blocs/auth_session/auth_session_state.dart';
import '../../core/di/core_di.dart';
import '../../features/auth/presentation/page/login_page.dart';
import '../../features/coaching/presentation/pages/coaching_list_page.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: GoRouterRefreshStream(sl<AuthSessionBloc>().stream),
    redirect: (final BuildContext context, final GoRouterState state) {
      final AuthSessionStatus status = sl<AuthSessionBloc>().state.status;
      final bool isLoginRoute = state.uri.path == AppRoutes.login;

      if (status == AuthSessionStatus.unknown) {
        return null;
      }

      if (status == AuthSessionStatus.unauthenticated) {
        return isLoginRoute ? null : AppRoutes.login;
      }

      if (isLoginRoute) {
        return AppRoutes.coachingList;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: AppRouteNames.login,
        builder: (final BuildContext context, final GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: AppRoutes.coachingList,
        name: AppRouteNames.coachingList,
        builder: (final BuildContext context, final GoRouterState state) {
          return const CoachingListPage();
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRouteNames.home,
        builder: (final BuildContext context, final GoRouterState state) {
          return const _HomePlaceholderPage();
        },
      ),
    ],
    errorBuilder: (final BuildContext context, final GoRouterState state) {
      return const _RouteNotFoundPage();
    },
  );
}

class _HomePlaceholderPage extends StatelessWidget {
  const _HomePlaceholderPage();

  @override
  Widget build(final BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('EzyCourse')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Home route is ready.',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _RouteNotFoundPage extends StatelessWidget {
  const _RouteNotFoundPage();

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Text('Route not found', style: textTheme.titleMedium),
      ),
    );
  }
}
