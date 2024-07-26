import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/life_package.dart';
import 'package:shop/models/task.dart';
import 'package:shop/models/user.dart';
import 'package:shop/utils/app_logger.dart';
import 'package:shop/utils/constants.dart';
import 'package:shop/utils/firebase_utils.dart';

class UserProvider with ChangeNotifier {
  UserProvider([
    this._userId = '',
    this._token = '',
    this._user,
  ]);

  bool _isLoadError = false;
  final String _userId;
  final String _token;
  User? _user;

  User? get user => _user;
  bool get isLoadError => _isLoadError;

  Future<void> loadUser() async {
    logger.i('Loading $_userId');
    _isLoadError = false;
    try {
      final http.Response response = await FirebaseUtils.executeRequestRetrying(
        http.get(
          FirebaseUtils.createUri(
            '/users/$_userId.json',
            _token,
          ),
        ),
      );
      final Map<String, dynamic> body =
          FirebaseUtils.validateResponseAndDecodeBody(response) ?? {};
      _user?.cancelTaskTimers();
      _user = User(
          userId: _userId,
          tasks: <Task>[],
          coinsCount: body['coinsCount'] ?? Constants.initialCoinsCount,
          purchasedLivesCount:
              body['purchasedLivesCount'] ?? Constants.initialLivesCount);
      (body['tasks'] ?? {}).forEach((key, value) {
        final Task task = Task.fromKeyAndValue(key, value);
        task.timer = _createTimer(task);
        _user!.addTask(task);
      });
      _user!.sortTasks();
    } catch (_) {
      _isLoadError = true;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  int? calculateLivesCount() {
    return _user?.calculateLivesCount();
  }

  Future<void> createTask(final Map<String, dynamic> formData) async {
    if (_user == null) {
      return;
    }
    final DateTime creation = DateTime.now();
    const bool isCompleted = false;
    final http.Response response = await FirebaseUtils.executeRequestRetrying(
      http.post(
        FirebaseUtils.createUri(
          '/users/$_userId/tasks.json',
          _token,
        ),
        body: jsonEncode(
          Task.fromFormDataToPostData(creation, formData, isCompleted),
        ),
      ),
    );
    final Map<String, dynamic> body =
        FirebaseUtils.validateResponseAndDecodeBody(response) ?? {};
    final String id = body['name'];
    final Task task = Task.fromFormData(id, creation, formData, isCompleted);
    task.timer = _createTimer(task);
    _user!
      ..addTask(task)
      ..sortTasks();
    notifyListeners();
  }

  Future<void> completeTask(final Task task) async {
    if (!task.isCompletable() || _user == null) {
      return;
    }
    await _updateTask(
      task,
      {
        'isCompleted': true,
      },
    );
    try {
      await _rewardUser();
    } catch (_) {
      await _undoTaskCompletion(task);
      rethrow;
    }
    task.complete();
    _user!.sortTasks();
    notifyListeners();
  }

  Future<void> _rewardUser() async {
    int coinsCount = await _loadCoinsCount();
    coinsCount += Constants.prizePerCompletedTaskInCoins;
    await _updateUser(
      {
        'coinsCount': coinsCount,
      },
    );
    _user!.coinsCount = coinsCount;
  }

  Future<void> _undoTaskCompletion(final Task task) async {
    await _updateTask(
      task,
      {
        'isCompleted': false,
      },
    );
  }

  Future<void> _updateTask(
      final Task task, final Map<String, dynamic> patch) async {
    await FirebaseUtils.executeRequestRetrying(
      http.patch(
        FirebaseUtils.createUri(
          '/users/$_userId/tasks/${task.id}.json',
          _token,
        ),
        body: jsonEncode(patch),
      ),
    );
  }

  Timer? _createTimer(final Task task) {
    if (task.isCompleted) {
      return null;
    }
    final Duration difference = task.due.difference(DateTime.now());
    if (difference.inMicroseconds <= 0) {
      return null;
    }
    return Timer(
      difference,
      _sortAndNotifyListeners,
    );
  }

  void _sortAndNotifyListeners() {
    _user?.sortTasks();
    notifyListeners();
  }

  Future<void> buyLifePackage(final LifePackage package) async {
    if (_user == null) {
      return;
    }
    int coinsCount = await _loadCoinsCount();
    coinsCount -= package.priceInCoins;
    if (coinsCount < 0) {
      return;
    }
    int purchasedLivesCount = await _loadPurchasedLivesCount();
    purchasedLivesCount += package.livesCount;
    await _updateUser(
      {
        'coinsCount': coinsCount,
        'purchasedLivesCount': purchasedLivesCount,
      },
    );
    _user!.coinsCount = coinsCount;
    _user!.purchasedLivesCount = purchasedLivesCount;
    notifyListeners();
  }

  Future<int> _loadCoinsCount() async {
    final http.Response response = await FirebaseUtils.executeRequestRetrying(
      http.get(
        FirebaseUtils.createUri(
          '/users/$_userId/coinsCount.json',
          _token,
        ),
      ),
    );
    return FirebaseUtils.validateResponseAndDecodeBody(response) ??
        Constants.initialCoinsCount;
  }

  Future<int> _loadPurchasedLivesCount() async {
    final http.Response response = await FirebaseUtils.executeRequestRetrying(
      http.get(
        FirebaseUtils.createUri(
          '/users/$_userId/purchasedLivesCount.json',
          _token,
        ),
      ),
    );
    return FirebaseUtils.validateResponseAndDecodeBody(response) ??
        Constants.initialLivesCount;
  }

  Future<void> _updateUser(final Map<String, dynamic> patch) async {
    await FirebaseUtils.executeRequestRetrying(
      http.patch(
        FirebaseUtils.createUri(
          '/users/$_userId.json',
          _token,
        ),
        body: jsonEncode(patch),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _user?.cancelTaskTimers();
  }
}
