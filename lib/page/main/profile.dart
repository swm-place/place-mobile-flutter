import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/page/login.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GetBuilder<AuthController>(
            init: AuthController(),
            builder: (controller) {
              if (controller.user.value == null) {
                return FilledButton(child: Text("로그인"), onPressed: () => {
                  Get.to(() => LoginPage())
                });
              } else {
                return FilledButton(child: Text("로그아웃"), onPressed: () => {
                  controller.signOut()
                });
              }
            },
          )
        ),
      ),
    );
  }
}