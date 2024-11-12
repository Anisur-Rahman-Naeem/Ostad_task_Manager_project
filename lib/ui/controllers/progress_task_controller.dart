import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class ProgressTaskController extends GetxController {

  static List<TaskModel> _progressedTaskList = [];
  bool _inProgress = false;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  List<TaskModel> get progressedTaskList => _progressedTaskList;

  bool get inProgress => _inProgress;

  Future<bool> getProgressTaskList() async {
    bool isSuccess = false;
    _progressedTaskList.clear();
    _inProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.progressTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _progressedTaskList = taskListModel.taskList ?? [];
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;
  }
}