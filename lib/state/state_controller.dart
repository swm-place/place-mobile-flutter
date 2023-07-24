import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/main.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  FirebaseAuth authInstance = FirebaseAuth.instance;

  late Rx<User?> user = Rx<User?>(authInstance.currentUser);
  late Rx<String?> idToken = Rx<String?>(null);
  // String? token;

  Stream<String?> getIdTokenStream() async* {
    await for (final User? user in user.stream) {
      if (user != null) {
        final String? idToken = await user.getIdToken();
        print("user: ${user.email}\nidToken: $idToken");
        yield idToken;
      } else {
        print("idToken: null");
        yield null;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    idToken.bindStream(getIdTokenStream());
    user.bindStream(authInstance.userChanges());
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
    Get.offAll(() => const MyApp());
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
    Get.offAll(() => const MyApp());
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
      Get.offAll(() => const MyApp());
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