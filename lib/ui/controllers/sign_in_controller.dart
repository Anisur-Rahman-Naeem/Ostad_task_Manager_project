import 'package:get/get.dart';
import 'package:task_manager/data/models/login_model.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';

class SignInController extends GetxController {
  bool _inProgress = false;

  String? _errorMessage;

  bool passwordShow = false;

  String? get errorMessage => _errorMessage;

  bool get inProgress => _inProgress;

  final AuthController authController = Get.put(AuthController());


  void onShowTapped() {
    passwordShow = !passwordShow;
    update();
  }


  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      'email' : email,
      'password' : password,
    };

    final NetworkResponse response =
    await NetworkCaller.postRequest(url: Urls.login, body: requestBody);
    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await authController.saveAccessToken(loginModel.token!);
      await authController.saveUserData(loginModel.data!.first);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();

    return isSuccess;
  }
}