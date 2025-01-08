import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/cancelled_task_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';

import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CancelledTaskController>(
      builder: (controller) {
        if (controller.inProgress) {
          // Show loading indicator when tasks are loading
          return const CenteredCircularProgressIndicator();
        }

        if (controller.cancelledTaskList.isEmpty) {
          // Show "No Tasks" message when the list is empty
          return const Center(
            child: Text(
              "No Cancelled Tasks",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        // Show task list when there are tasks
        return ListView.separated(
          itemCount: controller.cancelledTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskModel: controller.cancelledTaskList[index],
              onRefreshList: _getCancelledTaskList,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 8);
          },
        );
      },
    );
        // return Visibility(
        //   visible: !controller.inProgress,
        //   replacement: const CenteredCircularProgressIndicator(),
        //   child: RefreshIndicator(
        //     onRefresh: () async {
        //       _getCancelledTaskList();
        //     },
        //     child: ListView.separated(
        //       itemCount: controller.cancelledTaskList.length,
        //       itemBuilder: (context, index) {
        //         return TaskCard(
        //           taskModel: controller.cancelledTaskList[index],
        //           onRefreshList: _getCancelledTaskList,
        //         );
        //       },
        //       separatorBuilder: (BuildContext context, int index) {
        //         return const SizedBox(
        //           height: 8,
        //         );
        //       },
        //     ),
        //   ),
        // );
  }

  Future<void> _getCancelledTaskList() async {
    final bool result = await Get.find<CancelledTaskController>().getCancelledTaskList();
    if (result == false) {
      showSnackBarMessage(context, Get.find<CancelledTaskController>().errorMessage!, true);
    }
  }
}
