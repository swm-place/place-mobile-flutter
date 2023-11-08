import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:place_mobile_flutter/api/provider/default_provider.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:place_mobile_flutter/util/async_dialog.dart';

class UserProvider extends DefaultProvider {
  ProgressDialogHelper _progressDialogHelper = ProgressDialogHelper();

  Future<Response?> getProfile(String uid) async {
    Uri uri = Uri.parse("$baseUrl/api/user/${uid}");
    Response response;
    try {
      response = await get(uri, headers: await setHeader(false));
    } catch(e) {
      return null;
    }
    return response;
  }

  Future<Map<String, dynamic>?> getTerm() async {
    Uri uri = Uri.parse("$baseUrl/api/user/terms");
    Response response;

    // _progressDialogHelper.showProgressDialog('약관 정보 가져오는중');
    print('open');
    try {
      response = await get(uri, headers: await setHeader(false));
      // _progressDialogHelper.hideProgressDialog();
      print('close1');
    } catch(e) {
      // _progressDialogHelper.hideProgressDialog();
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
    Uri uri = Uri.parse("$baseUrl/api/user/nickname?nickname=$nickname");
    Response response;

    _progressDialogHelper.showProgressDialog('닉네임 중복 검사중');
    try {
      response = await get(uri, headers: await setHeader(false));
      _progressDialogHelper.hideProgressDialog();
    } catch(e) {
      return null;
    }
    return response.statusCode;
  }

  Future<int?> createProfile(Map<String, dynamic> profileData) async {
    User? user = AuthController.to.user.value;
    if (user != null) {
      Uri uri = Uri.parse("$baseUrl/api/user");
      Map<String, String>? header = await setHeader(true);
      header!["Content-Type"] = 'application/json';

      Response response;
      try {
        response = await post(uri, headers: header, body: json.encode(profileData));
      } catch(e) {
        return null;
      }
      return response.statusCode;
    }
    return null;
  }

  Future<int?> patchProfile(Map<String, dynamic> profileData) async {
    User? user = AuthController.to.user.value;
    if (user != null) {
      Uri uri = Uri.parse("$baseUrl/api/user");
      Map<String, String>? header = await setHeader(true);
      header!["Content-Type"] = 'application/json';

      Response response;
      try {
        response = await patch(uri, headers: header, body: json.encode(profileData));
      } catch(e) {
        return null;
      }
      return response.statusCode;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getPlaceBookmark() async {
    if (AuthController.to.user.value == null) return null;

    Uri uri = Uri.parse("$baseUrl/api/user/${AuthController.to.user.value!.uid}/place-bookmark");
    Response response;
    try {
      response = await get(uri, headers: await setHeader(true));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<List<dynamic>?> getCourseBookmark() async {
    if (AuthController.to.user.value == null) return null;

    Uri uri = Uri.parse("$baseUrl/api/bookmarks/${AuthController.to.user.value!.uid}/course-bookmarks");
    Response response;
    try {
      response = await get(uri, headers: await setHeader(true));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<bool> postPlaceBookmark(String title) async {
    User? user = AuthController.to.user.value;
    if (user == null) return false;

    Uri uri = Uri.parse("$baseUrl/api/user/${user.uid}/place-bookmark");
    Map<String, String>? header = await setHeader(true);
    header!["Content-Type"] = 'application/json';

    Response response;
    try {
      response = await post(uri, headers: header, body: json.encode({
        'title': title
      }));
    } catch(e) {
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> postCourseBookmark(String title) async {
    User? user = AuthController.to.user.value;
    if (user == null) return false;

    Uri uri = Uri.parse("$baseUrl/api/bookmarks/${user.uid}/course-bookmarks");
    Map<String, String>? header = await setHeader(true);
    header!["Content-Type"] = 'application/json';

    Response response;
    try {
      response = await post(uri, headers: header, body: {
        'title': title
      });
    } catch(e) {
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
