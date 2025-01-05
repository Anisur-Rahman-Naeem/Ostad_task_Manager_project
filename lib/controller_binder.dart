import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/controllers/bottom_nav_bar_controller.dart';
import 'package:task_manager/ui/controllers/cancelled_task_controller.dart';
import 'package:task_manager/ui/controllers/completed_task_controller.dart';
import 'package:task_manager/ui/controllers/forgot_password_email_screen_controller.dart';
import 'package:task_manager/ui/controllers/new_task_list_controller.dart';
import 'package:task_manager/ui/controllers/pick_image_controller.dart';
import 'package:task_manager/ui/controllers/profile_screen_controller.dart';
import 'package:task_manager/ui/controllers/progress_task_controller.dart';
import 'package:task_manager/ui/controllers/reset_password_controller.dart';
import 'package:task_manager/ui/controllers/sign_in_controller.dart';
import 'package:task_manager/ui/controllers/sign_up_controller.dart';
import 'package:task_manager/ui/controllers/task_count_controller.dart';
import 'package:task_manager/ui/controllers/verify_otp_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(NewTaskListController());
    Get.put(TaskCountController());
    Get.put(SignUpController());
    Get.put(AddNewTaskController());
    Get.put(CancelledTaskController());
    Get.put(CompletedTaskController());
    Get.put(ProgressTaskController());
    Get.put(UpdateProfileController());
    Get.put(ForgotPasswordEmailScreenController());
    Get.put(VerifyOtpController());
    Get.put(ResetPasswordController());
    Get.put(PickImageController());
    Get.put(BottomNavBarController());
    Get.put(AuthController());
  }
}