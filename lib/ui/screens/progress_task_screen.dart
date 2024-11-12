import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/progress_task_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  @override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressTaskController>(
      builder: (controller) {
        return Visibility(
          visible: !controller.inProgress,
          replacement: const CenteredCircularProgressIndicator(),
          child: RefreshIndicator(
            onRefresh: () async {
              _getProgressTaskList();
            },
            child: ListView.separated(
              itemCount: controller.progressedTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskModel: controller.progressedTaskList[index],
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
    );
  }

  Future<void> _getProgressTaskList() async {
    final bool result = await Get.find<ProgressTaskController>().getProgressTaskList();
    if (result == false) {
      showSnackBarMessage(context, Get.find<ProgressTaskController>().errorMessage!, true);
    }
  }
}
