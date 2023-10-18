import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';
import 'package:place_mobile_flutter/main.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:place_mobile_flutter/util/async_dialog.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  final UserProvider _userProvider = UserProvider();

  RxnString nickname = RxnString();
  RxnString email = RxnString();
  RxnString phoneNumber = RxnString();
  RxnInt gender = RxnInt();
  RxnString birthday = RxnString();

  ProgressDialogHelper _progressDialogHelper = ProgressDialogHelper();

  Future<int?> getUserProfile(String uid) async {
    http.Response? response = await _userProvider.getProfile(uid);
    // print('getUsaerProfile: $response');
    if (response != null) {
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        email(data['result']['email']);
        nickname(data['result']['nickname']);
        phoneNumber(data['result']['phoneNumber']);
        gender(data['result']['gender']);
        birthday(data['result']['birthday']);
      }
      return response.statusCode;
    }
    return null;
  }

  void makeUserProfile(String nickname, phoneNumber, birthday, int gender, List<int> termIndex) async {
    String? idToken = AuthController.to.idToken;
    User? user = AuthController.to.user.value;

    if (!await AuthController.to.checkTokenValid()) idToken = AuthController.to.idToken;

    if (idToken != null && user != null) {
      Map<String, dynamic> profileData = {
        "nickname": nickname,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "birthday": birthday,
        "termIndex": termIndex
      };
      _progressDialogHelper.showProgressDialog('프로필 생성중');
      int? result = await _userProvider.createProfile(profileData, idToken);
      _progressDialogHelper.hideProgressDialog();
      if (result == 200) {
        int? status = await getUserProfile(user!.uid);
        if (status == 200) {
          Get.offAll(() => const MyApp());
        } else {
          Get.dialog(
              AlertDialog(
                title: Text("회원가입 오류"),
                content: Text("회원가입 처리 중 오류가 발생했습니다. 회원가입을 다시 진행해주세요."),
                actions: [
                  TextButton(
                      onPressed: () {
                        AuthController.to.signOut();
                      },
                      child: Text("확인")
                  ),
                ],
              )
          );
        }
      } else {
        Get.dialog(
          AlertDialog(
            title: Text("회원가입 오류"),
            content: Text("회원가입 처리 중 오류가 발생했습니다. 회원가입을 다시 진행해주세요."),
            actions: [
              TextButton(
                  onPressed: () {
                    AuthController.to.signOut();
                  },
                  child: Text("확인")
              ),
            ],
          )
        );
      }
    } else {
      Get.dialog(
        AlertDialog(
          title: Text("회원가입 오류"),
          content: Text("회원가입을 다시 진행해주세요."),
          actions: [
            TextButton(
                onPressed: () {
                  AuthController.to.signOut();
                },
                child: Text("확인")
            ),
          ],
        )
      );
    }
    // return null;
  }

  Future<bool> changeUserProfile(String nickname, phoneNumber, birthday, int gender) async {
    String? idToken = AuthController.to.idToken;
    User? user = AuthController.to.user.value;

    if (!await AuthController.to.checkTokenValid()) idToken = AuthController.to.idToken;

    if (idToken != null && user != null) {
      Map<String, dynamic> profileData = {
        "userIndex": user.uid,
        "nickname": nickname,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "birthday": birthday,
      };
      _progressDialogHelper.showProgressDialog('프로필 수정중');
      int? result = await _userProvider.patchProfile(profileData, idToken);
      _progressDialogHelper.hideProgressDialog();
      if (result == 200) {
        int? status = await getUserProfile(user!.uid);
        if (status == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}