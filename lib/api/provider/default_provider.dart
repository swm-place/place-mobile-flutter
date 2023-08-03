import 'package:place_mobile_flutter/state/auth_controller.dart';

class DefaultProvider {
  Map<String, String>? setHeader(String? token) {
    if (token != null) {
      return {"Authorization": "Bearer $token"};
    } else {
      return null;
    }
  }
}