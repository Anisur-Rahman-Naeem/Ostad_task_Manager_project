import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/forgot_password_otp_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:flutter/gestures.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  TextEditingController _emailverifyTEController = TextEditingController();
  bool _verifyEmailInProgress = false;
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
                  'Your Email Address',
                  style: textTheme.headlineLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'A 6 digit verification otp will be sent to your email address',
                  style: textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildVerifyEmailMethod(),
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
    Navigator.pop(context);
  }

  Widget _buildVerifyEmailMethod() {
    return Column(
      children: [
        TextFormField(
          controller: _emailverifyTEController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'Email'),
        ),
        const SizedBox(height: 16),
        Visibility(
          visible: _verifyEmailInProgress == false,
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
    _emailVerify(_emailverifyTEController.text);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordOtpScreen(),
      ),
    );
  }

  Future<void> _emailVerify(String email) async {
    _verifyEmailInProgress = true;
    setState(() {});
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.verifyEmailStatus(email));
    _verifyEmailInProgress = false;
    if (response.isSuccess) {
      await AuthController.saveverifiedemail(_emailverifyTEController.text);
      print("Verified email : ${AuthController.verifiedEmailData}");
      showSnackBarMessage(context, "email verified otp has been sent");
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }
}
