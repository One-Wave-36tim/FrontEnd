class AuthSession {
  AuthSession._();

  static String? accessToken;
  static String? userId;

  static bool get isLoggedIn => (accessToken ?? '').isNotEmpty;

  static void setSession({
    required String accessToken,
    required String userId,
  }) {
    AuthSession.accessToken = accessToken;
    AuthSession.userId = userId;
  }

  static void clear() {
    accessToken = null;
    userId = null;
  }
}
