import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:place_mobile_flutter/util/async_dialog.dart';
import 'package:place_mobile_flutter/widget/get_snackbar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:get/get.dart';

class FirebaseAuthSocial {
  FirebaseAuthSocial({
    required this.authInstance,
  });

  final ProgressDialogHelper _progressDialogHelper = ProgressDialogHelper();

  FirebaseAuth authInstance;

  Future<User?> login(OAuthCredential credential) async {
    _progressDialogHelper.showProgressDialog('로그인중');

    UserCredential userCredential;
    try {
      userCredential = await authInstance.signInWithCredential(credential);
    } catch(e) {
      _progressDialogHelper.hideProgressDialog();
      Get.showSnackbar(
          ErrorGetSnackBar(
              title: "로그인 실패",
              message: e.toString()
          )
      );
      return null;
    }

    User? user = userCredential.user;
    if (user != null) {
      print(user.providerData);
      if (user.providerData.length == 1) {
        await user.delete();
        _progressDialogHelper.hideProgressDialog();
        Get.showSnackbar(
            WarnGetSnackBar(
              title: "로그인 실패",
              message: "해당 SNS 계정과 연결된 OURS 계정이 없습니다. 로그인 이나 회원가입 후 계정을 연결해주세요.",
              showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_LONG,
            )
        );
        return null;
      } else {
        _progressDialogHelper.hideProgressDialog();
        // Get.showSnackbar(
        //     SuccessGetSnackBar(
        //         title: "로그인 성공",
        //         message: "'${user.email}'님, 환영합니다."
        //     )
        // );
        return user;
      }
    } else {
      _progressDialogHelper.hideProgressDialog();
      Get.showSnackbar(
          ErrorGetSnackBar(
            title: "로그인 실패",
            message: '로그인 과정에서 오류가 발생했습니다. 다시 시도해주세요.',
            showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_LONG,
          )
      );
      return null;
    }
  }

  Future<void> link(User? user, OAuthCredential credential, String providerId) async {
    try {
      if (user != null) {
        try {
          _progressDialogHelper.showProgressDialog('SNS 계정 등록중');
          await user!.linkWithCredential(credential);
          _progressDialogHelper.hideProgressDialog();
        } on FirebaseAuthException catch(e) {
          _progressDialogHelper.hideProgressDialog();
          String message;
          switch (e.code) {
            case "provider-already-linked":
              message = '이미 같은 유형의 SNS 계정과 연결되어 있습니다.';
              break;
            case "invalid-credential":
              message = '유효하지 않은 계정입니다.';
              break;
            case "credential-already-in-use":
              message = '해당 SNS 계정은 이미 다른 계정과 연결되어 있습니다.';
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
          return;
        }

        Get.showSnackbar(
            SuccessGetSnackBar(
              title: "연결 성공",
              message: "SNS 계정과 연결했습니다. 이제 '${user.email}' 계정에 해당 SNS 계정으로 로그인이 가능합니다.",
              showDuration: CustomGetSnackBar.GET_SNACKBAR_DURATION_LONG,
            )
        );
      } else {
        Get.showSnackbar(
            WarnGetSnackBar(
              title: "연결 실패",
              message: "SNS 계정과 연결할 계정에 로그인 되어있지 않습니다. 로그인 후 다시 시도해주세요.",
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
    AuthController.to.addProviderId(providerId);
  }

  Future<void> unLink(User? user, String providerId) async {
    try {
      if (user != null) {
        try {
          _progressDialogHelper.showProgressDialog('SNS 계정 연결 해제중');
          await user.unlink(providerId);
          _progressDialogHelper.hideProgressDialog();
        } on FirebaseAuthException catch(e) {
          _progressDialogHelper.hideProgressDialog();
          String message;
          switch (e.code) {
            case 'no-such-provider':
              message = '연결된 SNS 계정이 없습니다.';
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
          return;
        }
        Get.showSnackbar(
            SuccessGetSnackBar(
              title: "연결 해제 성공",
              message: "SNS 계정과 연결을 해제했습니다.",
            )
        );
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
    AuthController.to.removeProviderId(providerId);
  }
}