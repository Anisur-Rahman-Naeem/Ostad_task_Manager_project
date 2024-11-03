// import 'package:task_manager/data/models/user_model.dart';
//
// class LoginModel {
//   String? status;
//   List<UserModel>? data;
//   String? token;
//
//   LoginModel({this.status, this.data, this.token});
//
//   LoginModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['data'] != null) {
//       // Ensures data is parsed as a list of UserModel
//       if (json['data'] is List) {
//         // Parse directly if it's already a list
//         data = (json['data'] as List)
//             .map((userJson) => UserModel.fromJson(userJson))
//             .toList();
//       } else if (json['data'] is Map<String, dynamic>) {
//         // Wrap as a single-item list if it's a single user object
//         data = [UserModel.fromJson(json['data'])];
//       }
//     }
//     token = json['token'];
//   }
// }

import 'package:task_manager/data/models/user_model.dart';

class LoginModel {
  String? status;
  List<UserModel>? data;
  String? token;

  LoginModel({this.status, this.data, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [UserModel.fromJson(json['data'])];
      // data = <UserModel>[];
      // json['data'].forEach((v) {
      //   data!.add(UserModel.fromJson(v));
      // });
    }
    token = json['token'];
  }
}