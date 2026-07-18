import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/page/login_page.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: AppRouteNames.login,
        builder: (final BuildContext context, final GoRouterState state) {
          return const LoginPage();
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
