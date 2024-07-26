class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'Email already registered.',
    'OPERATION_NOT_ALLOWED': 'Operation not permitted!',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Access temporarily blocked. Try later.',
    'EMAIL_NOT_FOUND': 'Email not found.',
    'INVALID_PASSWORD': 'Password entered does not match.',
    'USER_DISABLED': 'The user account has been disabled.',
  };
  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'An error occurred in the authentication process.';
  }
}
