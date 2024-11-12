import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/new_task_list_controller.dart';
import 'package:task_manager/ui/controllers/task_count_controller.dart';
import 'package:task_manager/ui/controllers/verify_otp_controller.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/models/task_status_model.dart';
import '../widgets/task_card.dart';
import '../widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  @override
  void initState() {
    super.initState();
    _getNewTaskList();
    _getTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _getNewTaskList();
          _getTaskStatusCount();
        },
        child: Column(
          children: [
            _buildSummarySection(),
            Expanded(
              child: GetBuilder<NewTaskListController>(
                builder: (controller) {
                  return Visibility(
                    visible: !controller.inProgress,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ListView.separated(
                      itemCount: controller.taskList.length,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskModel: controller.taskList[index],
                          onRefreshList: _getNewTaskListAndTaskStatusCount,
                          //todo: when onRefreshList will be triggered while the app is running (needs explanation)
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 8,
                        );
                      },
                    ),
                  );
                }
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onTapAddFAB(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _onTapAddFAB(BuildContext context) async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
    if (shouldRefresh == true) {
      _getNewTaskList();
      _getTaskStatusCount();
    }
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetBuilder<TaskCountController>(
        builder: (controller) {
          return Visibility(
            visible: controller.getTaskStatusCountListInProgress == false,
            replacement: const CenteredCircularProgressIndicator(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _getTaskSummaryCardList(),
              ),
            ),
          );
        }
      ),
    );
  }

  List<TaskSummaryCard> _getTaskSummaryCardList() {
    List<TaskSummaryCard> taskSummaryCardList = [];
    for (TaskStatusModel t in Get.find<TaskCountController>().TaskStatusCountList) {
      taskSummaryCardList
          .add(TaskSummaryCard(title: t.sId!, count: t.sum ?? 0));
    }
    return taskSummaryCardList;
  }

  Future<void> _getNewTaskList() async {
    final bool result = await Get.find<NewTaskListController>().getNewTaskList();
    if (result == false) {
      showSnackBarMessage(context, Get.find<NewTaskListController>().errorMessage!, true);
    }
  }

  _getNewTaskListAndTaskStatusCount(){
    _getNewTaskList();
    _getTaskStatusCount();
  }

  Future<void> _getTaskStatusCount() async {
    final bool result = await Get.find<TaskCountController>().getTaskStatusCount();
    if (result == false) {
      showSnackBarMessage(context, Get.find<TaskCountController>().errorMessage!, true);
    }
  }
}
