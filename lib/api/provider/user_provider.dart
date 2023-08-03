import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:http/http.dart' as http;
import 'package:place_mobile_flutter/state/auth_controller.dart';

class UserProvider {
  String baseUrl = baseUrlDev;

  Future<http.Response?> getProfile(String token) async {
    User? user = AuthController.to.user.value;
    if (user != null) {
      Uri uri = Uri.parse("$baseUrl/v1/user/${user.uid}");
      final response = await http.get(uri, headers: {"Authorization": "Bearer ${AuthController.to.idToken!}"});
      return response;
    }
    return null;
  }

  Future<http.Response?> getTerm(String token) async {
    User? user = AuthController.to.user.value;
    if (user != null) {
      Uri uri = Uri.parse("$baseUrl/v1/user/term");
      final response = await http.get(uri, headers: {"Authorization": "Bearer ${AuthController.to.idToken!}"});
      return response;
    }
    return null;
  }
}
