import '../core/constants/app_constants.dart';
import 'app_flavor.dart';

void configureDevelopment() {
  AppFlavorConfig.initialize(
    flavor: Flavor.development,
    appName: 'EzyCourse',
    baseUrl: AppConstants.apiBaseUrl,
    enableLogging: true,
  );
}
