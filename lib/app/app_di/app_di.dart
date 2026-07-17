import '../../core/di/core_di.dart' as core_di;

Future<void> init() async {
  await core_di.initDependencies();
}
