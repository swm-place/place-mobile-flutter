import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_mobile_flutter/page/account/login.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/widget/section/main_section.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  bool get wantKeepAlive => true;

  Widget _createProfileSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://source.unsplash.com/random'),
            ),
          ),
          SizedBox(width: 12,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 12,),
                Text("닉네임", style: PageTextStyle.headlineBold(Colors.black),),
                SizedBox(height: 6,),
                Row(
                  children: [
                    Text("팔로워 20", style: SectionTextStyle.labelMedium(Colors.black),),
                    SizedBox(width: 12,),
                    Text("팔로잉 20", style: SectionTextStyle.labelMedium(Colors.black),),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createAccountPref() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: MainSection(
          title: "계정",
          content: Text("계정")
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _createProfileSection(),
              _createAccountPref()
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   super.build(context);
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Center(
  //         child: GetBuilder<AuthController>(
  //           init: AuthController(),
  //           builder: (controller) {
  //             if (controller.user.value == null) {
  //               return FilledButton(child: Text("로그인"), onPressed: () => {
  //                 Get.to(() => LoginPage())
  //               });
  //             } else {
  //               return FilledButton(child: Text("로그아웃"), onPressed: () => {
  //                 controller.signOut()
  //               });
  //             }
  //           },
  //         )
  //       ),
  //     ),
  //   );
  // }
}