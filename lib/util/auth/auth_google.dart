import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/util/auth/auth_social.dart';
import 'package:place_mobile_flutter/widget/get_snackbar.dart';

class FirebaseAuthGoogle extends FirebaseAuthSocial {
  FirebaseAuthGoogle({
    required this.authInstance,
  }) : super(authInstance: authInstance);

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

      return await login(credential);
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

  Future<void> linkGoogle(User? user) async {
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

      await link(user, credential, 'google.com');
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

  Future<void> unLinkGoogle(User? user) async {
    await unLink(user, 'google.com');
  }
}