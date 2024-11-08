import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:flutter/gestures.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../controllers/auth_controller.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  const ForgotPasswordOtpScreen({super.key});

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  bool _verifyingOtpInProgress = false;
  String? otpCode;
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
                  'Pin Verification',
                  style: textTheme.headlineLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'A 6 digit verification otp has been sent to your email address',
                  style: textTheme.titleSmall
                      ?.copyWith(color: Colors.grey),
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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const SignInScreen()), (_) => false);

  }

  Widget _buildVerifyEmailMethod() {
    return Column(
      children: [
        PinCodeTextField(
          length: 6,
          onCompleted: (value){
            otpCode = value;
          },
          obscureText: false,
          animationType: AnimationType.fade,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
            inactiveFillColor: Colors.white,
            selectedFillColor: Colors.white
          ),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
          appContext: context,

        ),
        const SizedBox(height: 16),
        Visibility(
          visible: _verifyingOtpInProgress == false,
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
    _verifyOtp();
  }
  Future<void> _verifyOtp() async {
    _verifyingOtpInProgress = true;
    NetworkResponse response = await NetworkCaller.getRequest(url: Urls.verifyOtpStatus(AuthController.verifiedEmailData.toString(),otpCode!));
    _verifyingOtpInProgress = false;
    if (response.isSuccess) {
      await AuthController.saveotp(AuthController.verifiedEmailData.toString(),otpCode!);
      print(AuthController.otpData);
      showSnackBarMessage(context, 'otp verified!');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const ResetPasswordScreen(),),);

    }else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }
}
