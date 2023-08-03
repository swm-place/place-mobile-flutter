import 'package:place_mobile_flutter/state/auth_controller.dart';

class DefaultProvider {
  Map<String, String>? setHeader(bool authRequired) {
    if (authRequired) {
      return {"Authorization": "Bearer ${AuthController.to.idToken!}"};
    } else {
      return null;
    }
  }
}