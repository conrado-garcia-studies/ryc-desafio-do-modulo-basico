import 'package:shop/models/task.dart';
import 'package:shop/utils/constants.dart';

class User {
  User({
    required userId,
    required tasks,
    required this.coinsCount,
    required this.purchasedLivesCount,
  })  : _userId = userId,
        _tasks = tasks;

  final String _userId;
  final List<Task> _tasks;
  int coinsCount;
  int purchasedLivesCount;

  String get userId => _userId;
  List<Task> get tasks => [..._tasks];
  int get tasksCount => _tasks.length;

  Task getTaskByIndex(final int index) {
    return _tasks[index];
  }

  void cancelTaskTimers() {
    for (final Task task in _tasks) {
      task.timer?.cancel();
    }
  }

  void addTask(final Task task) {
    _tasks.add(task);
  }

  void sortTasks() {
    _tasks.sort();
  }

  int calculateLivesCount() {
    final int overdueTasksCount =
        _tasks.where((task) => task.isOverdue()).length;
    return purchasedLivesCount -
        overdueTasksCount * Constants.lostLivesCountPerOverdueTask;
  }
}
