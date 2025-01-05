import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/user_model.dart';

class AuthController extends GetxController {
  static const String _accessTokenKey = 'access-token';
  static const String _userDataKey = 'user-data';
  static const String _verifiedEmailKey = 'verified-email';
  static const String _otpKey = 'otp';

  static var accessToken = RxnString();
  var userData = Rxn<UserModel>();
  String? verifiedEmailData;
  String? otpData;

  Future<void> saveAccessToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    accessToken.value = token;
  }
  Future<void> saveotp(String email, String otp) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_otpKey, otp);
    otpData = otp;
  }


  Future<void> saveUserData(UserModel userModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userDataKey, jsonEncode(userModel.toJson()));
    userData.value = userModel;
  }

  Future<void> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    accessToken.value = sharedPreferences.getString(_accessTokenKey);
  }
  Future<void> saveverifiedemail(String verifiedEmail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_verifiedEmailKey, verifiedEmail);
    verifiedEmailData = verifiedEmail;
  }

  bool isLoggedIn() {
    return accessToken.value!=null;
  }

  Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userEncodedData = sharedPreferences.getString(_userDataKey);
    if (userEncodedData != null) {
      userData.value = UserModel.fromJson(jsonDecode(userEncodedData));
    }
  }

  Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    accessToken.value = null;
    userData.value = null;
  }
}