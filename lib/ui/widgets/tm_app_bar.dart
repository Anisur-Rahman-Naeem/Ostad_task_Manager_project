import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/profile_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isProfileScreenOpen;

  TMAppBar({super.key, this.isProfileScreenOpen = false});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes =
        base64Decode(authController.userData.value?.photo.toString() ?? '');

    return GestureDetector(
      onTap: () {
        print(authController.userData.value?.photo.toString() ?? "No data found");
        if (isProfileScreenOpen) return;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()));
      },
      child: Obx(() => AppBar(
            backgroundColor: AppColors.themeColor,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: imageBytes.isNotEmpty
                      ? Image.memory(
                          imageBytes,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        )
                      : Image.asset(
                          'assets/images/blank-profile-picture.png',
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authController.userData.value?.firstName ?? " ",
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        authController.userData.value?.email ?? '',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await authController.clearUserData();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                        (_) => false,
                      );
                    },
                    icon: const Icon(Icons.logout))
              ],
            ),
          )),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
