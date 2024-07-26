import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/task_card.dart';
import 'package:shop/contents/task_subcontent.dart';
import 'package:shop/models/task.dart';
import 'package:shop/providers/home_provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/utils/constants.dart';

class TasksContent extends StatefulWidget {
  const TasksContent({Key? key}) : super(key: key);

  @override
  State<TasksContent> createState() {
    return _TasksContentState();
  }
}

class _TasksContentState extends State<TasksContent> {
  late TextEditingController _titleController;
  final FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 3,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                  ),
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'New task title',
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(126, 126, 126, 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(224, 224, 224, 1),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.go,
                    maxLength: Constants.maxTaskTitleLength,
                    onSubmitted: (_) => _goToTaskSubcontent(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                  left: 10,
                  right: 10,
                ),
                child: IconButton(
                  onPressed: _goToTaskSubcontent,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    highlightColor: Colors.black12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Consumer<UserProvider>(
          builder: (_, final UserProvider userProvider, __) {
            if (userProvider.isLoadError) {
              return Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        'It was not possible to load your tasks. Please try' +
                            ' again later.'),
                  ),
                  ElevatedButton(
                    onPressed: _reloadScreen,
                    child: const Text('Try again'),
                  ),
                ],
              );
            }
            if (userProvider.user == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final Task task = userProvider.user!.getTaskByIndex(index);
                  return TaskCard(task);
                },
                itemCount: userProvider.user!.tasksCount,
              ),
            );
          },
        ),
      ],
    );
  }

  void _goToTaskSubcontent() {
    final HomeProvider homeProvider = Provider.of<HomeProvider>(
      context,
      listen: false,
    );
    if (homeProvider.isProcessing) {
      return;
    }
    homeProvider.subcontent = TaskSubcontent(
      title: _titleController.text,
    );
    _titleController.text = '';
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _reloadScreen() {
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.authOrHome,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }
}
