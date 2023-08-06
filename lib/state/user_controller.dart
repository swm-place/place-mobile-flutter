import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';
import 'package:place_mobile_flutter/main.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  UserProvider _userProvider = UserProvider();

  RxnString nickname = RxnString();
  RxnString email = RxnString();
  RxnString phoneNumber = RxnString();
  RxnInt gender = RxnInt();
  RxnString birthday = RxnString();

  Future<int?> getUserProfile(User? user) async {
    String? idToken = AuthController.to.idToken;
    // print('getUsaerProfile: $idToken');
    if (idToken != null) {
      http.Response? response = await _userProvider.getProfile(idToken, user);
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
    }
    return null;
  }

  void makeUserProfile(BuildContext context, String nickname, phoneNumber, birthday, int gender, List<int> termIndex) async {
    String? idToken = AuthController.to.idToken;
    if (idToken != null) {
      Map<String, dynamic> profileData = {
        "nickname": nickname,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "birthday": birthday,
        "termIndex": termIndex
      };
      int? result = await _userProvider.createProfile(profileData, idToken);
      if (result == 200) {
        await getUserProfile(AuthController.to.user.value);
        Get.offAll(() => const MyApp());
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
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
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("회원가입 오류"),
            content: Text("회원가입을 다시 진행해주세요."),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.offAll(() => const MyApp());
                  },
                  child: Text("확인")
              ),
            ],
          );
        },
      );
    }
    // return null;
  }
}