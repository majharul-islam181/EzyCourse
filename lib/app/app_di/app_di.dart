import '../../core/di/core_di.dart' as core_di;
import '../../features/auth/di/auth_di.dart';

Future<void> init() async {
  await core_di.initDependencies();
  initAuthDependencies();
}
