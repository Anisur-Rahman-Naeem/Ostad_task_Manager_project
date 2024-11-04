import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/user_model.dart';

class AuthController {
  static const String _accessTokenKey = 'access-token';
  static const String _userDataKey = 'user-data';
  static const String _verifiedEmailKey = 'verified-email';
  static const String _otpKey = 'otp';

  static String? accessToken;
  static UserModel? userData;
  static String? verifiedEmailData;
  static String? otpData;

  static Future<void> saveAccessToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    accessToken = token;
  }
  static Future<void> saveUserData(UserModel userModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userDataKey, jsonEncode(userModel.toJson()));
    userData = userModel;
  }
  static Future<void> saveotp(String email, String otp) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_otpKey, otp);
    otpData = otp;
  }
  static Future<void> saveverifiedemail(String verifiedEmail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_verifiedEmailKey, verifiedEmail);
    verifiedEmailData = verifiedEmail;
  }
  static Future<String?> getverifiedemail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? verifiedEmail = sharedPreferences.getString(_verifiedEmailKey);
    verifiedEmailData = verifiedEmail;
    return verifiedEmail;
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token =  sharedPreferences.getString(_accessTokenKey);
    accessToken = token;
    return token;
  }
  static Future<UserModel?> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userEncodedData =  sharedPreferences.getString(_userDataKey);
    if (userEncodedData == null) {
      return null;
    }
    UserModel userModel = UserModel.fromJson(jsonDecode(userEncodedData));
    userData = userModel;
    return userModel;
  }

  static bool isLoggedIn() {
    return accessToken !=null;
  }

  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    accessToken = null;
  }
}