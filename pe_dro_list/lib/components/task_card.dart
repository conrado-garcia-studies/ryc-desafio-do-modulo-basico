import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/image_toast.dart';
import 'package:shop/models/level.dart';
import 'package:shop/models/task.dart';
import 'package:shop/providers/home_provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/utils/app_logger.dart';
import 'package:shop/utils/constants.dart';
import 'package:shop/utils/format_utils.dart';
import 'package:shop/utils/level_utils.dart';
import 'package:shop/utils/list_utils.dart';
import 'package:shop/utils/math_utils.dart';

class TaskCard extends StatelessWidget {
  TaskCard(this.task, {Key? key}) : super(key: key);

  final Task task;
  final FToast _fToast = FToast();

  @override
  Widget build(final BuildContext context) {
    _fToast.init(context);
    var borderColor = _getStatusColor(context, TaskCardPart.border);
    var textColor = _getStatusColor(context, TaskCardPart.text);
    final String formattedDue =
        DateFormat(Constants.datePattern).format(task.due);
    final int daysRemainingCount = task.calculateDaysRemainingCount();
    final String? formatteDaysRemainingCount = FormatUtils.formatInteger(
      MathUtils.ensureRange(daysRemainingCount, 0, null),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      child: Tooltip(
        message: task.description ?? '',
        child: GestureDetector(
          child: Card(
            key: ValueKey(task.id),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: borderColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    'Due: $formattedDue',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                            top: 5,
                            left: 10,
                            right: 20,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: borderColor,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Days left:',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                formatteDaysRemainingCount ?? '?',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: borderColor,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 13,
                            ),
                            child: IconButton(
                              alignment: Alignment.center,
                              onPressed: () => _confirmCompletion(context),
                              icon: _getIcon(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () => _confirmCompletion(context),
        ),
      ),
    );
  }

  Color _getStatusColor(final BuildContext context, final TaskCardPart part) {
    if (task.isCompleted) {
      return part == TaskCardPart.text
          ? Colors.green
          : Colors.green[100] ?? Colors.green;
    }
    if (task.isOverdue()) {
      return part == TaskCardPart.text
          ? Colors.red
          : Colors.red[100] ?? Colors.red;
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return part == TaskCardPart.text
        ? colorScheme.secondary
        : colorScheme.tertiary;
  }

  Icon _getIcon() {
    const IconData iconData = Icons.check_circle;
    const double size = 30;
    if (task.isCompleted) {
      return const Icon(
        iconData,
        size: size,
        color: Colors.green,
      );
    }
    if (task.isOverdue()) {
      return const Icon(
        iconData,
        size: size,
        color: Colors.red,
      );
    }
    return const Icon(
      iconData,
      size: size,
      color: Color.fromRGBO(126, 126, 126, 1),
    );
  }

  void _confirmCompletion(final BuildContext context) {
    if (!task.isCompletable()) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text('You are completing "${task.title}", is that correct?'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('Nope, give me some more time...'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _completeTask(context);
              },
              child: const Text('Yes, that\'s right!'),
            ),
          ],
          backgroundColor: Colors.white,
        );
      },
    );
  }

  Future<void> _completeTask(final BuildContext context) async {
    final HomeProvider homeProvider = Provider.of<HomeProvider>(
      context,
      listen: false,
    );
    if (homeProvider.isProcessing) {
      return;
    }
    _showInformationToast(context);
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    homeProvider.isProcessing = true;
    try {
      await userProvider.completeTask(task);
    } catch (e) {
      logger.e(e);
      _showErrorToast();
    } finally {
      homeProvider.isProcessing = false;
    }
  }

  void _showInformationToast(final BuildContext context) {
    final Level? level = _findLevel(context);
    if (level == null) {
      return;
    }
    _fToast.showToast(
      child: ImageToast(
        imageAssetName: ListUtils.getRandom(level.imageAssetNames),
        text: '${ListUtils.getRandom(Constants.completionMessages)}' +
            '\n${level.message}',
      ),
      toastDuration: Constants.toastDuration,
      gravity: ToastGravity.CENTER,
    );
  }

  Level? _findLevel(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    final int? livesCount = userProvider.user?.calculateLivesCount();
    return LevelUtils.findLevel(livesCount);
  }

  void _showErrorToast() {
    _fToast.showToast(
      child: ImageToast(
        imageAssetName: ListUtils.getRandom(Constants.errorImageAssetNames),
        text: 'It was not possible to save the task completion. Please try' +
            ' again later.',
        type: ImageToastType.error,
      ),
      toastDuration: Constants.toastDuration,
      gravity: ToastGravity.CENTER,
    );
  }
}

enum TaskCardPart {
  border,
  text,
}
