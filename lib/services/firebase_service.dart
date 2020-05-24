import 'dart:convert';
import 'dart:io';

import 'package:firebasetest/core/helper/shared_manager.dart';
import 'package:firebasetest/model/base/base_header.dart';
import 'package:firebasetest/model/firebase_auth_error.dart';
import 'package:firebasetest/model/student.dart';
import 'package:firebasetest/model/user.dart';
import 'package:firebasetest/model/user_Login_Request.dart';
import 'package:firebasetest/services/base_service.dart';
import 'package:http/http.dart' as http;

class FirebaseServices {
  static const FIREBASE_URL = "https://flutter-6d9c9.firebaseio.com/";
  static const FIREBASE_AUTH_URL =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCCJkizPJ3lSyI9gbW4MEzrdh5azkiKP1A";
  BaseService service = BaseService.instance;

  Future postUser(UserLoginRequest userLoginRequest) async {
    var bodyJsonModel = json.encode(userLoginRequest.toJson());

    final response = await http.post(FIREBASE_AUTH_URL, body: bodyJsonModel);

    switch (response.statusCode) {
      case HttpStatus.ok:
        return true;
        break;
      default:
        var errorJson = json.decode(response.body);
        var error = FirebaseAuthError.fromJson(errorJson);
        return error;
    }
  }

  Future<List<User>> getUsers() async {
    final response = await http.get("$FIREBASE_URL/users.json");

    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonModel = jsonDecode(response.body);
        final userList = jsonModel
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList()
            .cast<User>();
        return userList;
        break;
      default:
        return Future.error(response.statusCode);
    }
  }

  Future<List<Student>> getStudent() async {
    final response = await service.get<Student>(Student(), "student",
        header: Header(
            key: "auth",
            value: SharedManager.instance.getString(SharedEnum.TOKEN)));
    return response;
    // final response = await http.get("$FIREBASE_URL/student.json");

    // switch (response.statusCode) {
    //   case HttpStatus.ok:
    //     final jsonModel = jsonDecode(response.body) as Map;
    //     final studentList = List<Student>();

    //     jsonModel.forEach((key, value) {
    //       Student student = Student.fromJson(value);
    //       student.key = key;
    //       studentList.add(student);
    //     });

    //     return studentList;
    //     break;
    //   default:
    //     return Future.error(response.statusCode);
    // }
  }
}
