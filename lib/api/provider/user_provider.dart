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
      response = await get(uri, headers: await setHeader(AuthController.to.user.value != null));
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

  Future<Map<String, dynamic>?> getPlaceBookmark(int page, int size, dynamic? placeId) async {
    if (AuthController.to.user.value == null) return null;

    Uri uri = Uri.parse("$baseUrl/api/user/${AuthController.to.user.value!.uid}/place-bookmark?page=$page&size=$size${placeId != null ? '&placeId=$placeId' : ''}");
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

  Future<List<dynamic>?> getCourseBookmark(int page, int size, dynamic? courseId) async {
    if (AuthController.to.user.value == null) return null;

    Uri uri = Uri.parse("$baseUrl/api/bookmarks/${AuthController.to.user.value!.uid}/course-bookmarks?page=$page&size=$size${courseId != null ? '&courseId=$courseId' : ''}");
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

  Future<bool> deletePlaceBookmark(dynamic bookmarkId) async {
    User? user = AuthController.to.user.value;
    if (user == null) return false;

    Uri uri = Uri.parse("$baseUrl/api/user/${user.uid}/place-bookmark/$bookmarkId");
    Map<String, String>? header = await setHeader(true);

    Response response;
    try {
      response = await delete(uri, headers: header);
    } catch(e) {
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteCourseBookmark(dynamic bookmarkId) async {
    User? user = AuthController.to.user.value;
    if (user == null) return false;

    Uri uri = Uri.parse("$baseUrl/api/bookmarks/${user.uid}/course-bookmarks/$bookmarkId");
    Map<String, String>? header = await setHeader(true);

    Response response;
    try {
      response = await delete(uri, headers: header);
    } catch(e) {
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> patchPlaceBookmark(dynamic bookmarkId, String title) async {
    User? user = AuthController.to.user.value;
    if (user == null) return false;

    Uri uri = Uri.parse("$baseUrl/api/user/${user.uid}/place-bookmark/$bookmarkId");
    Map<String, String>? header = await setHeader(true);
    header!["Content-Type"] = 'application/json';

    Response response;
    try {
      response = await patch(uri, headers: header, body: json.encode({
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

  Future<bool> patchCourseBookmark(dynamic bookmarkId, String title) async {
    User? user = AuthController.to.user.value;
    if (user == null) return false;

    Uri uri = Uri.parse("$baseUrl/api/bookmarks/${user.uid}/course-bookmarks/$bookmarkId");
    Map<String, String>? header = await setHeader(true);
    header!["Content-Type"] = 'application/json';

    Response response;
    try {
      response = await patch(uri, headers: header, body: json.encode({
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

  Future<List<dynamic>?> getUserTagPreferences() async {
    if (AuthController.to.user.value == null) return null;

    Uri uri = Uri.parse("$baseUrl/api-recommender/user_preference/hashtags");
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

  Future<bool> putUserTagPreferences(dynamic putData) async {
    if (AuthController.to.user.value == null) return false;

    Uri uri = Uri.parse("$baseUrl/api-recommender/user_preference/hashtags");
    Map<String, String>? header = await setHeader(true);
    header!["Content-Type"] = 'application/json';

    Response response;
    try {
      response = await put(uri, headers: header, body: json.encode(putData));
    } catch(e) {
      return false;
    }

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> postPlaceInBookmark(dynamic bookmarkId, dynamic placeId) async {
    User? user = AuthController.to.user.value;
    if (user == null) return false;

    Uri uri = Uri.parse("$baseUrl/api/place-bookmark/$bookmarkId");
    Map<String, String>? header = await setHeader(true);
    header!["Content-Type"] = 'application/json';

    Response response;
    try {
      response = await post(uri, headers: header, body: json.encode({
        'placeId': placeId
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

  Future<bool> deletePlaceInBookmark(dynamic bookmarkId, dynamic placeId) async {
    User? user = AuthController.to.user.value;
    if (user == null) return false;

    Uri uri = Uri.parse("$baseUrl/api/user/${user.uid}/place-bookmark/$bookmarkId/place/$placeId");
    Map<String, String>? header = await setHeader(true);

    Response response;
    try {
      response = await delete(uri, headers: header);
    } catch(e) {
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> postCourseInBookmark(dynamic bookmarkId, dynamic courseId) async {
    User? user = AuthController.to.user.value;
    if (user == null) return false;

    Uri uri = Uri.parse("$baseUrl/api/bookmarks/${user.uid}/course-bookmarks/$bookmarkId/courses/$courseId");
    Map<String, String>? header = await setHeader(true);
    header!["Content-Type"] = 'application/json';

    Response response;
    try {
      response = await post(uri, headers: header);
    } catch(e) {
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteCourseInBookmark(dynamic bookmarkId, dynamic courseId) async {
    User? user = AuthController.to.user.value;
    if (user == null) return false;

    Uri uri = Uri.parse("$baseUrl/api/bookmarks/${user.uid}/course-bookmarks/$bookmarkId/courses/$courseId");
    Map<String, String>? header = await setHeader(true);

    Response response;
    try {
      response = await delete(uri, headers: header);
    } catch(e) {
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<dynamic>?> getPlaceInBookmark(int page, int size, dynamic bookmarkId) async {
    if (AuthController.to.user.value == null) return null;

    Uri uri = Uri.parse("$baseUrl/api/user/${AuthController.to.user.value!.uid}/place-bookmark/$bookmarkId?page=$page&size=$size");
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

  Future<List<dynamic>?> getCourseInBookmark(int page, int size, dynamic? bookmarkId) async {
    if (AuthController.to.user.value == null) return null;

    Uri uri = Uri.parse("$baseUrl/api/bookmarks/${AuthController.to.user.value!.uid}/course-bookmarks/$bookmarkId?course_page=$page&course_size=$size");
    Response response;
    try {
      response = await get(uri, headers: await setHeader(true));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes))['courses'];
    } else {
      return null;
    }
  }

  Future<List<dynamic>?> getLogPlace(int page, int size) async {
    if (AuthController.to.user.value == null) return null;

    Uri uri = Uri.parse("$baseUrl/api-recommender/logs/${AuthController.to.user.value!.uid}/place-fetch?size=$size&offset=$page");
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
}
