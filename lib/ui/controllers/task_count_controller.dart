import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/data/models/task_status_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class TaskCountController extends GetxController {
  bool _getTaskStatusCountListInProgress = false;
  List<TaskStatusModel> _taskStatusCountList = [];

  String? _errorMessage;

  List<TaskStatusModel> get TaskStatusCountList => _taskStatusCountList;

  bool get getTaskStatusCountListInProgress => _getTaskStatusCountListInProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> getTaskStatusCount() async {
    bool isSuccess = false;
    _taskStatusCountList.clear();
    _getTaskStatusCountListInProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.taskStatusCount);
    if (response.isSuccess) {
      final TaskStatusCountModel taskStatusCountModel =
      TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList = taskStatusCountModel.taskStatusCountList ?? [];
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _getTaskStatusCountListInProgress = false;
    update();

    return isSuccess;
  }
}