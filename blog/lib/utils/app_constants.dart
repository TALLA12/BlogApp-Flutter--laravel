class AppConstants {
  static const String APP_NAME = "SAMABLOG";
  static const int APP_VERSION = 1;

  static const String baseUrl = "http://192.168.1.27:8000";
  static const String loginUrl = baseUrl + '/api/login';
  static const String registerUrl = baseUrl + '/api/register';

  static const String logoutUrl = baseUrl + '/api/logout';
  static const String userUrl = baseUrl + '/api/user';
  static const String postsUrl = baseUrl + '/api/posts';
  static const String commentsURL = baseUrl + '/api/comments';

  static const String serverError = 'Server error';
  static const String unauthorized = 'Unauthorized';
  static const String somethingwentWrong = 'Something went wrong,try agin';
}
