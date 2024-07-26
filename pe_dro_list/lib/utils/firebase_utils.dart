import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:shop/exceptions/firebase_exception.dart';
import 'package:shop/utils/constants.dart';

class FirebaseUtils {
  static Uri createUri(final String path, final String token) {
    return Uri(
      scheme: 'https',
      host: Constants.firebaseHost,
      path: path,
      queryParameters: {
        'auth': token,
      } as Map<String, dynamic>,
    );
  }

  static Future<http.Response> executeRequestRetrying(
      final Future<http.Response> request) {
    return retry(
      () => request.timeout(
        const Duration(seconds: 5),
      ),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
  }

  static validateResponseAndDecodeBody(final http.Response response) {
    _validateResponse(response);
    return jsonDecode(response.body);
  }

  static void _validateResponse(final http.Response response) {
    if (!_isStatusCodeOk(response.statusCode)) {
      final body = jsonDecode(response.body);
      throw FirebaseException(
        message: 'The request to Firebase was not successful.',
        statusCode: response.statusCode,
        detail: body is Map<String, dynamic> ? body['error'] : null,
      );
    }
  }

  static bool _isStatusCodeOk(final int statusCode) {
    return (statusCode ~/ 100) == 2;
  }
}
