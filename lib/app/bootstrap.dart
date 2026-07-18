import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../flavors/app_flavor.dart';
import 'app.dart';
import 'app_di/app_di.dart' as di;

Future<void> bootstrap(final VoidCallback configureFlavor) {
  return runZonedGuarded<Future<void>>(() async {
        WidgetsFlutterBinding.ensureInitialized();
        configureFlavor();
        _bindErrorHandlers();
        await di.init();
        runApp(const EzyCourseApp());
      }, _handleUncaughtError) ??
      Future<void>.value();
}

void _bindErrorHandlers() {
  FlutterError.onError = (final FlutterErrorDetails details) {
    if (AppFlavorConfig.isDev) {
      FlutterError.presentError(details);
    }

    _handleUncaughtError(
      details.exception,
      details.stack ?? StackTrace.current,
    );
  };

  PlatformDispatcher.instance.onError =
      (final Object error, final StackTrace stackTrace) {
        _handleUncaughtError(error, stackTrace);
        return true;
      };
}

void _handleUncaughtError(final Object error, final StackTrace stackTrace) {
  if (AppFlavorConfig.instance.enableLogging || kDebugMode) {
    debugPrint('App error: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}
