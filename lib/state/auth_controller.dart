import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';
import 'package:place_mobile_flutter/main.dart';
import 'package:place_mobile_flutter/page/signup.dart';
import 'dart:convert';

import 'package:place_mobile_flutter/state/user_controller.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  FirebaseAuth authInstance = FirebaseAuth.instance;

  late Rx<User?> user = Rx<User?>(authInstance.currentUser);

  String? idToken;
  DateTime? expireDate;

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }
    return utf8.decode(base64Url.decode(output));
  }

  int _parseJwtExpiredDate(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    return payloadMap['exp'];
  }

  Future<bool> checkTokenValid() async {
    if (idToken == null || expireDate == null) {
      await getIdTokenStream(AuthController.to.user.value);
      return false;
    }
    if (expireDate!.isAfter(DateTime.now())) {
      await getIdTokenStream(AuthController.to.user.value);
      return false;
    }
    return true;
  }

  Future<void> getIdTokenStream(User? user) async {
    if (user == null) {
      idToken = null;
    } else {
      idToken = await user.getIdToken();
      if (idToken == null) {
        expireDate = null;
      } else {
        expireDate = DateTime.fromMillisecondsSinceEpoch(_parseJwtExpiredDate(idToken!) * 1000).subtract(const Duration(minutes: 10));
      }
      print("idToken: $idToken");
      print("expireDate: $expireDate");
    }
  }

  Stream<User?> getUser() async* {
    await for (final User? user in authInstance.userChanges()) {
      print("user: $user");
      await getIdTokenStream(user);
      if (user != null) {
        _loginSuccess(user);
      } else {
        Get.offAll(() => const MyApp());
      }
      yield user;
    }
  }

  @override
  void onReady() {
    super.onReady();
    Get.put(ProfileController());
    user.bindStream(getUser());
  }

  void _loginSuccess(User user) async {
    int? status = await ProfileController.to.getUserProfile();
    if (status != null) {
      if (status == 200) {
        Get.offAll(() => const MyApp());
      } else if (status == 400) {
        if (Get.currentRoute != "/SignUpPage") {
          Get.offAll(() => const MyApp());
          Get.to(() => SignUpPage());
        }
      }
    }
  }

  void registerEmail(BuildContext context, String email, password) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("회원가입 처리중"),
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 18,),
                Text("곧 완료됩니다.")
              ],
            ),
          );
        }
    );

    try {
      await authInstance.createUserWithEmailAndPassword(email: email, password: password);
    } catch(e) {
      Navigator.of(context, rootNavigator: true).pop();
      Get.showSnackbar(
        GetSnackBar(
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
          duration: const Duration(seconds: 2),
        )
      );
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.blue,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "회원가입 성공",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          "'${authInstance.currentUser!.email}'님, 환영합니다.",
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      )
    );

    // _loginSuccess();
  }

  void signInEmail(BuildContext context, String email, password) async {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("로그인 처리중"),
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 18,),
                Text("곧 완료됩니다.")
              ],
            ),
          );
        }
    );

    try {
      await authInstance.signInWithEmailAndPassword(email: email, password: password);
    } catch(e) {
      Navigator.of(context, rootNavigator: true).pop();
      Get.showSnackbar(
        GetSnackBar(
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
          duration: const Duration(seconds: 2),
        )
      );
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    Get.showSnackbar(
      GetSnackBar(
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
        duration: const Duration(seconds: 2),
      )
    );

    // _loginSuccess();
  }

  void signInFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      await authInstance.signInWithCredential(facebookAuthCredential);

      Get.showSnackbar(
        GetSnackBar(
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
          duration: const Duration(seconds: 2),
        )
      );

      // _loginSuccess();
    } catch(e) {
      Get.showSnackbar(
        GetSnackBar(
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
          duration: const Duration(seconds: 2),
        )
      );
      return;
    }
  }

  void signOut() async {
    try {
      await authInstance.signOut();
      Get.showSnackbar(
        const GetSnackBar(
          backgroundColor: Colors.blue,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            "로그아웃 완료",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            "로그아웃을 완료하였습니다",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
        )
      );
      Get.offAll(() => const MyApp());
    } catch(e) {
      Get.showSnackbar(
        GetSnackBar(
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
          duration: const Duration(seconds: 2),
        )
      );
    }
  }

  void resetPassword(BuildContext context, String email) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("이메일 전송중"),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 18,),
              Text("곧 완료됩니다.")
            ],
          ),
        );
      }
    );

    String dialogTitle = "";
    String dialogMessage = "";
    try {
      await authInstance.sendPasswordResetEmail(email: email);
      Navigator.of(context, rootNavigator: true).pop();
      dialogTitle = "이메일 전송 완료";
      dialogMessage = "전송된 비밀번호 재설정 링크로 비밀번호 재설정을 완료해주세요.";
    } catch(e) {
      Navigator.of(context, rootNavigator: true).pop();
      dialogTitle = "이메일 전송 실패";
      dialogMessage = "다시 요청해 주세요.";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: Text(dialogMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text("확인")
            )
          ],
        );
      }
    );
  }
}