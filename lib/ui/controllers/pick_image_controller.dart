import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PickImageController extends GetxController {
  XFile? _selectedImage;

  XFile? get selectedImage => _selectedImage;

  Future<bool> pickImage() async {
    bool isSuccess = false;
    ImagePicker _imagePicker = ImagePicker();
    XFile? pickedImage =
    await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      update();
      isSuccess = true;
    }

    return isSuccess;
  }
}