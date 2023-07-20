import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  late Rx<User?> _user;
  FirebaseAuth authInstance = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();

    _user = Rx<User?>(authInstance.currentUser);
    _user.bindStream(authInstance.userChanges());
  }

  void registerEmail(String email, password) {

  }

  void signInEmail(String email, password) {

  }
}