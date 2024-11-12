import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';

class VerifyOtpController extends GetxController {

  String? _otpCode;
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String? get otpCode => _otpCode;
  set otpCCode (String otp){
    _otpCode = otp;
  }
  String? get errorMessage => _errorMessage;

  Future<bool> verifyOtp() async {
    bool isSuccess = false;
    _inProgress = true;
    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.verifyOtpStatus(
            AuthController.verifiedEmailData.toString(), otpCode!));
    if (response.isSuccess) {
      await AuthController.saveotp(AuthController.verifiedEmailData.toString(),otpCode!);
      isSuccess = true;
    }else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;
  }
}