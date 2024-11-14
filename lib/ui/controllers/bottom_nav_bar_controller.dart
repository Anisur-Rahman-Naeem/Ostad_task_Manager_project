import 'package:get/get.dart';

class BottomNavBarController extends GetxController {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void updateIndex (int index) {
    _selectedIndex = index;
    update();
  }
}