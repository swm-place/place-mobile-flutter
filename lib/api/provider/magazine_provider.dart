import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:place_mobile_flutter/api/provider/default_provider.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';

class MagazineProvider extends DefaultProvider {
  Future<List<dynamic>?> getMagazineList() async {
    Uri uri = Uri.parse("$baseUrl/api/course-magazines");
    Response response;

    try {
      response = await get(uri, headers: await setHeader(false));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMagazine(dynamic id) async {
    Uri uri = Uri.parse("$baseUrl/api/course-magazines/$id");
    Response response;

    try {
      response = await get(uri, headers: await setHeader(false));
    } catch(e) {
      return null;
    }

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future<bool> postMagazineLike(dynamic courseMagazineId) async {
    String? idToken = AuthController.to.idToken;
    User? user = AuthController.to.user.value;

    if (idToken == null || user == null) {
      return false;
    }

    Uri uri = Uri.parse("$baseUrl/api/favorites/${user.uid}/magazines/$courseMagazineId");
    Map<String, String>? header = await setHeader(true);

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

  Future<bool> deleteMagazineLike(dynamic courseMagazineId) async {
    String? idToken = AuthController.to.idToken;
    User? user = AuthController.to.user.value;

    if (idToken == null || user == null) {
      return false;
    }

    Uri uri = Uri.parse("$baseUrl/api/favorites/${user.uid}/magazines/$courseMagazineId");
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
}