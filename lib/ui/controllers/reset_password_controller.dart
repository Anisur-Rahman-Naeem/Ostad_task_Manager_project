import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';

class ResetPasswordController extends GetxController {

  bool _inProgress = false;
  String? _errorMessage;
  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  final AuthController authController = Get.put(AuthController());


  Future<bool> resettingPassword(String password) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    Map<String, dynamic>? requestBody = {
      "email":authController.verifiedEmailData,
      "OTP": authController.otpData,
      "password":password,
    };
    NetworkResponse response = await NetworkCaller.postRequest(url: Urls.recoverPasswordStatus,body: requestBody);
    if (response.isSuccess) {
      isSuccess = true;
    }else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();

    return isSuccess;

  }

}