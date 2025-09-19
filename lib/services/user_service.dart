import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:transit_seoul/models/common/user_login_model.dart';
import 'package:transit_seoul/services/global_service.dart';

class UserService extends GlobalService {
  UserService._privateConstructor();

  static final UserService _instance = UserService._privateConstructor();
  static UserService get instance => _instance;

  Future<UserLoginModel> getUserLogin(String accessToken) async {
    String endpoint = '/auth/google/callback';
    try {
      final http.Response response = await httpRequest(
        HttpMethod.post,
        apiUrl: ApiType.localServer,
        path: endpoint,
        header: {
          'Content-Type': 'application/json',
        },
        body: {'code': accessToken},
      );

      return UserLoginModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> fetchUserInfo(String accessToken) async {
    String endpoint = '/me';
    try {
      final http.Response response = await httpRequest(
        HttpMethod.get,
        apiUrl: ApiType.localServer,
        path: endpoint,
        header: {
          'Content-Type': 'application/json',
        },
      );

      debugPrint(response.body);

      if (response.statusCode != 200) {
        throw Exception();
      }

      return UserModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }
}
