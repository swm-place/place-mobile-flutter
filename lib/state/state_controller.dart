import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/main.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  FirebaseAuth authInstance = FirebaseAuth.instance;
  late Rx<User?> user = Rx<User?>(authInstance.currentUser);

  @override
  void onReady() {
    super.onReady();
    user.bindStream(authInstance.userChanges());
  }

  void registerEmail(String email, password) async {
    try {
      await authInstance.createUserWithEmailAndPassword(email: email, password: password);
    } catch(e) {
      print(e);
      Get.snackbar(
        "회원가입 실패",
        "회원가입에 문제가 발생했습니다",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "회원가입 실패",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void signInEmail(String email, password) async {
    try {
      await authInstance.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => const MyApp());
      Get.snackbar(
          "로그인 성공",
          "'${authInstance.currentUser!.email}'님, 환영합니다.",
          backgroundColor: Colors.blue,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "로그인 성공",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            "'${authInstance.currentUser!.email}'님, 환영합니다.",
            style: const TextStyle(color: Colors.white),
          ),
      );
      Get.offAll(() => const MyApp());
    } catch(e) {
      Get.snackbar(
        "로그인 실패",
        "로그인에 문제가 발생했습니다",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "로그인 실패",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void signInFacebook() {
    try {

    } catch(e) {

    }
  }

  void signOut() async {
    try {
      await authInstance.signOut();
      Get.snackbar(
        "로그아웃 완료",
        "",
        backgroundColor: Colors.blue,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "로그아웃 완료",
          style: TextStyle(color: Colors.white),
        ),
        messageText: const Text(
          "로그아웃을 완료하였습니다",
          style: TextStyle(color: Colors.white),
        ),
      );
      Get.offAll(() => const MyApp());
    } catch(e) {
      Get.snackbar(
        "로그아웃 실패",
        "로그아웃에 문제가 발생했습니다",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "로그아웃 실패",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }
}