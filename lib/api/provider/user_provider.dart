import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:http/http.dart' as http;
import 'package:place_mobile_flutter/api/provider/default_provider.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';

class UserProvider extends DefaultProvider {
  String baseUrl = baseUrlDev;

  Future<http.Response?> getProfile(String token) async {
    User? user = AuthController.to.user.value;
    if (user != null) {
      Uri uri = Uri.parse("$baseUrl/v1/user/${user.uid}");
      final response = await http.get(uri, headers: setHeader(token));
      return response;
    }
    return null;
  }

  Future<http.Response?> getTerm(String token) async {
    User? user = AuthController.to.user.value;
    if (user != null) {
      Uri uri = Uri.parse("$baseUrl/v1/user/terms");
      final response = await http.get(uri, headers: setHeader(token));
      return response;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getTermDialog(String token, BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("회원가입 정보 가져오는중..."),
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 18,),
                Text("곧 완료됩니다.")
              ],
            ),
          );
        }
    );

    http.Response? result = await getTerm(token);
    Navigator.of(context, rootNavigator: true).pop();

    if (result == null) {
      return null;
    } else {
      return jsonDecode(utf8.decode(result.bodyBytes));
    }
  }
}
