import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:humanize_duration/humanize_duration.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/image_toast.dart';
import 'package:shop/models/level.dart';
import 'package:shop/models/task.dart';
import 'package:shop/providers/home_provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/utils/app_logger.dart';
import 'package:shop/utils/constants.dart';
import 'package:shop/utils/level_utils.dart';
import 'package:shop/utils/list_utils.dart';
import 'package:shop/utils/text_styles.dart';

class TaskSubcontent extends StatefulWidget {
  const TaskSubcontent({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TaskSubcontent> createState() {
    return _TaskSubcontentState();
  }
}

class _TaskSubcontentState extends State<TaskSubcontent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, Object> _formData = <String, Object>{};
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final String dateSelectionMessage = 'Select a date...';
  final FocusNode _dueFocus = FocusNode();
  late TextEditingController _dueController;
  final FToast _fToast = FToast();

  @override
  void initState() {
    super.initState();
    if (_formData.isEmpty) {
      _formData['title'] = widget.title;
    }
    _dueController = TextEditingController(
      text: dateSelectionMessage,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final FocusNode nodeToFocus =
          widget.title.isEmpty ? _titleFocus : _descriptionFocus;
      FocusScope.of(context).requestFocus(nodeToFocus);
    });
  }

  @override
  Widget build(final BuildContext context) {
    _fToast.init(context);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              initialValue: _formData['title']?.toString(),
              focusNode: _titleFocus,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              textInputAction: TextInputAction.next,
              maxLength: Constants.maxTaskTitleLength,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_descriptionFocus),
              onSaved: (final String? title) =>
                  _formData['title'] = title ?? '',
              validator: (final String? titleToValidate) {
                final String title = titleToValidate ?? '';
                if (title.trim().isEmpty) {
                  return 'The title is required.';
                }
                if (title.trim().length < 3) {
                  return 'The title must have at least three letters.';
                }
                return null;
              },
            ),
            TextFormField(
              focusNode: _descriptionFocus,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              maxLines: 3,
              maxLength: Constants.maxTaskDescriptionLength,
              onFieldSubmitted: (_) => _showDatePicker(context),
              onSaved: (final String? description) {
                if (description != null) {
                  _formData['description'] = description;
                }
              },
            ),
            TextFormField(
              controller: _dueController,
              focusNode: _dueFocus,
              decoration: const InputDecoration(
                labelText: 'Due',
              ),
              onTap: () => _showDatePicker(context),
              onSaved: (final String? due) => _formData['due'] = due ?? '',
              validator: (final String? dueToValidate) {
                if (dueToValidate == null ||
                    dueToValidate == dateSelectionMessage) {
                  return 'The due date is required.';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                'Will you commit to it?',
                style: TextStyles.h1.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text(
                'Fidati di me!',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(final BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    showDatePicker(
      context: context,
      firstDate:
          DateTime.now().subtract(Constants.durationFromNowToDueLastDate),
      lastDate: DateTime.now().add(Constants.durationFromNowToDueLastDate),
    ).then((final DateTime? due) {
      if (due == null) {
        return;
      }
      _formData['due'] = due;
      setState(() =>
          _dueController.text = DateFormat(Constants.datePattern).format(due));
    });
  }

  Future<void> _submitForm() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();

    final HomeProvider homeProvider = Provider.of<HomeProvider>(
      context,
      listen: false,
    );
    if (homeProvider.isProcessing) {
      return;
    }
    _showInformationToast();
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    homeProvider.isProcessing = true;
    try {
      await userProvider.createTask(_formData);
    } catch (e) {
      logger.e(e);
      _showErrorToast();
    } finally {
      homeProvider.isProcessing = false;
      _goBack();
    }
  }

  void _showInformationToast() {
    final Level? level = _findLevel();
    if (level == null) {
      return;
    }
    final DateTime? due =
        _formData['due'] == null ? null : Task.parseDueFromFormData(_formData);
    if (due == null) {
      return;
    }
    final Duration difference = due.difference(DateTime.now());
    final String formattedDifference = humanizeDuration(
      difference,
      options: Constants.humanReadableDurationOptions,
    );
    final String leftOrOverdue = difference.isNegative ? 'overdue' : 'left';
    _fToast.showToast(
      child: ImageToast(
        imageAssetName: ListUtils.getRandom(level.imageAssetNames),
        text: 'You created a new task!' +
            '\n${ListUtils.getRandom(Constants.newTaskMessages)}' +
            '\n${level.message}\nTime $leftOrOverdue: $formattedDifference',
      ),
      toastDuration: Constants.toastDuration,
      gravity: ToastGravity.CENTER,
    );
  }

  Level? _findLevel() {
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
        text: 'It was not possible to create the task. Please try again' +
            ' later.',
        type: ImageToastType.error,
      ),
      toastDuration: Constants.toastDuration,
      gravity: ToastGravity.CENTER,
    );
  }

  void _goBack() {
    final HomeProvider homeProvider = Provider.of<HomeProvider>(
      context,
      listen: false,
    );
    homeProvider.subcontent = null;
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _dueFocus.dispose();
    _dueController.dispose();
  }
}
