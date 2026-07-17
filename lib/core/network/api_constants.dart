class ApiConstants {
  ApiConstants._();

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const String login = '/student/auth/login';
  static const String getCoachingProgramList = '/student/coaching-programs/getEnrolledCoachingProgramList';
  static String getCoachingProgramDetails(int programId) => '/coach/feeds/content/$programId';

  static  String getCoachingFeedList(int programId, int sessionId) => '/coach/feeds/get-all/$programId/session/$sessionId';

  static const String getCoachingNotes = '/coach/feeds/coaching-notes-program-wise/';
  static const String submitTracker = '/coach/coaching-program-submissions/tracker';
  static const String updateTracker = '/coach/coaching-program-submissions/update-tracker';
  static const String submitJournal = '/coach/coaching-program-submissions/journal';
  static const String updateJournal = '/coach/coaching-program-submissions/update-journal';  

}
