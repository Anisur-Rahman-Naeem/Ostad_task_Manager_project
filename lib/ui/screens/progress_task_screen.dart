import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressedTaskListInProgress = false;
  static List<TaskModel> _progressedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_getProgressedTaskListInProgress,
      replacement: const CenteredCircularProgressIndicator(),
      child: RefreshIndicator(
        onRefresh: () async {
          _getProgressTaskList();
        },
        child: ListView.separated(
          itemCount: _progressedTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskModel: _progressedTaskList[index],
              onRefreshList: _getProgressTaskList,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 8,
            );
          },
        ),
      ),
    );
  }

  Future<void> _getProgressTaskList() async {
    _progressedTaskList.clear();
    _getProgressedTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.progressTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      _progressedTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getProgressedTaskListInProgress = false;
    setState(() {});
  }
}
