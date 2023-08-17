import 'package:place_mobile_flutter/api/api_const.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';

class DefaultProvider {
  String baseUrl = baseUrlDev;

  Map<String, String>? setHeader(String? token) {
    if (token != null) {
      return {"Authorization": "Bearer $token"};
    } else {
      return null;
    }
  }
}