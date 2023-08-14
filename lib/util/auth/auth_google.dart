import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:place_mobile_flutter/widget/get_snackbar.dart';

class FirebaseAuthGoogle {
  FirebaseAuthGoogle({
    required this.authInstance,
  });

  FirebaseAuth authInstance;

  Future<User?> signInGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await authInstance.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        print(user.providerData);
        if (user.providerData.length == 1) {
          await user.delete();
          Get.showSnackbar(
            WarnGetSnackBar(
              title: "로그인 실패",
              message: "해당 SNS 계정과 연결된 OURS 계정이 없습니다. 로그인 이나 회원가입 후 계정을 연결해주세요.",
              showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_LONG,
            )
          );
          return null;
        } else {
          Get.showSnackbar(
            SuccessGetSnackBar(
              title: "로그인 성공",
              message: "'${user.email}'님, 환영합니다."
            )
          );
          return user;
        }
      } else {
        Get.showSnackbar(
          ErrorGetSnackBar(
            title: "로그인 실패",
            message: '로그인 과정에서 오류가 발생했습니다. 다시 시도해주세요.',
            showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_LONG,
          )
        );
        return null;
      }
    } catch(e) {
      Get.showSnackbar(
        ErrorGetSnackBar(
          title: "로그인 실패",
          message: e.toString()
        )
      );
      return null;
    }
  }

  void linkGoogle(User? user) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      if (user != null) {
        try {
          await user!.linkWithCredential(credential);
        } on FirebaseAuthException catch(e) {
          String message;
          switch (e.code) {
            case "provider-already-linked":
              message = '이미 다른 구글 계정과 연결되어 있습니다.';
              break;
            case "invalid-credential":
              message = '유효하지 않은 계정입니다.';
              break;
            case "credential-already-in-use":
              message = '이미 다른 계정과 연결되어 있습니다.';
              break;
            default:
              message = '연결 과정에서 오류가 발생했습니다. 다시 시도해주세요.';
              break;
          }
          Get.showSnackbar(
              ErrorGetSnackBar(
                title: "연결 실패",
                message: message,
                showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_LONG,
              )
          );
        }

        Get.showSnackbar(
          SuccessGetSnackBar(
            title: "연결 성공",
            message: "${googleUser!.email} 계정과 연결했습니다. 이제 해당 구글 계정으로 로그인이 가능합니다.",
            showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_LONG,
          )
        );
      } else {
        Get.showSnackbar(
            WarnGetSnackBar(
              title: "연결 실패",
              message: "구글 계정과 연결할 계정에 로그인 되어있지 않습니다. 로그인 후 다시 시도해주세요.",
              showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_LONG,
            )
        );
      }
    } catch(e) {
      Get.showSnackbar(
          ErrorGetSnackBar(
            title: "연결 실패",
            message: e.toString(),
            showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_LONG,
          )
      );
    }
  }

  void unLinkGoogle(User? user) async {
    try {
      if (user != null) {
        try {
          await user.unlink('google.com');
          Get.showSnackbar(
              SuccessGetSnackBar(
                title: "연결 해제 성공",
                message: "구글 계정과 연결을 해제했습니다.",
              )
          );
        } on FirebaseAuthException catch(e) {
          String message;
          switch (e.code) {
            case 'no-such-provider':
              message = '연결된 구글 계정이 없습니다.';
              break;
            default:
              message = '연결 해제 과정에서 오류가 발생했습니다. 다시 시도해주세요.';
              break;
          }
          Get.showSnackbar(
              WarnGetSnackBar(
                title: "연결 해제 실패",
                message: message,
              )
          );
        }
      } else {
        Get.showSnackbar(
            WarnGetSnackBar(
              title: "연결 해제 실패",
              message: "연결을 해제할 계정에 로그인 되어있지 않습니다. 로그인 후 다시 시도해주세요.",
              showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_LONG,
            )
        );
      }
    } catch(e) {
      Get.showSnackbar(
          ErrorGetSnackBar(
            title: "연결 해제 실페",
            message: e.toString(),
          )
      );
    }
  }
}