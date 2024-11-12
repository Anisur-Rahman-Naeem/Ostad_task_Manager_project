import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/completed_task_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompletedTaskController>(
      builder: (controller) {
        return Visibility(
          visible: !controller.inProgress,
          replacement: const CenteredCircularProgressIndicator(),
          child: RefreshIndicator(
            onRefresh: () async{
              _getCompletedTaskList();
            },
            child: ListView.separated(
              itemCount: controller.completedTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskModel: controller.completedTaskList[index],
                  onRefreshList: _getCompletedTaskList,
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
    );
  }

  Future<void> _getCompletedTaskList() async {
    final bool result = await Get.find<CompletedTaskController>().getCompletedTaskList();
    if (result == false) {
      showSnackBarMessage(context, Get.find<CompletedTaskController>().errorMessage!, true);
    }
  }
}
