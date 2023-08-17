import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:place_mobile_flutter/util/async_dialog.dart';
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
import 'package:place_mobile_flutter/util/auth/apple_crypto.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  FirebaseAuth authInstance = FirebaseAuth.instance;

  late Rx<User?> user = Rx<User?>(authInstance.currentUser);

  late FirebaseAuthGoogle _authGoogle;
  late FirebaseAuthApple _authApple;

  final TokenDecoder _tokenDecoder = TokenDecoder();

  String? idToken;
  DateTime? expireDate;
  
  final ProgressDialogHelper _progressDialogHelper = ProgressDialogHelper();

  Future<bool> checkTokenValid() async {
    if (idToken == null || expireDate == null) {
      await getIdTokenStream();
      return false;
    }
    if (expireDate!.isAfter(DateTime.now())) {
      await getIdTokenStream();
      return false;
    }
    return true;
  }

  Future<void> getIdTokenStream() async {
    if (user.value == null) {
      idToken = null;
    } else {
      _progressDialogHelper.showProgressDialog('인증 정보 가져오는중');
      idToken = await user.value!.getIdToken();
      _progressDialogHelper.hideProgressDialog();
      if (idToken == null) {
        expireDate = null;
      } else {
        expireDate = DateTime.fromMillisecondsSinceEpoch(_tokenDecoder.parseJwtExpiredDate(idToken!) * 1000).subtract(const Duration(minutes: 10));
      }
      print("idToken: $idToken");
      print("expireDate: $expireDate");
    }
  }

  Future<void> _loginSuccess() async {
    _progressDialogHelper.showProgressDialog('유저 정보 가져오는중');
    int? status = await ProfileController.to.getUserProfile(user.value!.uid);
    _progressDialogHelper.hideProgressDialog();
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
          print('sign up');
          Get.to(() => SignUpPage());
        }
      } else {
        Get.showSnackbar(
            ErrorGetSnackBar(
              title: "서버 오류",
              message: "통신 과정에서 오류가 발생했습니다. 다시 시도해주세요.",
            )
        );
        signOut();
      }
    } else {
      Get.showSnackbar(
          ErrorGetSnackBar(
            title: "서버 오류",
            message: "통신 과정에서 오류가 발생했습니다. 다시 시도해주세요.",
          )
      );
    }
  }

  Future<void> getUser(User? user) async {
    print("user: $user");
    this.user.value = user;
    await getIdTokenStream();
    if (user != null) {
      await _loginSuccess();
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

  Future<bool> registerEmail(String email, password) async {
    _progressDialogHelper.showProgressDialog('회원가입 처리중');

    UserCredential userCredential;
    try {
      userCredential = await authInstance.createUserWithEmailAndPassword(email: email, password: password);
      _progressDialogHelper.hideProgressDialog();
      await getUser(userCredential.user);
    } on FirebaseAuthException catch(e) {
      _progressDialogHelper.hideProgressDialog();
      String message;
      switch(e.code) {
        case 'email-already-in-use':
          message = '이미 사용중인 이메일입니다. 다른 이메일을 입력해주세요.';
          break;
        case 'invalid-email':
          message = '유효하지 않은 이메일입니다.';
          break;
        case 'weak-password':
          message = '비밀번호가 너무 약합니다. 더 복잡한 비밀번호를 입력해주세요.';
          break;
        default:
          message = '계정 생성 과정에서 오류가 발생했습니다. 계정 생성을 다시 시도해주세요.';
          break;
      }
      Get.showSnackbar(
          ErrorGetSnackBar(
            title: "계정 생성 실패",
            message: message,
            showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_LONG,
          )
      );
      return false;
    } catch(e) {
      _progressDialogHelper.hideProgressDialog();
      Get.showSnackbar(
          ErrorGetSnackBar(
            title: "계정 생성 실패",
            message: "계정 생성 과정에서 오류가 발생했습니다. 계정 생성을 다시 시도해주세요.",
          )
      );
      return false;
    }
    // Get.showSnackbar(
    //     SuccessGetSnackBar(
    //       title: "계정 생성 성공",
    //       message: "'${userCredential.user!.email}'님, 환영합니다.",
    //     )
    // );
    return true;
  }

  Future<void> signInEmail(String email, String password) async {
    _progressDialogHelper.showProgressDialog('로그인 중');
    
    UserCredential userCredential;
    try {
      userCredential = await authInstance.signInWithEmailAndPassword(email: email, password: password);
      _progressDialogHelper.hideProgressDialog();
      await getUser(userCredential.user);
    } on FirebaseAuthException catch(e) {
      _progressDialogHelper.hideProgressDialog();
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
      _progressDialogHelper.hideProgressDialog();
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
    if (user != null) {
      await getUser(user);
      Get.showSnackbar(
          SuccessGetSnackBar(
              title: "로그인 성공",
              message: "'${user.email}'님, 환영합니다."
          )
      );
    }
  }

  void linkGoogle() async {
    await _authGoogle.linkGoogle(user.value);
  }

  void unLinkGoogle() async {
    await _authGoogle.unLinkGoogle(user.value);
  }

  void signInApple() async {
    User? user = await _authApple.signInApple();
    if (user != null) {
      await getUser(user);
      Get.showSnackbar(
          SuccessGetSnackBar(
              title: "로그인 성공",
              message: "'${user.email}'님, 환영합니다."
          )
      );
    }
  }

  void linkApple() async {
    await _authApple.linkApple(user.value);
  }

  void unLinkApple() async {
    await _authApple.unLinkApple(user.value);
  }

  Future<void> signOut() async {
    _progressDialogHelper.showProgressDialog('로그아웃중');
    try {
      await authInstance.signOut();
      _progressDialogHelper.hideProgressDialog();
      await getUser(null);
    } catch(e) {
      _progressDialogHelper.hideProgressDialog();
      Get.showSnackbar(
          ErrorGetSnackBar(
            title: "로그아웃 실패",
            message: "로그아웃에 실패했습니다. 다시 시도해주세요.",
          )
      );
      return;
    }
    Get.showSnackbar(
        SuccessGetSnackBar(
          title: "로그아웃 완료",
          message: "로그아웃을 완료하였습니다.",
        )
    );
  }

  void resetPassword(String email) async {
    _progressDialogHelper.showProgressDialog('이메일 전송중');

    String dialogTitle = "";
    String dialogMessage = "";
    try {
      await authInstance.sendPasswordResetEmail(email: email);
      _progressDialogHelper.hideProgressDialog();
      dialogTitle = "이메일 전송 완료";
      dialogMessage = "전송된 비밀번호 재설정 링크로 비밀번호 재설정을 완료해주세요.";
    } on FirebaseAuthException catch(e) {
      _progressDialogHelper.hideProgressDialog();
      switch(e.code) {
        case 'invalid-email':
          dialogTitle = "이메일 전송 실패";
          dialogMessage = "유효하지 않은 이메일입니다.";
          break;
        case 'user-not-found':
          dialogTitle = "이메일 전송 실패";
          dialogMessage = "유저를 찾을 수 없습니다.";
          break;
        default:
          print(e.code);
          dialogTitle = "이메일 전송 실패";
          dialogMessage = "다시 요청해 주세요.";
          break;
      }
    } catch(e) {
      _progressDialogHelper.hideProgressDialog();
      dialogTitle = "이메일 전송 실패";
      dialogMessage = "다시 요청해 주세요.";
    }

    Get.dialog(
      AlertDialog(
        title: Text(dialogTitle),
        content: Text(dialogMessage),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("확인")
          )
        ],
      )
    );
  }
}