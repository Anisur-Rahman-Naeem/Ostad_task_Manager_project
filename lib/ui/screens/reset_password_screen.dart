import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:flutter/gestures.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _resettingPasswordInProgress = false;
  TextEditingController _passwordTEController = TextEditingController();
  TextEditingController _confirmPassTEController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 82),
                Text(
                  'Set Password',
                  style: textTheme.headlineLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Minimum number of password should be 8 letters',
                  style: textTheme.titleSmall
                      ?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildResetPasswordForm(),
                const SizedBox(height: 24),

                _buildSignUpSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _onTapSignIn() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const SignInScreen()), (_) => false);
  }

  Widget _buildResetPasswordForm() {
    return Column(
      children: [
        TextFormField(
          controller: _passwordTEController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'Password'),
        ),
        TextFormField(
          controller: _confirmPassTEController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'Confirm Password'),
        ),
        const SizedBox(height: 16),
        Visibility(
          visible: _resettingPasswordInProgress == false,
          replacement: const CenteredCircularProgressIndicator(),
          child: ElevatedButton(
            onPressed: _onTapNextButton,
            child: const Icon(Icons.arrow_circle_right_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpSection() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.5),
          text: "Already have an account? ",
          children: [
            TextSpan(
                text: 'Sign In',
                style: const TextStyle(color: AppColors.themeColor),
                recognizer: TapGestureRecognizer()..onTap = _onTapSignIn),
          ],
        ),
      ),
    );
  }


  void _onTapNextButton() {
    _resettingPassword();
  }
  
  Future<void> _resettingPassword() async {
    _resettingPasswordInProgress = true;
    Map<String, dynamic>? requestBody = {
      "email":AuthController.verifiedEmailData,
      "OTP": AuthController.otpData,
      "password":_confirmPassTEController.text
    };
    NetworkResponse response = await NetworkCaller.postRequest(url: Urls.recoverPasswordStatus,body: requestBody);
    _resettingPasswordInProgress = false;
    if (response.isSuccess) {
      showSnackBarMessage(context, "Successful");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen(),),);
    }else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }
}
