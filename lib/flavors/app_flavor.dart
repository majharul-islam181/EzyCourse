enum Flavor {
  development,
  production,
}

class AppFlavorConfig {
  final Flavor flavor;
  final String appName;
  final String baseUrl;
  final bool enableLogging;

  static AppFlavorConfig? _instance;

  AppFlavorConfig._internal({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    this.enableLogging = true,
  });

  static void initialize({
    required Flavor flavor,
    required String appName,
    required String baseUrl,
    bool enableLogging = true,
  }) {
    _instance = AppFlavorConfig._internal(
      flavor: flavor,
      appName: appName,
      baseUrl: baseUrl,
      enableLogging: enableLogging,
    );
  }

  static AppFlavorConfig get instance {
    if (_instance == null) {
      throw StateError('FlavorConfig not initialized. Call AppFlavorConfig.initialize first.');
    }
    return _instance!;
  }

  static bool get isDev => instance.flavor == Flavor.development;
  static bool get isProd => instance.flavor == Flavor.production;
}
