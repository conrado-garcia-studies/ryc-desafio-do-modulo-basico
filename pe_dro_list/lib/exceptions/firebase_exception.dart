import 'dart:convert';

class FirebaseException implements Exception {
  final String message;
  final int statusCode;
  String? detail;

  FirebaseException({
    required this.message,
    required this.statusCode,
    detail,
  });

  @override
  String toString() {
    return jsonEncode(
      {
        'message': message,
        'statusCode': statusCode,
        'detail': detail,
      },
    );
  }
}
