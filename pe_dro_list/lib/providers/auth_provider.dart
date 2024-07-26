import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/utils/app_logger.dart';
import 'package:shop/utils/constants.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryTime;
  Timer? _logOutTimer;

  bool get isAuth {
    final bool isValid = _expiryTime?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> signUp(final String email, final String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(final String email, final String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> _authenticate(final String email, final String password,
      final String urlFragment) async {
    final String url =
        'https://${Constants.identityTookKitHost}/v1/accounts:$urlFragment?' +
            'key=${Constants.webApiKey}';
    final http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final Map<String, dynamic> body = jsonDecode(response.body);
    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );
      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryTime!.toIso8601String(),
      });
      _autoLogOut();
      notifyListeners();
    }
  }

  Future<void> tryAutoLogIn() async {
    if (isAuth) {
      return;
    }
    final Map<String, dynamic> userData = await Store.getMap('userData');
    if (userData.isEmpty) {
      return;
    }
    final DateTime expiryTime = DateTime.parse(userData['expiryDate']);
    if (expiryTime.isBefore(DateTime.now())) {
      return;
    }
    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryTime = expiryTime;
    _autoLogOut();
    notifyListeners();
  }

  void logOut() {
    _token = null;
    _email = null;
    _userId = null;
    _expiryTime = null;
    _clearLogOutTimer();
    Store.remove('userData').then((_) => notifyListeners());
  }

  void _autoLogOut() {
    _clearLogOutTimer();
    final int? timeToLogOutInSeconds =
        _expiryTime?.difference(DateTime.now()).inSeconds;
    logger.i('Time to log out user ${userId ?? 'null'} in seconds:' +
        ' $timeToLogOutInSeconds');
    _logOutTimer = Timer(
      Duration(seconds: timeToLogOutInSeconds ?? 0),
      logOut,
    );
  }

  void _clearLogOutTimer() {
    _logOutTimer?.cancel();
    _logOutTimer = null;
  }
}
