import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/bottom_nav_bar_controller.dart';
import 'package:task_manager/ui/screens/cancelled_task_screen.dart';
import 'package:task_manager/ui/screens/completed_task_screen.dart';
import 'package:task_manager/ui/screens/new_task_screen.dart';
import 'package:task_manager/ui/screens/progress_task_screen.dart';

import '../widgets/tm_app_bar.dart';

class MainBottomNavBarScreen extends StatefulWidget {
  static const String name = '/home';

  const MainBottomNavBarScreen({super.key});

  @override
  State<MainBottomNavBarScreen> createState() => _MainBottomNavBarScreenState();
}

class _MainBottomNavBarScreenState extends State<MainBottomNavBarScreen> {
  int _selectedIndex = 0;
  List<Widget> _screens = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
    ProgressTaskScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: GetBuilder<BottomNavBarController>(
        builder: (controller) {
          return _screens[controller.selectedIndex];
        }
      ),
      bottomNavigationBar: GetBuilder<BottomNavBarController>(
        builder: (controller) {
          return NavigationBar(
            selectedIndex: controller.selectedIndex,
            onDestinationSelected: (int index) {
              controller.updateIndex(index);
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.new_label), label: 'New'),
              NavigationDestination(
                  icon: Icon(Icons.check_box), label: 'Completed'),
              NavigationDestination(icon: Icon(Icons.close), label: 'Cancelled'),
              NavigationDestination(
                  icon: Icon(Icons.update_outlined), label: 'Progress'),
            ],
          );
        }
      ),
    );
  }
}
