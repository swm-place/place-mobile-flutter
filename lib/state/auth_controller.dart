import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:place_mobile_flutter/util/auth/auth_apple.dart';
import 'package:place_mobile_flutter/util/auth/auth_google.dart';
import 'package:place_mobile_flutter/util/auth/token_decoder.dart';
import 'package:place_mobile_flutter/widget/get_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';
import 'package:place_mobile_flutter/main.dart';
import 'package:place_mobile_flutter/page/account/signup.dart';
import 'dart:convert';

import 'package:place_mobile_flutter/state/user_controller.dart';
import 'package:place_mobile_flutter/util/apple_crypto.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  FirebaseAuth authInstance = FirebaseAuth.instance;

  late Rx<User?> user = Rx<User?>(authInstance.currentUser);

  late FirebaseAuthGoogle _authGoogle;
  late FirebaseAuthApple _authApple;

  final TokenDecoder _tokenDecoder = TokenDecoder();

  String? idToken;
  DateTime? expireDate;

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
        expireDate = DateTime.fromMillisecondsSinceEpoch(_tokenDecoder.parseJwtExpiredDate(idToken!) * 1000).subtract(const Duration(minutes: 10));
      }
      print("idToken: $idToken");
      print("expireDate: $expireDate");
    }
  }

  Future<void> _loginSuccess(User user) async {
    int? status = await ProfileController.to.getUserProfile(user);
    print('login success $status ${Get.currentRoute}');
    if (status != null) {
      if (status == 200) {
        print("login success ${Get.currentRoute}");
        if (Get.currentRoute != "/MyApp" && Get.currentRoute != '/') {
          print("move my page");
          Get.offAll(() => const MyApp());
        }
      } else if (status == 400) {
        if (Get.currentRoute != "/SignUpPage") {
          Get.offAll(() => const MyApp());
          Get.to(() => SignUpPage());
        }
      } else {
        Get.showSnackbar(
            ErrorGetSnackBar(
              title: "로그인 실패",
              message: "로그인 과정에서 오류가 발생했습니다. 다시 로그인 해주세요.",
            )
        );
        signOut();
      }
    }
  }

  Future<void> getUser(User? user) async {
    print("user: $user");
    this.user.value = user;
    await getIdTokenStream(user);
    if (user != null) {
      await _loginSuccess(user);
    } else {
      Get.offAll(() => const MyApp());
    }
  }

  @override
  void onReady() async {
    super.onReady();
    Get.put(ProfileController());
    if (user.value != null) {
      await getUser(user.value!);
    }
    // await authInstance.currentUser!;
    _authGoogle = FirebaseAuthGoogle(authInstance: authInstance);
    _authApple = FirebaseAuthApple(authInstance: authInstance);
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

    UserCredential userCredential;
    try {
      userCredential = await authInstance.createUserWithEmailAndPassword(email: email, password: password);
      await getUser(userCredential.user);
    } catch(e) {
      Navigator.of(context, rootNavigator: true).pop();
      Get.showSnackbar(
          ErrorGetSnackBar(
            title: "회원가입 실패",
            message: "회원가입 과정에서 오류가 발생했습니다. 회원가입을 다시 시도해주세요.",
          )
      );
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    Get.showSnackbar(
        SuccessGetSnackBar(
          title: "회원가입 성공",
          message: "'${userCredential.user!.email}'님, 환영합니다.",
        )
    );
  }

  Future<void> signInEmail(Map<String, dynamic> arguments) async {
    String email = arguments['email'] as String;
    String password = arguments['password'] as String;
    UserCredential userCredential;
    try {
      userCredential = await authInstance.signInWithEmailAndPassword(email: email, password: password);
      await getUser(userCredential.user);
    } on FirebaseAuthException catch(e) {
      String message = '';
      switch (e.code) {
        case 'invalid-email':
          message = '유효하지 않은 이메일입니다.';
          break;
        case 'user-disabled':
          message = '비활성화된 사용자입니다.';
          break;
        case 'user-not-found':
          message = '사용자를 찾을 수 없습니다.';
          break;
        case 'wrong-password':
          message = '비밀번호가 틀렸습니다.';
          break;
        default:
          message = '로그인 과정에서 오류가 발생했습니다. 다시 시도해주세요.';
          break;
      }
      Get.showSnackbar(
          ErrorGetSnackBar(
            title: "로그인 실패",
            message: message,
          )
      );
      return;
    } catch(e) {
      Get.showSnackbar(
          ErrorGetSnackBar(
            title: "로그인 실패",
            message: "로그인 과정에서 오류가 발생했습니다. 다시 시도해주세요.",
          )
      );
      return;
    }
    Get.showSnackbar(
        SuccessGetSnackBar(
          title: "로그인 성공",
          message: "'${userCredential.user!.email}'님, 환영합니다.",
        )
    );
  }

  void signInGoogle() async {
    User? user = await _authGoogle.signInGoogle();
    await getUser(user);
  }

  void linkGoogle() async {
    await _authGoogle.linkGoogle(user.value);
  }

  void unLinkGoogle() async {
    await _authGoogle.unLinkGoogle(user.value);
  }

  void signInApple() async {
    User? user = await _authApple.signInApple();
    await getUser(user);
  }

  void linkApple() async {
    await _authApple.linkApple(user.value);
  }

  void unLinkApple() async {
    await _authApple.unLinkApple(user.value);
  }

  Future<void> signOut() async {
    try {
      await authInstance.signOut();
      await getUser(null);
      Get.showSnackbar(
        SuccessGetSnackBar(
          title: "로그아웃 완료",
          message: "로그아웃을 완료하였습니다.",
        )
      );
      // Get.offAll(() => const MyApp());
    } catch(e) {
      Get.showSnackbar(
          ErrorGetSnackBar(
            title: "로그아웃 실패",
            message: "로그아웃에 실패했습니다. 다시 시도해주세요.",
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