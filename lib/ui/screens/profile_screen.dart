import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/controllers/pick_image_controller.dart';
import 'package:task_manager/ui/controllers/profile_screen_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _setUserData();
  }

  void _setUserData() {
    _emailTEController.text = authController.userData.value?.email ?? '';
    _firstNameTEController.text = authController.userData.value?.firstName ?? '';
    _lastNameTEController.text = authController.userData.value?.lastName ?? '';
    _phoneTEController.text = authController.userData.value?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        isProfileScreenOpen: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Text(
                  'Update Profiles',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 32),
                _buildPhotoPicker(),
                const SizedBox(height: 16),
                TextFormField(
                  enabled: false,
                  controller: _emailTEController,
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true){
                      return 'Enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _firstNameTEController,
                  decoration: const InputDecoration(hintText: 'First name'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true){
                      return 'Enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lastNameTEController,
                  decoration: const InputDecoration(hintText: 'Last name'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true){
                      return 'Enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneTEController,
                  decoration: const InputDecoration(hintText: 'Phone'),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true){
                      return 'Enter your phone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                GetBuilder<UpdateProfileController>(
                  builder: (controller) {
                    return TextFormField(
                      controller: _passwordTEController,
                      obscureText: controller.passwordShow,
                      decoration: InputDecoration(hintText: 'Password',
                        suffixIcon: TextButton(
                          onPressed: () {
                            controller.onShowTapped();
                          },
                          child: (controller.passwordShow == true)
                              ? const Text(
                            "Show",
                            style: TextStyle(color: Colors.grey),
                          )
                              : const Text(
                            "Show",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  }
                ),
                const SizedBox(height: 8),
                GetBuilder<UpdateProfileController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.inProgress == false,
                      replacement: const CenteredCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _updateProfile();
                          }
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    final bool result = await Get.find<UpdateProfileController>().updateProfile(
        _emailTEController.text.trim(),
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _phoneTEController.text.trim(),
        _passwordTEController.text,
        Get.find<PickImageController>().selectedImage);
    if (result) {
      showSnackBarMessage(context, 'Profile has been updated!');
      await authController.getUserData();
      setState(() {});

    } else {
      showSnackBarMessage(context, Get.find<UpdateProfileController>().errorMessage!);
    }
  }
  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            GetBuilder<PickImageController>(
              builder: (controller) {
                return Text(controller.selectedImage?.name ?? "Select photo");
              }
            ),
          ],
        ),
      ),
    );
  }

  // String _getSelectedPhotoTitle() {
  //   if (Get.find<PickImageController>().selectedImage != null) {
  //     return Get.find<PickImageController>().selectedImage!.name;
  //   }
  //   return "Select Photo";
  // }

  Future<void> _pickImage() async {
    final bool result = await Get.find<PickImageController>().pickImage();
    if (result) {
      showSnackBarMessage(context, "image successfully picked");
    }else {
      showSnackBarMessage(context, "something is wrong");
    }
  }
}
