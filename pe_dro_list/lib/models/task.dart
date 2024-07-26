import 'dart:async';

import 'package:intl/intl.dart';
import 'package:shop/utils/constants.dart';
import 'package:shop/utils/date_time_utils.dart';

class Task implements Comparable<Task> {
  Task({
    required this.id,
    required this.creation,
    required this.title,
    this.description,
    required this.due,
    required this.isCompleted,
  });

  final String id;
  final DateTime creation;
  final String title;
  String? description;
  final DateTime due;
  Timer? timer;
  bool isCompleted;
  static final DateFormat _dateFormat = DateFormat(Constants.datePattern);

  static Task fromKeyAndValue(final key, final value) {
    return Task(
      id: key,
      creation: DateTime.parse(value['creation']),
      title: value['title'],
      description: value['description'],
      due: DateTime.parse(value['due']),
      isCompleted: value['isCompleted'],
    );
  }

  @override
  int compareTo(final Task other) {
    final bool isThisOverdue = isOverdue();
    int comparison =
        isThisOverdue == other.isOverdue() ? 0 : (isThisOverdue ? 1 : -1);
    if (comparison != 0) {
      return comparison;
    }
    comparison = isCompleted == other.isCompleted ? 0 : (isCompleted ? 1 : -1);
    if (comparison != 0) {
      return comparison;
    }
    return other.creation.compareTo(creation);
  }

  static Map<String, dynamic> fromFormDataToPostData(final DateTime creation,
      final Map<String, dynamic> formData, final bool isCompleted) {
    return {
      'creation': creation.toIso8601String(),
      'title': formData['title'],
      'description': formData['description'],
      'due': parseDueFromFormData(formData).toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  static Task fromFormData(final String id, final DateTime creation,
      final Map<String, dynamic> formData, final bool isCompleted) {
    return Task(
      id: id,
      creation: creation,
      title: formData['title'],
      description: formData['description'],
      due: parseDueFromFormData(formData),
      isCompleted: isCompleted,
    );
  }

  static DateTime parseDueFromFormData(final Map<String, dynamic> formData) {
    return DateTimeUtils.getEndOfDay(
      _dateFormat.parse(
        formData['due'].toString(),
      ),
    );
  }

  void complete() {
    if (!isCompletable()) {
      return;
    }
    isCompleted = true;
    timer?.cancel();
  }

  bool isCompletable() {
    return !isCompleted && !isOverdue();
  }

  bool isOverdue() {
    return !isCompleted && DateTime.now().isAfter(due);
  }

  int calculateDaysRemainingCount() {
    return due.difference(DateTime.now()).inDays;
  }
}
