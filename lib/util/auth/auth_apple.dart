import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:place_mobile_flutter/util/auth/auth_social.dart';
import 'package:place_mobile_flutter/widget/get_snackbar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:get/get.dart';

class FirebaseAuthApple extends FirebaseAuthSocial {
  FirebaseAuthApple({
    required this.authInstance,
  }) : super(authInstance: authInstance);

  FirebaseAuth authInstance;

  Future<User?> signInApple() async {
    try {
      AuthorizationCredentialAppleID appleCredential;
      if (Platform.isIOS) {
        appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
      } else {
        String redirectUri = 'https://alike-cuboid-marten.glitch.me/callbacks/sign_in_with_apple';
        String clientId = 'place.ours.com';
        appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
              clientId: clientId,
              redirectUri: Uri.parse(redirectUri)
          ),
        );
      }

      final credential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode
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

  Future<void> linkApple(User? user) async {
    try {
      AuthorizationCredentialAppleID appleCredential;
      if (Platform.isIOS) {
        appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
      } else {
        String redirectUri = 'https://alike-cuboid-marten.glitch.me/callbacks/sign_in_with_apple';
        String clientId = 'place.ours.com';
        appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
              clientId: clientId,
              redirectUri: Uri.parse(redirectUri)
          ),
        );
      }

      final credential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode
      );

      await link(user, credential, 'apple.com');
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

  Future<void> unLinkApple(User? user) async {
    await unLink(user, 'apple.com');
  }
}