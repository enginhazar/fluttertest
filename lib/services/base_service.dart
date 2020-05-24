import 'dart:convert';
import 'dart:io';

import 'package:firebasetest/model/base/base_header.dart';
import 'package:firebasetest/model/base/base_model.dart';
import 'package:http/http.dart' as http;

class BaseService {
  static const FIREBASE_URL = "https://flutter-6d9c9.firebaseio.com/";
  static BaseService _instance = BaseService._privateConstructer();
  BaseService._privateConstructer();
  static BaseService get instance => _instance;

  Future get<T extends BaseModel>(T model, String child,
      {Header header}) async {
    final response = await http
        .get("$FIREBASE_URL/$child.json?${header.key}=${header.value}");

    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonModel = jsonDecode(response.body);
        if (jsonModel is Map) {
          if (jsonModel.length > 1) {
            List<T> list = [];
            jsonModel.forEach((key, value) {
              list.add(model.fromJson(value));
            });
            return list;
          }
          return model.fromJson(jsonModel);
        } else if (jsonModel is List) {
          return jsonModel.map((value) {
            return model.fromJson(value);
          }).toList();
        }
        return jsonModel;
        break;
      case HttpStatus.unauthorized:
        // refresh Tokem
        break;
      default:
        return Future.error(response.statusCode);
    }
  }
}
