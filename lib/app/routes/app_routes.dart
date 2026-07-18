class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String login = '/login';
  static const String coachingList = '/coaching';
  static const String coachingDetails = '/coaching/:programId';

  static String coachingDetailsPath(final int programId) {
    return '/coaching/$programId';
  }
}

class AppRouteNames {
  AppRouteNames._();

  static const String home = 'home';
  static const String login = 'login';
  static const String coachingList = 'coachingList';
  static const String coachingDetails = 'coachingDetails';
}
