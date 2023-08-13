import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  String _parseJwtEmail(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    return payloadMap['email'];
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

  Future<void> getUser(User? user) async {
    print("user: $user");
    this.user.value = user;
    await getIdTokenStream(user);
    if (user != null) {
      _loginSuccess(user);
    } else {
      Get.offAll(() => const MyApp());
    }
  }

  @override
  void onReady() async {
    super.onReady();
    Get.put(ProfileController());
    // await authInstance.currentUser!;
  }

  void _loginSuccess(User user) async {
    int? status = await ProfileController.to.getUserProfile(user);
    print('login success $status ${Get.currentRoute}');
    if (status != null) {
      if (status == 200) {
        print("login success ${Get.currentRoute}");
        if (Get.currentRoute != "/MyApp" && Get.currentRoute != '/') {
          Get.offAll(() => const MyApp());
        }
      } else if (status == 400) {
        if (Get.currentRoute != "/SignUpPage") {
          Get.offAll(() => const MyApp());
          Get.to(() => SignUpPage());
        }
      } else {
        Get.showSnackbar(
            GetSnackBar(
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              titleText: const Text(
                "로그인 실패",
                style: TextStyle(color: Colors.white),
              ),
              messageText: Text(
                '로그인 과정에서 오류가 발생했습니다. 다시 로그인 해주세요.',
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 2),
            )
        );
        signOut();
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
      UserCredential userCredential = await authInstance.createUserWithEmailAndPassword(email: email, password: password);
      await getUser(userCredential.user);
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
      UserCredential userCredential = await authInstance.signInWithEmailAndPassword(email: email, password: password);
      await getUser(userCredential.user);
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

  void signInGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
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
              GetSnackBar(
                backgroundColor: Colors.red,
                snackPosition: SnackPosition.BOTTOM,
                titleText: const Text(
                  "로그인 실패",
                  style: TextStyle(color: Colors.white),
                ),
                messageText: Text(
                  '해당 SNS 계정과 연결된 OURS 계정이 없습니다. 로그인 이나 회원가입 후 계정을 연결해주세요.',
                  style: const TextStyle(color: Colors.white),
                ),
                duration: const Duration(seconds: 4),
              )
          );
        } else {
          await getUser(user);
          Get.showSnackbar(
              GetSnackBar(
                backgroundColor: Colors.blue,
                snackPosition: SnackPosition.BOTTOM,
                titleText: const Text(
                  "로그인 성공",
                  style: TextStyle(color: Colors.white),
                ),
                messageText: Text(
                  "'${user.email}'님, 환영합니다.",
                  style: const TextStyle(color: Colors.white),
                ),
                duration: const Duration(seconds: 2),
              )
          );
        }
      } else {
        Get.showSnackbar(
            GetSnackBar(
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              titleText: const Text(
                "로그인 실패",
                style: TextStyle(color: Colors.white),
              ),
              messageText: Text(
                '로그인 과정에서 오류가 발생했습니다. 다시 시도해주세요.',
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 4),
            )
        );
      }
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

  void signInApple() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try {
      // final rawNonce = AppleFirebaseCrypto.generateNonce();
      // final nonce = AppleFirebaseCrypto.sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
      );

      String? email = await sp.getString(appleCredential.userIdentifier!);
      if (email == null) {
        await sp.setString(appleCredential.userIdentifier!, appleCredential.email!);
        email = appleCredential.email!;
      }

      print(email);

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode
        // rawNonce: rawNonce,
      );

      return;

      // print(appleCredential);
      // String email = appleCredential.email!;
      //
      bool isLinked = true;
      try {
      //   final List<String> signInMethods = await authInstance.fetchSignInMethodsForEmail(email);
      //   for (var s in signInMethods) {
      //     if (s == 'password') {
      //       isLinked = true;
            await authInstance.signInWithCredential(oauthCredential);
      //       break;
      //     }
      //   }
      } catch(e) {
        print('appleError: ' + e.toString());
        isLinked = false;
      }

      if (isLinked) {
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
      } else {
        Get.showSnackbar(
            GetSnackBar(
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              titleText: const Text(
                "로그인 실패",
                style: TextStyle(color: Colors.white),
              ),
              messageText: Text(
                '해당 애플 계정과 연결된 계정이 없습니다. 다른 계정으로 시도하거나 회원가입을 먼저 진행해주세요.',
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 4),
            )
        );
      }
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

  void linkGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      if (user.value != null) {
        await user.value!.linkWithCredential(credential);
        Get.showSnackbar(
            GetSnackBar(
              backgroundColor: Colors.blue,
              snackPosition: SnackPosition.BOTTOM,
              titleText: const Text(
                "연동 성공",
                style: TextStyle(color: Colors.white),
              ),
              messageText: Text(
                "'${googleUser!.email} 계정과 연결했습니다. 이제 해당 구글 계정으로 로그인이 가능합니다.",
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 4),
            )
        );
      } else {
        Get.showSnackbar(
            GetSnackBar(
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              titleText: const Text(
                "연결 실패",
                style: TextStyle(color: Colors.white),
              ),
              messageText: Text(
                '구글 계정과 연결에 실패했습니다. 다시 시도해주세요.',
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 2),
            )
        );
      }
    } catch(e) {
      Get.showSnackbar(
        GetSnackBar(
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "연결 실패",
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

  void unLinkGoogle() async {
    try {
      List<UserInfo> userInfoList = user.value!.providerData;
      for (var i in userInfoList) {
        if (i.providerId == 'google.com') {
          String? email = i.email;
          email ??= '구글 계정';
          await user.value!.unlink(i.providerId);
          Get.showSnackbar(
              GetSnackBar(
                backgroundColor: Colors.blue,
                snackPosition: SnackPosition.BOTTOM,
                titleText: const Text(
                  "연결 해제 성공",
                  style: TextStyle(color: Colors.white),
                ),
                messageText: Text(
                  "${email}과 연결을 해제했습니다.",
                  style: const TextStyle(color: Colors.white),
                ),
                duration: const Duration(seconds: 2),
              )
          );
          return;
        }
      }
      Get.showSnackbar(
          GetSnackBar(
            backgroundColor: Colors.blue,
            snackPosition: SnackPosition.BOTTOM,
            titleText: const Text(
              "연결 해제 실패",
              style: TextStyle(color: Colors.white),
            ),
            messageText: Text(
              "연결된 구글 계정이 없습니다.",
              style: const TextStyle(color: Colors.white),
            ),
            duration: const Duration(seconds: 2),
          )
      );
    } catch(e) {
      Get.showSnackbar(
        GetSnackBar(
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "연결 해제 실페",
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
      await getUser(null);
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