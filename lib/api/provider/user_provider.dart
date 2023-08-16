import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:http/http.dart' as http;
import 'package:place_mobile_flutter/api/provider/default_provider.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:place_mobile_flutter/util/async_dialog.dart';

class UserProvider extends DefaultProvider {
  String baseUrl = baseUrlDev;

  ProgressDialogHelper _progressDialogHelper = ProgressDialogHelper();

  Future<http.Response?> getProfile(String uid) async {
    Uri uri = Uri.parse("$baseUrl/user/${uid}");
    http.Response response;
    try {
      response = await http.get(uri, headers: setHeader(null));
    } catch(e) {
      return null;
    }
    return response;
  }

  Future<Map<String, dynamic>?> getTerm() async {
    Uri uri = Uri.parse("$baseUrl/user/terms");
    http.Response response;

    _progressDialogHelper.showProgressDialog('약관 정보 가져오는중');
    print('open');
    try {
      response = await http.get(uri, headers: setHeader(null));
      _progressDialogHelper.hideProgressDialog();
      print('close1');
    } catch(e) {
      _progressDialogHelper.hideProgressDialog();
      print('close2');
      return null;
    }
    print(response.statusCode);
    switch(response.statusCode) {
      case 200:
        return jsonDecode(utf8.decode(response.bodyBytes));
      default:
        return null;
    }
  }

  Future<int?> checkNickname(String nickname) async {
    User? user = AuthController.to.user.value;
    if (user != null) {
      Uri uri = Uri.parse("$baseUrl/user/nickname?nickname=$nickname");
      http.Response response;

      _progressDialogHelper.showProgressDialog('닉네임 중복 검사중');
      try {
        response = await http.get(uri, headers: setHeader(null));
        _progressDialogHelper.hideProgressDialog();
      } catch(e) {
        return null;
      }
      return response.statusCode;
    }
    return null;
  }

  Future<int?> createProfile(Map<String, dynamic> profileData, String token) async {
    User? user = AuthController.to.user.value;
    if (user != null) {
      Uri uri = Uri.parse("$baseUrl/user");
      Map<String, String>? header = setHeader(token);
      header!["Content-Type"] = 'application/json';

      http.Response response;
      try {
        response = await http.post(uri, headers: header, body: json.encode(profileData));
      } catch(e) {
        return null;
      }
      return response.statusCode;
    }
    return null;
  }
}
