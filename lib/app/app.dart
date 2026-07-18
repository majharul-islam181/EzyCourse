import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/blocs/auth_session/auth_session_bloc.dart';
import '../core/blocs/auth_session/auth_session_event.dart';
import '../core/di/core_di.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_manager.dart';
import '../flavors/app_flavor.dart';
import 'routes/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthSessionBloc>.value(
          value: sl<AuthSessionBloc>()..add(const AuthSessionStarted()),
        ),
        BlocProvider<ThemeBloc>(
          create: (_) => sl<ThemeBloc>()..add(LoadTheme()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState state) {
          return MaterialApp.router(
            title: AppFlavorConfig.instance.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state.themeMode,
            routerConfig: AppRouter.router,
            builder: (final BuildContext context, final Widget? child) {
              final Widget appChild = child ?? const SizedBox.shrink();

              if (AppFlavorConfig.isDev) {
                return Banner(
                  message: 'DEV',
                  location: BannerLocation.topStart,
                  color: Colors.green,
                  child: appChild,
                );
              }

              return appChild;
            },
          );
        },
      ),
    );
  }
}
