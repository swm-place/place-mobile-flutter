import 'package:firebase_auth/firebase_auth.dart';
import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';

class DefaultProvider {
  String baseUrl = baseUrlDev;

  Future<Map<String, String>?> setHeader(bool tokenRequired) async {
    if (tokenRequired) {
      String? idToken = AuthController.to.idToken;

      if (!await AuthController.to.checkTokenValid()) idToken = AuthController.to.idToken;

      return {"Authorization": "Bearer $idToken"};
    } else {
      return null;
    }
  }
}