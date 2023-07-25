import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  UserProvider _userProvider = UserProvider();

  RxnString nickname = RxnString();

  Future<int?> getUserProfile() async {
    String? idToken = AuthController.to.idToken;
    if (idToken != null) {
      http.Response? response = await _userProvider.getProfile(idToken);
      if (response != null) {
        if (response.statusCode == 200) {

        } else if (response.statusCode == 400) {

        } else {

        }
        return response.statusCode;
      }
    }
    return null;
  }
}